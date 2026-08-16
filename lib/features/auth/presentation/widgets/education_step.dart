import 'package:flutter/material.dart';

class EducationStep extends StatelessWidget {
  final String selectedEducation;
  final ValueChanged<String> onSelected;

  const EducationStep({
    super.key,
    required this.selectedEducation,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const options = [
      _EducationOption(
        title: 'School',
        subtitle: "I'm in school",
        icon: Icons.school_rounded,
      ),
      _EducationOption(
        title: 'College',
        subtitle: "I'm in college",
        icon: Icons.account_balance_rounded,
      ),
      _EducationOption(
        title: 'University',
        subtitle: "I'm in university",
        icon: Icons.account_balance_rounded,
      ),
      _EducationOption(
        title: 'Other',
        subtitle: 'Other educational path',
        icon: Icons.grid_view_rounded,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        26,
        25,
        26,
        26,
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
            'What are you studying?',
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
            'Choose the education level that best describes you.',
            style: TextStyle(
              color: Color(0xFF999CAF),
              fontSize: 14.5,
              fontWeight: FontWeight.w400,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 22),

          // =====================================================
          // OPTIONS
          // =====================================================

          Column(
            children: options.map((option) {
              final bool selected =
                  selectedEducation == option.title;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _EducationCard(
                  option: option,
                  selected: selected,
                  onTap: () => onSelected(option.title),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// EDUCATION OPTION MODEL
// ===============================================================

class _EducationOption {
  final String title;
  final String subtitle;
  final IconData icon;

  const _EducationOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

// ===============================================================
// EDUCATION CARD
// ===============================================================

class _EducationCard extends StatelessWidget {
  final _EducationOption option;
  final bool selected;
  final VoidCallback onTap;

  const _EducationCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: const Color(0xFF7C3AED).withValues(
          alpha: 0.08,
        ),
        highlightColor: const Color(0xFF7C3AED).withValues(
          alpha: 0.04,
        ),
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOut,

          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF110D2B)
                : const Color(0xFF080A1B),

            borderRadius: BorderRadius.circular(15),

            border: Border.all(
              color: selected
                  ? const Color(0xFF8B3DFF)
                  : const Color(0xFF25283E),
              width: selected ? 1.3 : 1,
            ),

            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C3AED)
                          .withValues(alpha: 0.10),
                      blurRadius: 18,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),

          child: Row(
            children: [
              // =================================================
              // ICON
              // =================================================

              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 220,
                ),
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF30206D)
                      : const Color(0xFF15172D),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF6932D9)
                            .withValues(alpha: 0.55)
                        : Colors.transparent,
                  ),
                ),
                child: Icon(
                  option.icon,
                  size: 21,
                  color: selected
                      ? const Color(0xFFB477FF)
                      : const Color(0xFF8D91A8),
                ),
              ),

              const SizedBox(width: 15),

              // =================================================
              // TEXT
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xFFE2E3EA),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      option.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8E92A8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // =================================================
              // RADIO
              // =================================================

              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 220,
                ),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFB26BFF)
                        : const Color(0xFF596078),
                    width: selected ? 2 : 1.3,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB26BFF),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}