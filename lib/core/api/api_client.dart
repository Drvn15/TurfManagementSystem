import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  late Dio _dio;
  final SecureStorageService _storage = SecureStorageService();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://192.168.29.72:5000/api", // Use your computer's IP
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          print("🔑 API Request: ${options.method} ${options.path}");
          print("🔑 Token present: ${token != null}");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
            print("🔑 Authorization header added");
          } else {
            print("⚠️ No token found for request");
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          print("❌ API Error: ${error.response?.statusCode} - ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response.data;
    } catch (e) {
      print("GET Error: $e");
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.post(endpoint, data: body);
      return response.data;
    } catch (e) {
      print("POST Error: $e");
      rethrow;
    }
  }

  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.patch(endpoint, data: body);
      return response.data;
    } catch (e) {
      print("PATCH Error: $e");
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      print("🗑️ DELETE Request to: $endpoint");
      final response = await _dio.delete(endpoint);
      print("✅ DELETE Response: ${response.statusCode}");
      return response.data;
    } catch (e) {
      print("❌ DELETE Error: $e");
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.put(endpoint, data: body);
      return response.data;
    } catch (e) {
      print("PUT Error: $e");
      rethrow;
    }
  }
}