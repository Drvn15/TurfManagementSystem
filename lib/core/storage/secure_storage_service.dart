import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      print("💾 saveToken: Saving token");
      await _storage.write(key: 'token', value: token);
      print("✅ saveToken: Token saved");
    } catch (e) {
      print("❌ saveToken error: $e");
      rethrow;
    }
  }

  Future<void> saveRole(String role) async {
    try {
      print("💾 saveRole: Saving role: $role");
      await _storage.write(key: 'role', value: role);
      print("✅ saveRole: Role saved");
    } catch (e) {
      print("❌ saveRole error: $e");
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: 'token');
      print("📖 getToken: ${token != null ? 'found' : 'not found'}");
      return token;
    } catch (e) {
      print("❌ getToken error: $e");
      return null;
    }
  }

  Future<String?> getRole() async {
    try {
      final role = await _storage.read(key: 'role');
      print("📖 getRole: $role");
      return role;
    } catch (e) {
      print("❌ getRole error: $e");
      return null;
    }
  }

  Future<void> clear() async {
    try {
      print("🗑️ clear: Clearing storage");
      await _storage.deleteAll();
      print("✅ clear: Storage cleared");
    } catch (e) {
      print("❌ clear error: $e");
      rethrow;
    }
  }
}