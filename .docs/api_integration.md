# API Integration

## Authentication
The app uses **Laravel Sanctum** (Bearer Token) for authentication.

- **Token Storage**: Encrypted via `flutter_secure_storage`.
- **Injection**: Handled automatically in `DioClient` via `AuthInterceptor`.

## Multi-Company Context
The app supports multi-company access (Purchasing, BOD, etc.).
- **Query Parameter**: Every outgoing request automatically includes `?company_id=X`.
- **Handling**: Injected by `CompanyInterceptor` in `core/api/dio_client.dart`.

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
