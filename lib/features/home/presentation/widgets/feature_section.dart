import 'package:flutter/material.dart';

import 'feature_card.dart';

class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 48,
            isMobile ? 20 : 0,
            isMobile ? 24 : 48,
            isMobile ? 28 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                // Responsive columns
                crossAxisCount: isMobile
                    ? 1
                    : isTablet
                        ? 2
                        : 4,

                // Smaller gaps like reference
                crossAxisSpacing: isMobile ? 14 : 18,
                mainAxisSpacing: isMobile ? 14 : 18,

                // Controls card height
                childAspectRatio: isMobile
                    ? 2.25
                    : isTablet
                        ? 2.0
                        : 1.90,

                children: [
                  FeatureCard(
                    icon: Icons.track_changes_rounded,
                    title: 'Goal Tracking',
                    description:
                        'Set academic goals and track progress with precision.',
                    accentColor: const Color(0xFF7C3AED),
                    onTap: () {},
                  ),

                  FeatureCard(
                    icon: Icons.calendar_month_rounded,
                    title: 'AI Study Plans',
                    description:
                        'Generate personalized study schedules powered by AI.',
                    accentColor: const Color(0xFF1683FF),
                    onTap: () {},
                  ),

                  FeatureCard(
                    icon: Icons.trending_up_rounded,
                    title: 'Analytics',
                    description:
                        'Visualize your performance and study patterns.',
                    accentColor: const Color(0xFF00D7C5),
                    onTap: () {},
                  ),

                  FeatureCard(
                    icon: Icons.school_rounded,
                    title: 'Exam Ready',
                    description:
                        'Curated resources and prep tools for every exam.',
                    accentColor: const Color(0xFFFF8618),
                    onTap: () {},
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