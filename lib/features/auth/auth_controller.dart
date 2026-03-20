import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/secure_storage_service.dart';
import 'auth_state.dart';
import 'package:dio/dio.dart';

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.initial());

  final SecureStorageService _storage = SecureStorageService();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.29.72:5000/api", // change this if testing on other platforms
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  // 🔁 Restore session when app starts
  Future<void> restoreSession() async {
    final token = await _storage.getToken();
    final role = await _storage.getRole();

    if (token != null && role != null) {
      state = AuthState(
        status: AuthStatus.authenticated,
        token: token,
        role: role,
      );
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  // 🔐 Login
  Future<void> login(String phone, String password) async {
    state = AuthState(status: AuthStatus.loading);

    try {
      final response = await _dio.post(
        "/auth/login",
        data: {
          "phone": phone,
          "password": password,
        },
      );

      final token = response.data["token"];
      final role = response.data["user"]["role"];

      await _storage.saveToken(token);
      await _storage.saveRole(role);

      state = AuthState(
        status: AuthStatus.authenticated,
        token: token,
        role: role,
      );
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated);
      rethrow;
    }
  }

  // 🚪 Logout
  Future<void> logout() async {
    await _storage.clear();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}
