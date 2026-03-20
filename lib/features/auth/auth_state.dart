enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? role;

  AuthState({
    required this.status,
    this.token,
    this.role,
  });

  factory AuthState.initial() =>
      AuthState(status: AuthStatus.loading);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.token == token &&
        other.role == role;
  }

  @override
  int get hashCode => status.hashCode ^ token.hashCode ^ role.hashCode;
}

