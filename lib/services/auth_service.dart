import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = "http://10.0.2.2:5000/api/auth";
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data["token"];

      await _storage.write(key: "jwt_token", value: token);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: "jwt_token");
  }

  Future<void> logout() async {
    await _storage.delete(key: "jwt_token");
  }
}
