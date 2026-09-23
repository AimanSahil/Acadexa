import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:acadexa/core/widgets/main_app_shell.dart';
import '../../data/services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ---------------------------------------------------------------------------
  // SERVICES
  // ---------------------------------------------------------------------------
  final ProfileService _profileService = ProfileService();

  // ---------------------------------------------------------------------------
  // COLORS
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFF020617);
  static const Color card = Color(0xFF080D1F);
  static const Color cardSecondary = Color(0xFF0B1225);
  static const Color border = Color(0xFF25304A);

  static const Color purple = Color(0xFF7C3AED);
  static const Color brightPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFA78BFA);

  static const Color red = Color(0xFFEF3340);

  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;

  bool _emailNotifications = true;
  bool _studyReminders = true;
  bool _aiSuggestions = true;

  String _studentSince = '2023';

  Uint8List? _profileImageBytes;
  bool _isUploadingImage = false;
  // ---------------------------------------------------------------------------
  // CONTROLLERS
  // ---------------------------------------------------------------------------
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _universityController;
  late final TextEditingController _departmentController;
  late final TextEditingController _semesterController;
  late final TextEditingController _bioController;
  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: 'Mohammad Aiman',
    );

    _emailController = TextEditingController(
      text: 'mohammadaiman.cse@gmail.com',
    );

    _universityController = TextEditingController(
      text: 'Port City International University',
    );

    _departmentController = TextEditingController(
      text: 'Computer Science',
    );

    _semesterController = TextEditingController(
      text: 'Semester 7',
    );

    _bioController = TextEditingController();

    _loadProfile();
  }
  // ---------------------------------------------------------------------------
  // LOAD PROFILE
  // ---------------------------------------------------------------------------
  Future<void> _loadProfile() async {
    try {
      final ProfileData profile =
          await _profileService.loadProfile();

      if (!mounted) return;

      setState(() {
        _nameController.text = profile.name;
        _emailController.text = profile.email;

        _universityController.text =
            profile.university;

        _departmentController.text =
            profile.department;

        _semesterController.text =
            profile.semester;

        _bioController.text = profile.bio;

        _emailNotifications =
            profile.emailNotifications;

        _studyReminders =
            profile.studyReminders;

        _aiSuggestions =
            profile.aiSuggestions;

        _studentSince =
            profile.studentSince;

        _isLoading = false;
      });

      await _loadProfileImage();
    } on ProfileException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(e.message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Could not load your profile.',
      );
    }
  }
  Future<void> _loadProfileImage() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final Map<String, dynamic>? data = snapshot.data();
      final String? imageBase64 =
          data?['profileImageBase64'] as String?;

      if (imageBase64 == null || imageBase64.isEmpty) {
        return;
      }

      final Uint8List bytes = base64Decode(imageBase64);

      if (!mounted) {
        return;
      }

      setState(() {
        _profileImageBytes = bytes;
      });
    } catch (e) {
      debugPrint('PROFILE IMAGE LOAD ERROR: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _universityController.dispose();
    _departmentController.dispose();
    _semesterController.dispose();
    _bioController.dispose();

    super.dispose();
  }
  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/profile',
      child: Scaffold(
        backgroundColor: background,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: brightPurple,
                ),
              )
            : LayoutBuilder(
                builder: (
                  context,
                  constraints,
                ) {
                  final bool isMobile =
                      constraints.maxWidth < 850;

                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 18 : 28,
                        isMobile ? 20 : 28,
                        isMobile ? 18 : 28,
                        30,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(
                            isMobile,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _buildProfileHeader(
                            isMobile,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _buildStats(
                            isMobile,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          if (_isEditing) ...[
                            _buildEditProfile(
                              isMobile,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                          ],

                          _buildPreferences(
                            isMobile,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // PAGE HEADER
  // ---------------------------------------------------------------------------
  Widget _buildPageHeader(
    bool isMobile,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
        ),

        const SizedBox(width: 10),

        const Icon(
          Icons.auto_awesome,
          color: brightPurple,
          size: 22,
        ),

        const Spacer(),

        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _isEditing = !_isEditing;
            });
          },
          icon: Icon(
            _isEditing
                ? Icons.close_rounded
                : Icons.edit_outlined,
            size: 18,
          ),
          label: Text(
            _isEditing
                ? 'Close Edit'
                : 'Edit Profile',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFF35436B),
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 13,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(11),
            ),
          ),
        ),
      ],
    );
  }
  // ---------------------------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------------------------
  Widget _buildProfileHeader(
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 18 : 34,
        isMobile ? 20 : 27,
        isMobile ? 18 : 32,
        isMobile ? 20 : 27,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF6532D8),
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(
              alpha: 0.08,
            ),
            blurRadius: 25,
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildAvatar(),

                const SizedBox(
                  height: 18,
                ),

                _buildProfileInformation(),

                const SizedBox(
                  height: 18,
                ),

                _buildLogoutButton(),
              ],
            )
          : Row(
              children: [
                _buildAvatar(),

                const SizedBox(
                  width: 32,
                ),

                Expanded(
                  child:
                      _buildProfileInformation(),
                ),

                const SizedBox(
                  width: 20,
                ),

                _buildLogoutButton(),
              ],
            ),
    );
  }
  // ---------------------------------------------------------------------------
  // AVATAR
  // ---------------------------------------------------------------------------
  Widget _buildAvatar() {
    return SizedBox(
      width: 132,
      height: 150,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 122,
            height: 122,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF0EAFE),
                  Color(0xFFB9A8F8),
                ],
              ),
              border: Border.all(
                color: brightPurple,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: brightPurple.withValues(alpha: 0.28),
                  blurRadius: 24,
                ),
              ],
              image: _profileImageBytes != null
                  ? DecorationImage(
                      image: MemoryImage(_profileImageBytes!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _profileImageBytes == null
                ? Center(
                    child: Text(
                      _initials(_nameController.text),
                      style: const TextStyle(
                        color: Color(0xFF5030D6),
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : null,
          ),

          Positioned(
            right: 0,
            bottom: 18,
            child: Tooltip(
              message: 'Upload your Image',
              child: Material(
                color: const Color(0xFF111827),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: _isUploadingImage
                      ? null
                      : _uploadProfileImage,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: brightPurple,
                        width: 2,
                      ),
                    ),
                    child: _isUploadingImage
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: lightPurple,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: _isUploadingImage
                  ? null
                  : _uploadProfileImage,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: const Color(0xFF334155),
                  ),
                ),
                child: const Text(
                  'Upload your Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadProfileImage() async {
    try {
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.image,
        dialogTitle: 'Choose your profile image',
      );

      if (file == null) {
        return;
      }

      final Uint8List bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        _showMessage('Could not read the selected image.');
        return;
      }

      // Firestore documents are limited to 1 MiB. Base64 adds overhead,
      // so keep the source image comfortably below that limit.
      const int maxImageBytes = 750 * 1024;

      if (bytes.length > maxImageBytes) {
        _showMessage(
          'Please choose an image smaller than 750 KB.',
        );
        return;
      }

      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _showMessage(
          'Please log in before uploading a profile image.',
        );
        return;
      }

      setState(() {
        _isUploadingImage = true;
        _profileImageBytes = bytes;
      });

      final String imageBase64 = base64Encode(bytes);

      debugPrint(
        'PROFILE IMAGE: Saving ${bytes.length} bytes to Firestore...',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        <String, dynamic>{
          'profileImageBase64': imageBase64,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _profileImageBytes = bytes;
        _isUploadingImage = false;
      });

      _showMessage(
        'Profile image updated successfully.',
      );
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUploadingImage = false;
      });

      debugPrint(
        'PROFILE IMAGE FIREBASE ERROR: '
        '${e.code} - ${e.message}',
      );

      _showMessage(
        e.message ?? 'Could not save profile image.',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUploadingImage = false;
      });

      debugPrint(
        'PROFILE IMAGE ERROR: $e',
      );

      _showMessage(
        'Could not save your profile image.',
      );
    }
  }

  String _initials(String name) {
    final String value = name.trim();

    if (value.isEmpty) {
      return 'MA';
    }

    final List<String> parts =
        value.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      final String word = parts.first;

      if (word.length >= 2) {
        return word
            .substring(0, 2)
            .toUpperCase();
      }

      return word.toUpperCase();
    }

    return (
      parts.first[0] +
      parts.last[0]
    ).toUpperCase();
  }
  // ---------------------------------------------------------------------------
  // PROFILE INFORMATION
  // ---------------------------------------------------------------------------
  Widget _buildProfileInformation() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          _nameController.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          _emailController.text,
          style: const TextStyle(
            color: Color(0xFFB9C2DD),
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 17),

        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _buildInfoChip(
              icon:
                  Icons.account_balance_outlined,
              text:
                  _universityController.text,
            ),

            _buildInfoChip(
              icon: Icons.code_rounded,
              text:
                  _departmentController.text,
            ),

            _buildInfoChip(
              icon: Icons.school_outlined,
              text:
                  _semesterController.text,
            ),
          ],
        ),
      ],
    );
  }
  // ---------------------------------------------------------------------------
  // INFO CHIP
  // ---------------------------------------------------------------------------
  Widget _buildInfoChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF080E20),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF263352),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: brightPurple,
            size: 17,
          ),

          const SizedBox(width: 8),

          Text(
            text,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // LOGOUT BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildLogoutButton() {
    return OutlinedButton.icon(
      onPressed: _logout,
      icon: const Icon(
        Icons.logout_rounded,
        size: 20,
      ),
      label: const Text(
        'Logout',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: red,
        side: const BorderSide(
          color: Color(0xFFE52A4D),
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(11),
        ),
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // STATS
  // ---------------------------------------------------------------------------
  Widget _buildStats(
    bool isMobile,
  ) {
    final List<_StatData> stats = [
      const _StatData(
        icon:
            Icons.local_fire_department_outlined,
        value: '7 days',
        label: 'Study Streak',
      ),
      _StatData(
        icon: Icons.school_outlined,
        value: _studentSince,
        label: 'Student Since',
      ),
      const _StatData(
        icon: Icons.person_outline_rounded,
        value: 'Active',
        label: 'Status',
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (
            int i = 0;
            i < stats.length;
            i++
          ) ...[
            _buildStatCard(
              stats[i],
            ),

            if (i !=
                stats.length - 1)
              const SizedBox(
                height: 12,
              ),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (
          int i = 0;
          i < stats.length;
          i++
        ) ...[
          Expanded(
            child:
                _buildStatCard(
              stats[i],
            ),
          ),

          if (i !=
              stats.length - 1)
            const SizedBox(
              width: 20,
            ),
        ],
      ],
    );
  }
  // ---------------------------------------------------------------------------
  // STAT CARD
  // ---------------------------------------------------------------------------
  Widget _buildStatCard(
    _StatData stat,
  ) {
    return Container(
      height: 172,
      padding:
          const EdgeInsets.fromLTRB(
        24,
        22,
        24,
        15,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF21104C,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
                child: Icon(
                  stat.icon,
                  color: lightPurple,
                  size: 27,
                ),
              ),

              const SizedBox(
                width: 16,
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    stat.value,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 25,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    stat.label,
                    style:
                        const TextStyle(
                      color:
                          Color(
                        0xFFB7C0DA,
                      ),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          if (stat.label ==
              'Status')
            Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration:
                      const BoxDecoration(
                    color:
                        Color(
                      0xFF00E5A0,
                    ),
                    shape:
                        BoxShape.circle,
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                const Text(
                  'Online',
                  style:
                      TextStyle(
                    color:
                        Color(
                      0xFF00E5A0,
                    ),
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            )
          else
            _buildSparkline(),
        ],
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // SPARKLINE
  // ---------------------------------------------------------------------------
  Widget _buildSparkline() {
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: CustomPaint(
        painter:
            _SparklinePainter(),
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // EDIT PROFILE
  // ---------------------------------------------------------------------------
  Widget _buildEditProfile(
    bool isMobile,
  ) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        22,
        20,
        22,
        20,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          if (isMobile)
            Column(
              children: [
                _buildTextField(
                  label: 'Full Name',
                  controller:
                      _nameController,
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildTextField(
                  label: 'Email',
                  controller:
                      _emailController,
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildTextField(
                  label: 'University',
                  controller:
                      _universityController,
                  focused: true,
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildTextField(
                  label: 'Department',
                  controller:
                      _departmentController,
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildTextField(
                  label: 'Semester',
                  controller:
                      _semesterController,
                ),

                const SizedBox(
                  height: 15,
                ),

                _buildTextField(
                  label: 'Bio',
                  controller:
                      _bioController,
                  hint:
                      'Tell us a bit about yourself...',
                  maxLines: 3,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Full Name',
                        controller:
                            _nameController,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _buildTextField(
                        label: 'University',
                        controller:
                            _universityController,
                        focused: true,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _buildTextField(
                        label: 'Semester',
                        controller:
                            _semesterController,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _buildTextField(
                        label: 'Bio',
                        controller:
                            _bioController,
                        hint:
                            'Tell us a bit about yourself...',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Expanded(
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Email',
                        controller:
                            _emailController,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      _buildTextField(
                        label: 'Department',
                        controller:
                            _departmentController,
                      ),
                    ],
                  ),
                ),
              ],
            ),

          const SizedBox(
            height: 18,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed:
                    _isSaving
                        ? null
                        : _cancelEdit,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 17,
                ),
                label:
                    const Text('Cancel'),
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      Colors.white,
                  side:
                      const BorderSide(
                    color:
                        Color(0xFF35415E),
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      9,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              FilledButton.icon(
                onPressed:
                    _isSaving
                        ? null
                        : _saveProfile,
                icon: _isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.save_outlined,
                        size: 17,
                      ),
                label: Text(
                  _isSaving
                      ? 'Saving...'
                      : 'Save Changes',
                ),
                style:
                    FilledButton.styleFrom(
                  backgroundColor:
                      purple,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // TEXT FIELD
  // ---------------------------------------------------------------------------
  Widget _buildTextField({
    required String label,
    required TextEditingController
        controller,
    String? hint,
    bool focused = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          decoration:
              InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
            ),
            filled: true,
            fillColor: cardSecondary,
            contentPadding:
                const EdgeInsets
                    .symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                8,
              ),
              borderSide:
                  BorderSide(
                color: focused
                    ? brightPurple
                    : const Color(
                        0xFF293653,
                      ),
              ),
            ),
            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                8,
              ),
              borderSide:
                  const BorderSide(
                color: brightPurple,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PREFERENCES
  // ---------------------------------------------------------------------------

  Widget _buildPreferences(
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(
          22,
          20,
          22,
          8,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            _buildPreferenceRow(
              icon:
                  Icons.notifications_none_rounded,
              title:
                  'Email Notifications',
              description:
                  'Receive important updates about learning tasks and exams',
              value:
                  _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications =
                      value;
                });

                _savePreferences();
              },
            ),

            _buildPreferenceRow(
              icon:
                  Icons.calendar_month_outlined,
              title:
                  'Study Reminders',
              description:
                  'Daily reminders to maintain your study streak',
              value:
                  _studyReminders,
              onChanged: (value) {
                setState(() {
                  _studyReminders =
                      value;
                });

                _savePreferences();
              },
            ),

            _buildPreferenceRow(
              icon:
                  Icons.auto_awesome,
              title:
                  'AI Suggestions',
              description:
                  'Get personalized study suggestions on your dashboard',
              value:
                  _aiSuggestions,
              onChanged: (value) {
                setState(() {
                  _aiSuggestions =
                      value;
                });

                _savePreferences();
              },
              last: true,
            ),
          ],
        ),
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // PREFERENCE ROW
  // ---------------------------------------------------------------------------
  Widget _buildPreferenceRow({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool>
        onChanged,
    bool last = false,
  }) {
    return Container(
      constraints:
          const BoxConstraints(
        minHeight: 82,
      ),
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(
                bottom: BorderSide(
                  color:
                      Color(0xFF18233B),
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFF21104C),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color: lightPurple,
              size: 22,
            ),
          ),

          const SizedBox(
            width: 14,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  description,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color:
                        Color(0xFFAAB4CE),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Switch(
            value: value,
            onChanged:
                _isSaving
                    ? null
                    : onChanged,
            activeThumbColor:
                Colors.white,
            activeTrackColor:
                purple,
            inactiveThumbColor:
                Colors.white,
            inactiveTrackColor:
                const Color(
              0xFF293653,
            ),
          ),
        ],
      ),
    );
  }
  // ---------------------------------------------------------------------------
  // SAVE PROFILE
  // ---------------------------------------------------------------------------
  Future<void> _saveProfile() async {
    if (_isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();

    final String name =
        _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Please enter your name.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final ProfileData profile =
          ProfileData(
        name: name,
        email:
            _emailController.text.trim(),
        university:
            _universityController.text
                .trim(),
        department:
            _departmentController.text
                .trim(),
        semester:
            _semesterController.text
                .trim(),
        bio:
            _bioController.text.trim(),
        emailNotifications:
            _emailNotifications,
        studyReminders:
            _studyReminders,
        aiSuggestions:
            _aiSuggestions,
        studentSince:
            _studentSince,
      );

      await _profileService
          .saveProfile(
        profile,
      );

      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _isEditing = false;
      });

      _showMessage(
        'Profile updated successfully.',
      );
    } on ProfileException catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showMessage(e.message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showMessage(
        'Could not save your profile.',
      );
    }
  }
  // ---------------------------------------------------------------------------
  // SAVE PREFERENCES
  // ---------------------------------------------------------------------------
  Future<void> _savePreferences() async {
    if (_isSaving) {
      return;
    }

    try {
      final ProfileData profile =
          ProfileData(
        name:
            _nameController.text.trim(),
        email:
            _emailController.text.trim(),
        university:
            _universityController.text
                .trim(),
        department:
            _departmentController.text
                .trim(),
        semester:
            _semesterController.text
                .trim(),
        bio:
            _bioController.text.trim(),
        emailNotifications:
            _emailNotifications,
        studyReminders:
            _studyReminders,
        aiSuggestions:
            _aiSuggestions,
        studentSince:
            _studentSince,
      );

      await _profileService
          .saveProfile(
        profile,
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Could not save preference.',
      );
    }
  }
  // ---------------------------------------------------------------------------
  // CANCEL EDIT
  // ---------------------------------------------------------------------------
  void _cancelEdit() {
    _loadProfile();
    
    setState(() {
      _isEditing = false;
    });
  }
  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------
  Future<void> _logout() async {
    try {
      await _profileService.logout();

      if (!mounted) return;

      context.go('/login');
    } on ProfileException catch (e) {
      if (!mounted) return;

      _showMessage(e.message);
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        'Could not log out.',
      );
    }
  }
  // ---------------------------------------------------------------------------
  // MESSAGE
  // ---------------------------------------------------------------------------
  void _showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}

// =============================================================================
// STAT DATA
// =============================================================================

class _StatData {
  const _StatData({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;
}
// =============================================================================
// SPARKLINE PAINTER
// =============================================================================
class _SparklinePainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint = Paint()
      ..color =
          const Color(0xFF8B3FFF)
      ..strokeWidth = 1.6
      ..style =
          PaintingStyle.stroke
      ..strokeCap =
          StrokeCap.round
      ..strokeJoin =
          StrokeJoin.round;

    final Path path = Path();

    final List<Offset> points = [
      Offset(
        0,
        size.height * 0.66,
      ),
      Offset(
        size.width * 0.04,
        size.height * 0.52,
      ),
      Offset(
        size.width * 0.08,
        size.height * 0.60,
      ),
      Offset(
        size.width * 0.12,
        size.height * 0.48,
      ),
      Offset(
        size.width * 0.16,
        size.height * 0.70,
      ),
      Offset(
        size.width * 0.20,
        size.height * 0.57,
      ),
      Offset(
        size.width * 0.24,
        size.height * 0.42,
      ),
      Offset(
        size.width * 0.28,
        size.height * 0.62,
      ),
      Offset(
        size.width * 0.32,
        size.height * 0.30,
      ),
      Offset(
        size.width * 0.36,
        size.height * 0.70,
      ),
      Offset(
        size.width * 0.40,
        size.height * 0.50,
      ),
      Offset(
        size.width * 0.44,
        size.height * 0.67,
      ),
      Offset(
        size.width * 0.48,
        size.height * 0.53,
      ),
      Offset(
        size.width * 0.52,
        size.height * 0.73,
      ),
      Offset(
        size.width * 0.56,
        size.height * 0.55,
      ),
      Offset(
        size.width * 0.60,
        size.height * 0.66,
      ),
      Offset(
        size.width * 0.64,
        size.height * 0.43,
      ),
      Offset(
        size.width * 0.68,
        size.height * 0.58,
      ),
      Offset(
        size.width * 0.72,
        size.height * 0.28,
      ),
      Offset(
        size.width * 0.76,
        size.height * 0.50,
      ),
      Offset(
        size.width * 0.80,
        size.height * 0.35,
      ),
      Offset(
        size.width * 0.84,
        size.height * 0.62,
      ),
      Offset(
        size.width * 0.88,
        size.height * 0.40,
      ),
      Offset(
        size.width * 0.92,
        size.height * 0.53,
      ),
      Offset(
        size.width,
        size.height * 0.34,
      ),
    ];

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (
      final Offset point
          in points.skip(1)
    ) {
      path.lineTo(
        point.dx,
        point.dy,
      );
    }

    canvas.drawPath(
      path,
      paint,
    );
  }
  @override
  bool shouldRepaint(
    covariant CustomPainter
        oldDelegate,
  ) {
    return false;
  }
}