# Aquaculture CRUD Module Documentation

This document describes the design, layout, query filtering, and automation logic of the Aquaculture CRUD module in both the Flutter mobile frontend and the Laravel backend API.

---

## 1. Adaptive 2-Pane UI Layout

To support a premium tablet and desktop experience, the Aquaculture CRUD screens dynamically adapt based on screen width using `responsive_framework`:

* **Mobile Layout (Single Pane)**:
  Renders the standard list screen. Tapping an item navigates to a detail page, and tapping "Add" or "Edit" pushes a new full-screen route for the CRUD form.
* **Tablet / Desktop Layout (Split 2-Pane)**:
  Activated when the screen width is larger than standard mobile sizes:
  - **Left Pane (60% width)**: Shows the search bar and the list of records.
  - **Right Pane (40% width)**: Houses the interactive details/action panel. When a user clicks "Add" or "Edit", the form `AquacultureCrudFormScreen` is instantiated with `isEmbedded: true` and rendered **directly inside the right pane** instead of pushing a new full-screen route. Saving the form automatically triggers a refresh on the left list view.

---

## 2. Multi-Company Scoping & Switcher

Data is scoped to the currently active company selected via the global **CompanySwitcher** widget:

1. **State Synchronization**:
   - The list screen watches the selected company using `ref.watch(selectedCompanyProvider)`. Switching the company automatically invalidates the list state and fetches fresh data.
   - The company ID is sent to the backend as a `company_id` query parameter.
2. **Backend Scoping**:
   - For models with a direct `company_id` column (`tambaks`, `cycles`, `contracts`, `cost-centres`), the API directly scopes the query using `where('company_id', $company_id)`.
   - For models without a direct `company_id` column, the backend controller performs indirect relationship scoping:
     - `bloks`: scopes via the `tambak` relation.
     - `moduls`: scopes via the `blok.tambak` relation.
     - `ponds`: scopes via the `modul.blok.tambak` relation.
     - `saprotam-logs`: scopes via the `pond.modul.blok.tambak` relation.

---

## 3. Auto-Create Ponds (`jumlah_petak`)

When creating a new module, you can specify how many ponds (petaks) should be automatically created under it:

* **Frontend Field**:
  The form config defines the `jumlah_petak` field as `FieldType.number` in `aquaculture_crud_config.dart`. It includes inline help text: `"Contoh: 10 (isi 0 jika tidak ingin membuat)"`.
* **Backend Processing**:
  - The controller (`AquacultureCrudController.php`) validates the field as a nullable positive integer.
  - If a value is provided, it is extracted from the write payload (as it is not a direct column on the `aquaculture_moduls` table).
  - After the module record is saved, the API loops from `1` to `jumlah_petak` and creates/updates `AquaculturePond` records named `1` through `X` using the parent block's tambak name as the default `location`.

---

## 4. Cycle Cost Center Auto-Creation

When a new cycle (siklus) data is saved via the Flutter application or the admin panel, the backend automatically sets up corresponding cost centers:

* **Execution**:
  Runs transparently on the backend using the Eloquent model's `created` lifecycle event listener in `AquacultureCycle.php`.
* **Cost Center Structure**:
  1. **Parent Cost Center**: Formats a code like `[COMPANY_CODE].[BLOK][MODUL]00.[YEAR].[CYCLE_NAME]` for the entire module.
  2. **Child Cost Centers**: Creates child codes like `[COMPANY_CODE].[BLOK][MODUL][PADDED_POND_NAME].[YEAR].[CYCLE_NAME]` for each pond under the module, auto-mapping `luas` and `luas_m2`.

---

## 5. Shrimp Price Calculator

The application includes a specialized calculator screen (`/aquaculture/calculator`) that calculates the buying/selling price per kilogram of shrimp dynamically based on active contracts and brackets:

*   **Contract Lookup**: Matches the selected company to its active contracts (`wh_contracts`) and reads the configured bracket ranges (`min_size` and `max_size`).
*   **Bracket Matching**: Identifies the correct bracket based on the input size: `min_size <= input_size <= max_size`.
*   **Price Calculation Rules**:
    *   *Size* represents the number of shrimps per kilogram (larger size = smaller shrimp).
    *   **Base Price**: If `input_size == base_size`, the price equals `base_price`.
    *   **Price Reduction (Decrement)**: If `input_size > base_size` (smaller shrimp), a decrement is applied:
        $$\text{Final Price} = \text{base\_price} - (\text{input\_size} - \text{base\_size}) \times \text{price\_decrement}$$
    *   **Price Bonus (Increment)**: If `input_size < base_size` (larger shrimp), an increment is applied:
        $$\text{Final Price} = \text{base\_price} + (\text{base\_size} - \text{input\_size}) \times \text{price\_increment}$$
