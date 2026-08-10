import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 800;
        final isTablet = width >= 800 && width < 1100;

        return Container(
          width: double.infinity,
          color: AppColors.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 24 : 48,
                  isMobile ? 35 : 25,
                  isMobile ? 24 : 48,
                  isMobile ? 40 : 25,
                ),
                child: isMobile
                    ? const Column(
                        children: [
                          _HeroContent(
                            isMobile: true,
                          ),
                          SizedBox(height: 35),
                          _HeroVisual(
                            isMobile: true,
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: isTablet ? 11 : 10,
                            child: const _HeroContent(),
                          ),

                          const SizedBox(width: 30),

                          Expanded(
                            flex: isTablet ? 9 : 10,
                            child: _HeroVisual(
                              isTablet: isTablet,
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

// ============================================================
// HERO LEFT CONTENT
// ============================================================

class _HeroContent extends StatelessWidget {
  final bool isMobile;

  const _HeroContent({
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // =====================================================
        // AI BADGE
        // =====================================================

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.primary.withValues(
                alpha: 0.30,
              ),
            ),
          ),
          child: const Text(
            '✦  AI-Powered Study Planning',
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // =====================================================
        // TITLE
        // =====================================================

        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              'Your Brilliant',
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: isMobile ? 42 : 54,
                height: 1.05,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            // Gradient text
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF087CFF),
                    Color(0xFF633CFF),
                    Color(0xFFE83CD7),
                  ],
                ).createShader(bounds);
              },
              child: Text(
                'Study Partner',
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 42 : 54,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // =====================================================
        // DESCRIPTION
        // =====================================================

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Text(
            'Track your goals, manage subjects, create intelligent '
            'study plans, and ace your exams. The focused academic '
            'companion for students who take their studies seriously.',
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 26),

        // =====================================================
        // BUTTONS
        // =====================================================

        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          children: [
            // GET STARTED
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started',
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                ],
              ),
            ),

            // VIEW ANALYTICS
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.trending_up_rounded,
                size: 19,
              ),
              label: const Text(
                'View Analytics',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(
                  color: AppColors.cardBorder,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================
// HERO RIGHT IMAGE
// ============================================================

class _HeroVisual extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _HeroVisual({
    this.isMobile = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageWidth;

        if (isMobile) {
          imageWidth = constraints.maxWidth > 500
              ? 450
              : constraints.maxWidth;
        } else if (isTablet) {
          imageWidth = 420;
        } else {
          imageWidth = 500;
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: imageWidth,
              maxHeight: isMobile ? 450 : 500,
            ),
            child: Image.asset(
              'assets/images/home/hero_illustration.png',
              width: imageWidth,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        );
      },
    );
  }
}