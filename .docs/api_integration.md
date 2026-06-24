# API Integration

## Authentication
The app uses **Laravel Sanctum** (Bearer Token) for authentication.

- **Token Storage**: Encrypted via `flutter_secure_storage`.
- **Injection**: Handled automatically in `DioClient` via `AuthInterceptor`.

## Multi-Company Context
The app supports multi-company access (Purchasing, BOD, etc.).
- **State Selection**: The active company is tracked globally via `selectedCompanyProvider` in `lib/core/providers/company_provider.dart`.
- **Query Parameter / Payload**: Outgoing requests query parameters or request body payloads include `company_id` manually when scoped by the active company (e.g. inside `receiving_repository.dart`, `pdf_preview_screen.dart`, etc.).
- **Local Filtering**: For screens that fetch all company records at once (e.g. `shrimp_price_calculator_screen.dart`), filtering by the selected company ID is performed locally.

## Pagination
The app expects a standard paginated response from Laravel:
```json
{
  "success": true,
  "data": [...],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "total": 100
  }
}
```
Handled via the generic `PaginatedResponse<T>` model in `core/api/paginated_response.dart`.

## Error Handling
Global error handling is implemented via Dio. HTTP 401 triggers an automatic logout/re-authentication flow in the `AuthProvider`.
