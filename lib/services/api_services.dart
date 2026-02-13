import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000/api";
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: "jwt_token");

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // ---------------- GET USERS ----------------
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/users"),
    );

    return jsonDecode(response.body);
  }

  // ---------------- GET TURFS ----------------
  static Future<List<dynamic>> fetchTurfs() async {
    final response = await http.get(
      Uri.parse("$baseUrl/turfs"),
    );

    return jsonDecode(response.body);
  }

  // ---------------- CREATE TURF ----------------
  static Future<bool> createTurf(
      String name,
      String location,
      int price,
      String imageUrl,
      ) async {
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse("$baseUrl/turfs"),
      headers: headers,
      body: jsonEncode({
        "name": name,
        "location": location,
        "price_per_hour": price,
        "image_url": imageUrl,
      }),
    );

    return response.statusCode == 201;
  }

  // ---------------- DELETE TURF ----------------
  static Future<bool> deleteTurf(int id) async {
    final headers = await _getHeaders();

    final response = await http.delete(
      Uri.parse("$baseUrl/turfs/$id"),
      headers: headers,
    );

    return response.statusCode == 200;
  }
}
