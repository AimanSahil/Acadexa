import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeFaqSection extends StatelessWidget {
  const HomeFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 68,
            isMobile ? 70 : 100,
            isMobile ? 24 : 68,
            isMobile ? 75 : 110,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 950,
              ),
              child: Column(
                children: [
                  // ==========================================================
                  // BADGE
                  // ==========================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED)
                          .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF7C3AED)
                            .withValues(alpha: 0.30),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.help_outline_rounded,
                          color: Color(0xFFB56CFF),
                          size: 15,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'FREQUENTLY ASKED QUESTIONS',
                          style: TextStyle(
                            color: Color(0xFFB56CFF),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==========================================================
                  // TITLE
                  // ==========================================================

                  Text(
                    'Questions about Acadexa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 30 : 42,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ==========================================================
                  // SUBTITLE
                  // ==========================================================

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 650,
                    ),
                    child: const Text(
                      'Everything you need to know about planning your studies, '
                      'tracking progress, and getting the most out of Acadexa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA8AEC3),
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: isMobile ? 42 : 55,
                  ),

                  // ==========================================================
                  // FAQ ITEMS
                  // ==========================================================

                  const _FaqItem(
                    question:
                        'How does Acadexa create my study plan?',
                    answer:
                        'Acadexa uses your subjects, academic goals, '
                        'deadlines, priorities, and available study time '
                        'to help organize a focused study schedule around '
                        'your academic workload.',
                  ),

                  const SizedBox(height: 12),

                  const _FaqItem(
                    question:
                        'Can I change an AI-generated study plan?',
                    answer:
                        'Yes. Your study plan is designed to remain flexible. '
                        'You can adjust study sessions, priorities, subjects, '
                        'and available study time as your schedule changes.',
                  ),

                  const SizedBox(height: 12),

                  const _FaqItem(
                    question:
                        'Can I manage multiple subjects in Acadexa?',
                    answer:
                        'Yes. Acadexa is designed to keep multiple subjects '
                        'organized in one academic workspace so you can manage '
                        'different courses, goals, study sessions, and deadlines.',
                  ),

                  const SizedBox(height: 12),

                  const _FaqItem(
                    question:
                        'How does Acadexa track my progress?',
                    answer:
                        'Acadexa can use your completed study sessions, goals, '
                        'and academic activity to show your progress and help '
                        'you understand where more attention may be needed.',
                  ),

                  const SizedBox(height: 12),

                  const _FaqItem(
                    question:
                        'Can Acadexa help me prepare for exams?',
                    answer:
                        'Yes. You can organize exam dates, revision goals, '
                        'subjects, and study sessions so your preparation is '
                        'spread across the time available before an exam.',
                  ),

                  const SizedBox(height: 12),

                  const _FaqItem(
                    question:
                        'Do I have to follow the study plan exactly?',
                    answer:
                        'No. The plan is there to give you structure and '
                        'direction. You can adapt it when deadlines, classes, '
                        'priorities, or your available study time change.',
                  ),

                  SizedBox(
                    height: isMobile ? 35 : 45,
                  ),

                  // ==========================================================
                  // BOTTOM HELP BOX
                  // ==========================================================

                  const _HelpBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// FAQ ITEM
// ============================================================================

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 220,
          ),
          curve: Curves.easeOut,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _isExpanded
                ? const Color(0xFF0A1027)
                : const Color(0xFF080D22),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isExpanded || _isHovered
                  ? const Color(0xFF7C3AED)
                      .withValues(alpha: 0.55)
                  : const Color(0xFF222840),
            ),
            boxShadow: _isExpanded
                ? [
                    BoxShadow(
                      color: const Color(0xFF7C3AED)
                          .withValues(alpha: 0.08),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              // ============================================================
              // QUESTION
              // ============================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED)
                            .withValues(alpha: 0.10),
                        borderRadius:
                            BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.help_outline_rounded,
                        color: Color(0xFFA86CFF),
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        widget.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _isExpanded
                            ? const Color(0xFF7C3AED)
                                .withValues(alpha: 0.18)
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: AnimatedRotation(
                        duration: const Duration(
                          milliseconds: 220,
                        ),
                        turns:
                            _isExpanded ? 0.125 : 0,
                        child: const Icon(
                          Icons.add_rounded,
                          color: Color(0xFFA86CFF),
                          size: 21,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ============================================================
              // ANSWER
              // ============================================================

              AnimatedSize(
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.fromLTRB(
                          70,
                          0,
                          60,
                          20,
                        ),
                        child: Text(
                          widget.answer,
                          style: const TextStyle(
                            color: Color(0xFF9CA3B8),
                            fontSize: 14,
                            height: 1.65,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HELP BOX
// ============================================================================

class _HelpBox extends StatelessWidget {
  const _HelpBox();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile =
            constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 26,
            vertical: 22,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF7C3AED)
                    .withValues(alpha: 0.08),
                const Color(0xFF1683FF)
                    .withValues(alpha: 0.05),
                const Color(0xFFE83CD7)
                    .withValues(alpha: 0.07),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF7C3AED)
                  .withValues(alpha: 0.20),
            ),
          ),
          child: isMobile
              ? const Column(
                  children: [
                    _HelpContent(
                      centered: true,
                    ),
                    SizedBox(height: 20),
                    _HelpButton(),
                  ],
                )
              : const Row(
                  children: [
                    Expanded(
                      child: _HelpContent(),
                    ),
                    SizedBox(width: 25),
                    _HelpButton(),
                  ],
                ),
        );
      },
    );
  }
}

class _HelpContent extends StatelessWidget {
  final bool centered;

  const _HelpContent({
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Still have questions?',
          textAlign:
              centered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Explore Acadexa and discover how it can fit into your study routine.',
          textAlign:
              centered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            color: Color(0xFF9299AD),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 17,
        ),
        side: BorderSide(
          color: const Color(0xFF7C3AED)
              .withValues(alpha: 0.65),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Explore Acadexa',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 9),
          Icon(
            Icons.arrow_forward_rounded,
            size: 17,
          ),
        ],
      ),
    );
  }
}