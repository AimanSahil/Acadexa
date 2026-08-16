import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/auth_user_model.dart';

class AuthFirestoreDatasource {
  final FirebaseFirestore _firestore;

  AuthFirestoreDatasource(this._firestore);

  // ============================================================
  // USERS COLLECTION
  // ============================================================

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }

  // ============================================================
  // CREATE USER PROFILE
  // ============================================================

  Future<void> createUserProfile(
    AuthUserModel user,
  ) async {
    final userRef = _usersCollection.doc(user.uid);

    await userRef.set(
      user.toMap(),
      SetOptions(
        merge: true,
      ),
    );
  }

  // ============================================================
  // GET USER PROFILE
  // ============================================================

  Future<AuthUserModel?> getUserProfile(
    String uid,
  ) async {
    final snapshot = await _usersCollection.doc(uid).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return AuthUserModel.fromMap(
      snapshot.data()!,
    );
  }

  // ============================================================
  // CHECK USER PROFILE
  // ============================================================

  Future<bool> userProfileExists(
    String uid,
  ) async {
    final snapshot = await _usersCollection.doc(uid).get();

    return snapshot.exists;
  }

  // ============================================================
  // UPDATE USER PROFILE
  // ============================================================

  Future<void> updateUserProfile(
    AuthUserModel user,
  ) async {
    await _usersCollection.doc(user.uid).set(
      user.toMap(),
      SetOptions(
        merge: true,
      ),
    );
  }

  // ============================================================
  // DELETE USER PROFILE
  // ============================================================

  Future<void> deleteUserProfile(
    String uid,
  ) async {
    await _usersCollection.doc(uid).delete();
  }

  // ============================================================
  // CHECK ONBOARDING STATUS
  // ============================================================

  Future<bool> isOnboardingCompleted(
    String uid,
  ) async {
    final snapshot = await _usersCollection.doc(uid).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return false;
    }

    final data = snapshot.data()!;

    return data['onboardingCompleted'] == true;
  }

  // ============================================================
  // SAVE ONBOARDING DATA
  // ============================================================

  Future<void> saveOnboardingData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final userRef = _usersCollection.doc(uid);

    await userRef.set(
      {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );
  }
}