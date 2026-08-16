import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  // Academic profile
  final String? university;
  final String? major;
  final String? semester;

  // Preferences
  final bool emailNotifications;
  final bool studyReminders;
  final bool aiSuggestions;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthUserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.university,
    this.major,
    this.semester,
    this.emailNotifications = true,
    this.studyReminders = true,
    this.aiSuggestions = true,
    this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // FROM FIREBASE AUTH USER
  // ============================================================

  factory AuthUserModel.fromFirebaseUser(User user) {
    return AuthUserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  // ============================================================
  // FROM FIRESTORE
  // ============================================================

  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseTimestamp(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }

      if (value is DateTime) {
        return value;
      }

      return null;
    }

    return AuthUserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      university: map['university'] as String?,
      major: map['major'] as String?,
      semester: map['semester'] as String?,
      emailNotifications:
          map['emailNotifications'] as bool? ?? true,
      studyReminders:
          map['studyReminders'] as bool? ?? true,
      aiSuggestions:
          map['aiSuggestions'] as bool? ?? true,
      createdAt: parseTimestamp(map['createdAt']),
      updatedAt: parseTimestamp(map['updatedAt']),
    );
  }

  // ============================================================
  // TO FIRESTORE MAP
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,

      'university': university,
      'major': major,
      'semester': semester,

      'emailNotifications': emailNotifications,
      'studyReminders': studyReminders,
      'aiSuggestions': aiSuggestions,

      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),

      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  // ============================================================
  // COPY WITH
  // ============================================================

  AuthUserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? university,
    String? major,
    String? semester,
    bool? emailNotifications,
    bool? studyReminders,
    bool? aiSuggestions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      university: university ?? this.university,
      major: major ?? this.major,
      semester: semester ?? this.semester,
      emailNotifications:
          emailNotifications ?? this.emailNotifications,
      studyReminders:
          studyReminders ?? this.studyReminders,
      aiSuggestions:
          aiSuggestions ?? this.aiSuggestions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}