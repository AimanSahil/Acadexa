import 'package:flutter/material.dart';

class SubjectsStep extends StatefulWidget {
  final List<String> subjects;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const SubjectsStep({
    super.key,
    required this.subjects,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<SubjectsStep> createState() => _SubjectsStepState();
}

class _SubjectsStepState extends State<SubjectsStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD SUBJECT
  // ============================================================

  void _addSubject() {
    final value = _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    // Prevent duplicate subjects.
    if (widget.subjects.any(
      (subject) => subject.toLowerCase() == value.toLowerCase(),
    )) {
      _controller.clear();
      return;
    }

    widget.onAdd(value);

    _controller.clear();

    FocusScope.of(context).unfocus();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
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
            'What subjects are you studying?',
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
            'Add the subjects you want Acadexa to help you manage.',
            style: TextStyle(
              color: Color(0xFF999CAF),
              fontSize: 14.5,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 25),

          // =====================================================
          // ADD SUBJECT ROW
          // =====================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _SubjectInput(
                  controller: _controller,
                  onSubmitted: (_) => _addSubject(),
                ),
              ),

              const SizedBox(width: 12),

              // =================================================
              // ADD BUTTON
              // =================================================

              SizedBox(
                width: 56,
                height: 56,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6D28D9),
                          Color(0xFF7C3AED),
                          Color(0xFF9333EA),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(
                            alpha: 0.20,
                          ),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: _addSubject,
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // =====================================================
          // YOUR SUBJECTS LABEL
          // =====================================================

          if (widget.subjects.isNotEmpty) ...[
            const Text(
              'Your subjects',
              style: TextStyle(
                color: Color(0xFFD8D9E2),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            // ===================================================
            // SUBJECT CHIPS
            // ===================================================

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.subjects.map(
                (subject) {
                  return _SubjectChip(
                    subject: subject,
                    onRemove: () {
                      widget.onRemove(subject);
                    },
                  );
                },
              ).toList(),
            ),

            const SizedBox(height: 28),
          ],

          // =====================================================
          // EMPTY STATE
          // =====================================================

          if (widget.subjects.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  bottom: 18,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFF666A80),
                      size: 48,
                    ),

                    SizedBox(height: 12),

                    Text(
                      'No subjects added yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF9B9EAF),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      'Add subjects to see them here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF686B80),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ===============================================================
// SUBJECT INPUT
// ===============================================================

class _SubjectInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _SubjectInput({
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'Add a subject',
        hintStyle: const TextStyle(
          color: Color(0xFF777B91),
          fontSize: 15,
        ),

        // ======================================================
        // ICON
        // ======================================================

        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 12,
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: Color(0xFFA96BFF),
            size: 22,
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 54,
        ),

        // ======================================================
        // FIELD
        // ======================================================

        filled: true,
        fillColor: const Color(0xFF080A1B),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF292C45),
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
// SUBJECT CHIP
// ===============================================================

class _SubjectChip extends StatelessWidget {
  final String subject;
  final VoidCallback onRemove;

  const _SubjectChip({
    required this.subject,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF111226),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF34374F),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ====================================================
          // SUBJECT NAME
          // ====================================================

          Text(
            subject,
            style: const TextStyle(
              color: Color(0xFFE1E2E9),
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 8),

          // ====================================================
          // REMOVE
          // ====================================================

          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xFF9A9DAF),
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}