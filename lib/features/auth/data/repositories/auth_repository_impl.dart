import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  // ============================================================
  // LOGIN
  // ============================================================

  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await datasource.login(
      email: email,
      password: password,
    );

    final User? user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Login failed.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await datasource.register(
      name: name,
      email: email,
      password: password,
    );

    final User? user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Registration failed.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  // ============================================================
  // GOOGLE
  // ============================================================

  Future<AuthUserModel> signInWithGoogle() async {
    final UserCredential credential =
        await datasource.signInWithGoogle();

    final User? user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Google sign-in failed.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  // ============================================================
  // APPLE
  // ============================================================

  Future<AuthUserModel> signInWithApple() async {
    final UserCredential credential =
        await datasource.signInWithApple();

    final User? user = credential.user;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'Apple sign-in failed.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> forgotPassword({
    required String email,
  }) async {
    await datasource.sendPasswordResetEmail(
      email: email,
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    await datasource.logout();
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  AuthUserModel? get currentUser {
    final User? user = datasource.currentUser;

    if (user == null) {
      return null;
    }

    return AuthUserModel.fromFirebaseUser(user);
  }
}