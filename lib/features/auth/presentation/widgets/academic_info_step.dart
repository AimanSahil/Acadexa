import 'package:flutter/material.dart';

class AcademicInfoStep extends StatelessWidget {
  final TextEditingController institutionController;
  final TextEditingController fieldController;
  final String? selectedSemester;

  final ValueChanged<String> onInstitutionChanged;
  final ValueChanged<String> onFieldChanged;
  final ValueChanged<String?> onSemesterChanged;

  const AcademicInfoStep({
    super.key,
    required this.institutionController,
    required this.fieldController,
    required this.selectedSemester,
    required this.onInstitutionChanged,
    required this.onFieldChanged,
    required this.onSemesterChanged,
  });

  @override
  Widget build(BuildContext context) {
    const semesters = [
      'Semester 1',
      'Semester 2',
      'Semester 3',
      'Semester 4',
      'Semester 5',
      'Semester 6',
      'Semester 7',
      'Semester 8',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        28,
        26,
        28,
        28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF090B20),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF252943),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // TITLE
          // =====================================================

          const Text(
            'Tell us about your studies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 8),

          // =====================================================
          // SUBTITLE
          // =====================================================

          const Text(
            'This information will help Acadexa organize your academic life.',
            style: TextStyle(
              color: Color(0xFF999CAF),
              fontSize: 14.5,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 25),

          // =====================================================
          // INSTITUTION
          // =====================================================

          _AcademicInput(
            controller: institutionController,
            label: 'University / Institution',
            hint: 'e.g. State University',
            icon: Icons.account_balance_rounded,
            onChanged: onInstitutionChanged,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // FIELD OF STUDY
          // =====================================================

          _AcademicInput(
            controller: fieldController,
            label: 'Field of study',
            hint: 'e.g. Computer Science',
            icon: Icons.menu_book_rounded,
            onChanged: onFieldChanged,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // SEMESTER
          // =====================================================

          _SemesterDropdown(
            selectedSemester: selectedSemester,
            semesters: semesters,
            onChanged: onSemesterChanged,
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// ACADEMIC INPUT
// ===============================================================

class _AcademicInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _AcademicInput({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        // =====================================================
        // LABEL
        // =====================================================

        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFFE4E5EC),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        // =====================================================
        // HINT
        // =====================================================

        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF777B91),
          fontSize: 14,
        ),

        // =====================================================
        // ICON
        // =====================================================

        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 12,
          ),
          child: Icon(
            icon,
            color: const Color(0xFFA96BFF),
            size: 22,
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 54,
        ),

        // =====================================================
        // FIELD
        // =====================================================

        filled: true,
        fillColor: const Color(0xFF080A1B),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF272A42),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF8B3DFF),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// SEMESTER DROPDOWN
// ===============================================================

class _SemesterDropdown extends StatelessWidget {
  final String? selectedSemester;
  final List<String> semesters;
  final ValueChanged<String?> onChanged;

  const _SemesterDropdown({
    required this.selectedSemester,
    required this.semesters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedSemester,

      // =========================================================
      // DROPDOWN
      // =========================================================

      dropdownColor: const Color(0xFF111329),

      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),

      // =========================================================
      // ARROW
      // =========================================================

      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFFA96BFF),
        size: 25,
      ),

      // =========================================================
      // DECORATION
      // =========================================================

      decoration: InputDecoration(
        labelText: 'Semester',

        labelStyle: const TextStyle(
          color: Color(0xFFE4E5EC),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        hintText: 'Select semester',

        hintStyle: const TextStyle(
          color: Color(0xFF777B91),
          fontSize: 14,
        ),

        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 12,
          ),
          child: Icon(
            Icons.calendar_month_rounded,
            color: Color(0xFFA96BFF),
            size: 22,
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 54,
        ),

        filled: true,
        fillColor: const Color(0xFF080A1B),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF272A42),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF8B3DFF),
            width: 1.3,
          ),
        ),
      ),

      // =========================================================
      // ITEMS
      // =========================================================

      items: semesters.map(
        (semester) {
          return DropdownMenuItem<String>(
            value: semester,
            child: Text(
              semester,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          );
        },
      ).toList(),

      onChanged: onChanged,
    );
  }
}