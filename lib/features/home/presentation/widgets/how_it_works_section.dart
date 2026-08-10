import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;

        return Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 68,
            isMobile ? 65 : 90,
            isMobile ? 24 : 68,
            isMobile ? 65 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Column(
                children: [
                  // Small section label
                  const _SectionLabel(),

                  const SizedBox(height: 14),

                  // Main title
                  Text(
                    'Turn your goals into a smarter study plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isMobile
                          ? 30
                          : isTablet
                              ? 38
                              : 44,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 680,
                    ),
                    child: Text(
                      'Acadexa turns your subjects, goals, and available '
                      'study time into a focused plan you can actually follow.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: isMobile ? 14 : 16,
                        height: 1.6,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: isMobile ? 45 : 65,
                  ),

                  // Steps
                  if (isMobile)
                    const Column(
                      children: [
                        _HowItWorksCard(
                          step: '01',
                          icon: Icons.track_changes_rounded,
                          title: 'Set Your Goals',
                          description:
                              'Add your subjects, academic goals, exam dates, '
                              'deadlines, and the time you have available to study.',
                          accentColor: Color(0xFF8B5CF6),
                        ),

                        _MobileConnector(),

                        _HowItWorksCard(
                          step: '02',
                          icon: Icons.auto_awesome_rounded,
                          title: 'AI Builds Your Plan',
                          description:
                              'Acadexa organizes your workload and creates a '
                              'personalized study plan around your priorities.',
                          accentColor: Color(0xFF1683FF),
                        ),

                        _MobileConnector(),

                        _HowItWorksCard(
                          step: '03',
                          icon: Icons.calendar_month_rounded,
                          title: 'Follow & Adapt',
                          description:
                              'Follow your schedule, complete study sessions, '
                              'track progress, and adjust your plan as things change.',
                          accentColor: Color(0xFF00D7C5),
                        ),
                      ],
                    )
                  else
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _HowItWorksCard(
                            step: '01',
                            icon: Icons.track_changes_rounded,
                            title: 'Set Your Goals',
                            description:
                                'Add your subjects, academic goals, exam dates, '
                                'deadlines, and available study time.',
                            accentColor: Color(0xFF8B5CF6),
                          ),
                        ),

                        _DesktopConnector(
                          color: Color(0xFF8B5CF6),
                        ),

                        Expanded(
                          child: _HowItWorksCard(
                            step: '02',
                            icon: Icons.auto_awesome_rounded,
                            title: 'AI Builds Your Plan',
                            description:
                                'Acadexa organizes your workload and creates a '
                                'focused study plan around your priorities.',
                            accentColor: Color(0xFF1683FF),
                          ),
                        ),

                        _DesktopConnector(
                          color: Color(0xFF1683FF),
                        ),

                        Expanded(
                          child: _HowItWorksCard(
                            step: '03',
                            icon: Icons.calendar_month_rounded,
                            title: 'Follow & Adapt',
                            description:
                                'Complete study sessions, track your progress, '
                                'and adjust your plan whenever things change.',
                            accentColor: Color(0xFF00D7C5),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// SECTION LABEL
// ============================================================

class _SectionLabel extends StatelessWidget {
  const _SectionLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7C3AED).withValues(
            alpha: 0.30,
          ),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: Color(0xFFA855F7),
            size: 15,
          ),
          SizedBox(width: 7),
          Text(
            'HOW ACADEXA WORKS',
            style: TextStyle(
              color: Color(0xFFA855F7),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// HOW IT WORKS CARD
// ============================================================

class _HowItWorksCard extends StatefulWidget {
  final String step;
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;

  const _HowItWorksCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
  });

  @override
  State<_HowItWorksCard> createState() => _HowItWorksCardState();
}

class _HowItWorksCardState extends State<_HowItWorksCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(
          minHeight: 270,
        ),
        padding: const EdgeInsets.all(26),
        transform: isHovered
            ? Matrix4.translationValues(
                0,
                -6,
                0,
              )
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF080D22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isHovered
                ? widget.accentColor.withValues(
                    alpha: 0.75,
                  )
                : widget.accentColor.withValues(
                    alpha: 0.28,
                  ),
            width: 1,
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: widget.accentColor.withValues(
                      alpha: 0.13,
                    ),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + step
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 220,
                  ),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(
                      alpha: isHovered ? 0.20 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: widget.accentColor.withValues(
                        alpha: 0.18,
                      ),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.accentColor,
                    size: 25,
                  ),
                ),

                const Spacer(),

                Text(
                  widget.step,
                  style: TextStyle(
                    color: widget.accentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              widget.description,
              style: const TextStyle(
                color: Color(0xFFA8AEC3),
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const Spacer(),

            const SizedBox(height: 20),

            // Bottom decorative line
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 220,
              ),
              width: isHovered ? 70 : 38,
              height: 3,
              decoration: BoxDecoration(
                color: widget.accentColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: widget.accentColor.withValues(
                            alpha: 0.50,
                          ),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DESKTOP CONNECTOR
// ============================================================

class _DesktopConnector extends StatelessWidget {
  final Color color;

  const _DesktopConnector({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(
                    alpha: 0.55,
                  ),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.8),
                    color.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MOBILE CONNECTOR
// ============================================================

class _MobileConnector extends StatelessWidget {
  const _MobileConnector();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 35,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF7C3AED).withValues(
              alpha: 0.20,
            ),
            const Color(0xFF1683FF).withValues(
              alpha: 0.70,
            ),
            const Color(0xFF00D7C5).withValues(
              alpha: 0.20,
            ),
          ],
        ),
      ),
    );
  }
}