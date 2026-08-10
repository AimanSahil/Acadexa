import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// LOGIN
// ============================================================

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

// ============================================================
// REGISTER
// ============================================================

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
      ];
}

// ============================================================
// FORGOT PASSWORD
// ============================================================

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}

// ============================================================
// GOOGLE SIGN IN
// ============================================================

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

// ============================================================
// APPLE SIGN IN
// ============================================================

class AppleSignInRequested extends AuthEvent {
  const AppleSignInRequested();
}

// ============================================================
// LOGOUT
// ============================================================

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

// ============================================================
// CLEAR ERROR
// ============================================================

class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}