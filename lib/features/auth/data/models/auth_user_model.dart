import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  const AuthUserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}