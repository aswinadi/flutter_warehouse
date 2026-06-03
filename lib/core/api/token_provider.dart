import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenProvider = Provider<TokenProvider>((ref) => TokenProvider());

class TokenProvider {
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _companyIdKey = 'current_company_id';
  static const _savedUsernameKey = 'saved_username';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveCompanyId(int companyId) async {
    await _storage.write(key: _companyIdKey, value: companyId.toString());
  }

  Future<int?> getCompanyId() async {
    final id = await _storage.read(key: _companyIdKey);
    return id != null ? int.tryParse(id) : null;
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: _savedUsernameKey, value: username);
  }

  Future<String?> getSavedUsername() async {
    return await _storage.read(key: _savedUsernameKey);
  }

  Future<void> clearSavedUsername() async {
    await _storage.delete(key: _savedUsernameKey);
  }
}
