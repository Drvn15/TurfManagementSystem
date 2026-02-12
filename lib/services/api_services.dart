import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  // Android emulator → 10.0.2.2
  // Web → localhost
  // Real device → your PC IP

  // -------- USERS --------
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // -------- TURFS --------
  static Future<List<dynamic>> fetchTurfs() async {
    final response = await http.get(Uri.parse('$baseUrl/turfs'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load turfs');
    }
  }

  // -------- ADD TURF (ADMIN) --------
  static Future<void> createTurf({
    required String name,
    required String location,
    required int pricePerHour,
    String imageUrl = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/turfs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'location': location,
        'price_per_hour': pricePerHour,
        'image_url': imageUrl,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add turf');
    }
  }
}
