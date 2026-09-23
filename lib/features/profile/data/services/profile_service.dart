import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileData {
  const ProfileData({
    required this.name,
    required this.email,
    required this.university,
    required this.department,
    required this.semester,
    required this.bio,
    required this.emailNotifications,
    required this.studyReminders,
    required this.aiSuggestions,
    required this.studentSince,
  });

  final String name;
  final String email;
  final String university;
  final String department;
  final String semester;
  final String bio;

  final bool emailNotifications;
  final bool studyReminders;
  final bool aiSuggestions;

  final String studentSince;

  factory ProfileData.fromMap(
    Map<String, dynamic> data, {
    required String fallbackEmail,
    required String fallbackName,
  }) {
    return ProfileData(
      name: _stringValue(
        data['name'],
        fallbackName,
      ),
      email: _stringValue(
        data['email'],
        fallbackEmail,
      ),
      university: _stringValue(
        data['university'],
        'Port City International University',
      ),
      department: _stringValue(
        data['department'],
        'Computer Science',
      ),
      semester: _stringValue(
        data['semester'],
        'Semester 7',
      ),
      bio: _stringValue(
        data['bio'],
        '',
      ),
      emailNotifications:
          _boolValue(
        data['emailNotifications'],
        true,
      ),
      studyReminders:
          _boolValue(
        data['studyReminders'],
        true,
      ),
      aiSuggestions:
          _boolValue(
        data['aiSuggestions'],
        true,
      ),
      studentSince: _stringValue(
        data['studentSince'],
        '2023',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'university': university,
      'department': department,
      'semester': semester,
      'bio': bio,
      'emailNotifications':
          emailNotifications,
      'studyReminders':
          studyReminders,
      'aiSuggestions':
          aiSuggestions,
      'studentSince':
          studentSince,
      'updatedAt':
          FieldValue.serverTimestamp(),
    };
  }

  static String _stringValue(
    dynamic value,
    String fallback,
  ) {
    if (value is String &&
        value.trim().isNotEmpty) {
      return value.trim();
    }

    return fallback;
  }

  static bool _boolValue(
    dynamic value,
    bool fallback,
  ) {
    if (value is bool) {
      return value;
    }

    return fallback;
  }
}

class ProfileService {
  ProfileService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth =
            auth ?? FirebaseAuth.instance,
        _firestore =
            firestore ??
                FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
      get _users =>
          _firestore.collection('users');

  User? get currentUser =>
      _auth.currentUser;

  Future<ProfileData> loadProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw const ProfileException(
        'No signed-in user found.',
      );
    }

    final document =
        await _users.doc(user.uid).get();

    if (!document.exists ||
        document.data() == null) {
      final profile = ProfileData(
        name: user.displayName?.trim().isNotEmpty ==
                true
            ? user.displayName!.trim()
            : 'Mohammad Aiman',
        email: user.email ?? '',
        university:
            'Port City International University',
        department: 'Computer Science',
        semester: 'Semester 7',
        bio: '',
        emailNotifications: true,
        studyReminders: true,
        aiSuggestions: true,
        studentSince: '2023',
      );

      await _users.doc(user.uid).set(
        profile.toMap(),
        SetOptions(merge: true),
      );

      return profile;
    }

    return ProfileData.fromMap(
      document.data()!,
      fallbackEmail: user.email ?? '',
      fallbackName:
          user.displayName?.trim().isNotEmpty ==
                  true
              ? user.displayName!.trim()
              : 'Mohammad Aiman',
    );
  }

  Future<void> saveProfile(
    ProfileData profile,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw const ProfileException(
        'No signed-in user found.',
      );
    }

    await _users.doc(user.uid).set(
      profile.toMap(),
      SetOptions(merge: true),
    );

    final name = profile.name.trim();

    if (name.isNotEmpty &&
        name != user.displayName) {
      await user.updateDisplayName(name);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

class ProfileException implements Exception {
  const ProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}