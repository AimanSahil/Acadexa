import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasource {
  final FirebaseAuth _auth;

  AuthRemoteDatasource(this._auth);

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser => _auth.currentUser;

  // ============================================================
  // LOGIN
  // ============================================================

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      await user.updateDisplayName(name.trim());
      await user.reload();
    }

    return credential;
  }

  // ============================================================
  // GOOGLE SIGN IN
  // ============================================================

  Future<UserCredential> signInWithGoogle() async {
    // ----------------------------------------------------------
    // WEB
    // ----------------------------------------------------------

    if (kIsWeb) {
      final GoogleAuthProvider provider = GoogleAuthProvider();

      provider.setCustomParameters({
        'prompt': 'select_account',
      });

      return await _auth.signInWithPopup(provider);
    }

    // ----------------------------------------------------------
    // ANDROID / IOS
    // ----------------------------------------------------------

    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final OAuthCredential credential =
        GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  // ============================================================
  // APPLE SIGN IN
  // ============================================================

  Future<UserCredential> signInWithApple() async {
    final AppleAuthProvider provider = AppleAuthProvider();

    // Web
    if (kIsWeb) {
      return await _auth.signInWithPopup(provider);
    }

    // Android / iOS
    return await _auth.signInWithProvider(provider);
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    await _auth.signOut();

    // Sign out Google as well when applicable.
    if (!kIsWeb) {
      try {
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Ignore Google sign-out errors.
      }
    }
  }
}