import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/auth_firestore_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl {
  final AuthRemoteDatasource datasource;
  final AuthFirestoreDatasource firestoreDatasource;

  AuthRepositoryImpl(
    this.datasource,
    this.firestoreDatasource,
  );

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

    // ------------------------------------------------------------
    // Load existing Firestore profile
    // ------------------------------------------------------------

    final AuthUserModel? existingProfile =
        await firestoreDatasource.getUserProfile(user.uid);

    if (existingProfile != null) {
      return existingProfile;
    }

    // ------------------------------------------------------------
    // Safety fallback
    // Firebase Auth exists but Firestore profile doesn't
    // ------------------------------------------------------------

    final AuthUserModel profile =
        AuthUserModel.fromFirebaseUser(user);

    await firestoreDatasource.createUserProfile(profile);

    return profile;
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

    // ------------------------------------------------------------
    // Create Firestore user profile
    // ------------------------------------------------------------

    final AuthUserModel profile = AuthUserModel(
      uid: user.uid,
      name: name.trim(),
      email: user.email ?? email.trim(),
      photoUrl: user.photoURL,

      // Academic profile
      university: null,
      major: null,
      semester: null,

      // Default preferences
      emailNotifications: true,
      studyReminders: true,
      aiSuggestions: true,

      // Timestamps
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await firestoreDatasource.createUserProfile(profile);

    return profile;
  }

  // ============================================================
  // GOOGLE SIGN IN
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

    return await _getOrCreateSocialProfile(user);
  }

  // ============================================================
  // APPLE SIGN IN
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

    return await _getOrCreateSocialProfile(user);
  }

  // ============================================================
  // SOCIAL PROFILE HELPER
  // ============================================================

  Future<AuthUserModel> _getOrCreateSocialProfile(
    User user,
  ) async {
    // ------------------------------------------------------------
    // Check whether Firestore profile already exists
    // ------------------------------------------------------------

    final AuthUserModel? existingProfile =
        await firestoreDatasource.getUserProfile(user.uid);

    if (existingProfile != null) {
      return existingProfile;
    }

    // ------------------------------------------------------------
    // No Firestore profile exists
    // Create one
    // ------------------------------------------------------------

    final AuthUserModel profile =
        AuthUserModel.fromFirebaseUser(user);

    await firestoreDatasource.createUserProfile(profile);

    return profile;
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

  // ============================================================
  // GET CURRENT FIRESTORE PROFILE
  // ============================================================

  Future<AuthUserModel?> getCurrentUserProfile() async {
    final User? user = datasource.currentUser;

    if (user == null) {
      return null;
    }

    // ------------------------------------------------------------
    // Try to get existing Firestore profile
    // ------------------------------------------------------------

    final AuthUserModel? profile =
        await firestoreDatasource.getUserProfile(user.uid);

    if (profile != null) {
      return profile;
    }

    // ------------------------------------------------------------
    // Safety fallback
    // Firebase Auth user exists but Firestore profile doesn't
    // ------------------------------------------------------------

    final AuthUserModel newProfile =
        AuthUserModel.fromFirebaseUser(user);

    await firestoreDatasource.createUserProfile(newProfile);

    return newProfile;
  }

  // ============================================================
  // CHECK ONBOARDING STATUS
  // ============================================================

  Future<bool> isOnboardingCompleted() async {
    final User? user = datasource.currentUser;

    if (user == null) {
      return false;
    }

    return await firestoreDatasource.isOnboardingCompleted(
      user.uid,
    );
  }

  // ============================================================
  // SAVE ONBOARDING DATA
  // ============================================================

  Future<void> saveOnboardingData({
    required Map<String, dynamic> data,
  }) async {
    final User? user = datasource.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-null',
        message: 'No authenticated user found.',
      );
    }

    await firestoreDatasource.saveOnboardingData(
      uid: user.uid,
      data: data,
    );
  }
}