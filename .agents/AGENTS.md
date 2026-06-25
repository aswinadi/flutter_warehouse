# Flutter Warehouse Project Rules

All developers and agent assistants working on the Flutter Warehouse project must strictly adhere to the following guidelines:

1. **Design Ground Truth**:
   - Always refer to [designs.md](file:///c:/Projects/flutter_warehouse/designs.md) as the ground truth for UI design rules, color palettes, typography, spacing, shapes/border radius, layout grid, and Flutter widgets implementation.
   - Every user interface element, screen, switch, dialog, list, radio button, checklist, and search field must follow the **iOS 26 Cupertino Liquid Glass** design guidelines. Do not implement generic Material UI styles.
   - Any new screen must integrate the **Company Filter** as defined in the multi-company architecture rules.

2. **Behavior & PRD Ground Truth**:
   - Always refer to [PRD-WAREHOUSE-CORE.md](file:///c:/Projects/filament_warehouse/PRD-WAREHOUSE-CORE.md) as the functional specification for warehouse rules, item movements, mutations, stock calculations, and operational flows.

3. **API & Schema Ground Truth**:
   - Always refer to [API-CONTRACT-WAREHOUSE.md](file:///c:/Projects/filament_warehouse/API-CONTRACT-WAREHOUSE.md) for route endpoints, request/response models, query parameters, and JSON payloads. Do not deviate from these interfaces without documentation updates.

