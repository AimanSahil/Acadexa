import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;

        return Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 68,
            isMobile ? 60 : 90,
            isMobile ? 24 : 68,
            isMobile ? 70 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF7C3AED)
                        .withValues(alpha: 0.45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED)
                          .withValues(alpha: 0.10),
                      blurRadius: 60,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // ======================================================
                    // BACKGROUND
                    // ======================================================

                    const Positioned.fill(
                      child: _CtaBackground(),
                    ),

                    // ======================================================
                    // DECORATIVE GLOWS
                    // ======================================================

                    Positioned(
                      top: -100,
                      left: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF315EFF)
                                  .withValues(alpha: 0.25),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: -100,
                      bottom: -120,
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFE83CD7)
                                  .withValues(alpha: 0.20),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 50,
                      right: 100,
                      child: _GlowDot(
                        size: 7,
                        color: Color(0xFFB56CFF),
                      ),
                    ),

                    Positioned(
                      top: 90,
                      left: 120,
                      child: _GlowDot(
                        size: 5,
                        color: Color(0xFF1683FF),
                      ),
                    ),

                    Positioned(
                      bottom: 70,
                      right: 220,
                      child: _GlowDot(
                        size: 5,
                        color: Color(0xFF00D7C5),
                      ),
                    ),

                    // ======================================================
                    // CONTENT
                    // ======================================================

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 70,
                        vertical: isMobile ? 55 : 75,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 820,
                          ),
                          child: Column(
                            children: [
                              // Icon
                              Container(
                                width: isMobile ? 56 : 64,
                                height: isMobile ? 56 : 64,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF315EFF),
                                      Color(0xFF7C3AED),
                                      Color(0xFFE83CD7),
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7C3AED)
                                          .withValues(alpha: 0.40),
                                      blurRadius: 30,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Colors.white,
                                  size: 29,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.05,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(
                                      alpha: 0.10,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'YOUR NEXT STUDY SESSION STARTS HERE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFC9B7FF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 22),

                              // Heading
                              Text(
                                'Ready to take control\nof your studies?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 32 : 48,
                                  height: 1.12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.8,
                                ),
                              ),

                              const SizedBox(height: 18),

                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 650,
                                ),
                                child: Text(
                                  'Set your goals, organize your subjects, '
                                  'build smarter study plans, and understand '
                                  'your progress — all with Acadexa.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: 0.70,
                                    ),
                                    fontSize: isMobile ? 14 : 16,
                                    height: 1.65,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: isMobile ? 30 : 36,
                              ),

                              // Buttons
                              if (isMobile)
                                const Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: _PrimaryButton(),
                                    ),
                                    SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: _SecondaryButton(),
                                    ),
                                  ],
                                )
                              else
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    _PrimaryButton(),
                                    SizedBox(width: 14),
                                    _SecondaryButton(),
                                  ],
                                ),

                              const SizedBox(height: 26),

                              // Trust / feature row
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 22,
                                runSpacing: 12,
                                children: const [
                                  _MiniBenefit(
                                    text: 'Quick setup',
                                  ),
                                  _MiniBenefit(
                                    text: 'Flexible planning',
                                  ),
                                  _MiniBenefit(
                                    text: 'Student focused',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// BACKGROUND
// ============================================================================

class _CtaBackground extends StatelessWidget {
  const _CtaBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF080D22),
            Color(0xFF0B0D28),
            Color(0xFF120A2B),
            Color(0xFF080D22),
          ],
          stops: [
            0.0,
            0.35,
            0.72,
            1.0,
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PRIMARY BUTTON
// ============================================================================

class _PrimaryButton extends StatefulWidget {
  const _PrimaryButton();

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? Matrix4.translationValues(0, -2, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF315EFF),
              Color(0xFF7C3AED),
              Color(0xFFD83DDA),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF7C3AED)
                        .withValues(alpha: 0.40),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF7C3AED)
                        .withValues(alpha: 0.20),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 19,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Start Planning',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_rounded,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SECONDARY BUTTON
// ============================================================================

class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton();

  @override
  State<_SecondaryButton> createState() =>
      _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? Matrix4.translationValues(0, -2, 0)
            : Matrix4.identity(),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: _isHovered
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 19,
            ),
            side: BorderSide(
              color: _isHovered
                  ? const Color(0xFF8B5CF6)
                  : Colors.white.withValues(alpha: 0.18),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.explore_outlined,
                size: 18,
              ),
              SizedBox(width: 10),
              Text(
                'Explore Features',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MINI BENEFIT
// ============================================================================

class _MiniBenefit extends StatelessWidget {
  final String text;

  const _MiniBenefit({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF00D7C5)
                .withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Color(0xFF00D7C5),
            size: 12,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF9299AD),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// DECORATIVE DOT
// ============================================================================

class _GlowDot extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowDot({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.70),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}