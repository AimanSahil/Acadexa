import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PlannerShowcaseSection extends StatelessWidget {
  const PlannerShowcaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 750;
        final isTablet = width >= 750 && width < 1100;

        return Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 68,
            vertical: isMobile ? 70 : 100,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Column(
                children: [
                  //
                  // SECTION HEADER
                  //
                  _SectionHeader(
                    isMobile: isMobile,
                  ),

                  SizedBox(
                    height: isMobile ? 45 : 70,
                  ),

                  //
                  // SHOWCASE
                  //
                  if (isMobile)
                    const Column(
                      children: [
                        _PlannerPreview(),
                        SizedBox(height: 50),
                        _PlannerContent(),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 11,
                          child: _PlannerPreview(),
                        ),

                        SizedBox(
                          width: isTablet ? 45 : 80,
                        ),

                        const Expanded(
                          flex: 9,
                          child: _PlannerContent(),
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

// ================================================================
// SECTION HEADER
// ================================================================

class _SectionHeader extends StatelessWidget {
  final bool isMobile;

  const _SectionHeader({
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF7C3AED).withValues(
                alpha: 0.35,
              ),
            ),
          ),
          child: const Text(
            '✦  SMART STUDY PLANNER',
            style: TextStyle(
              color: Color(0xFFB56CFF),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'A study plan built around you',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 30 : 42,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 14),

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 670,
          ),
          child: const Text(
            'Acadexa organizes your subjects, goals, deadlines, and available '
            'time into a clear study schedule you can actually follow.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFA8AEC3),
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// PLANNER PREVIEW
// ================================================================

class _PlannerPreview extends StatelessWidget {
  const _PlannerPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7C3AED).withValues(alpha: 0.8),
            const Color(0xFF1683FF).withValues(alpha: 0.25),
            const Color(0xFFE83CD7).withValues(alpha: 0.45),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(
              alpha: 0.12,
            ),
            blurRadius: 50,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF070B1D),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            // TOP BAR
            //
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(
                      alpha: 0.18,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF9B5CFF),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Study Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'AI optimized for this week',
                        style: TextStyle(
                          color: Color(0xFF8E95AA),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D7C5).withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: Color(0xFF00D7C5),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'On Track',
                        style: TextStyle(
                          color: Color(0xFF00D7C5),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            //
            // WEEK DAYS
            //
            const _WeekDays(),

            const SizedBox(height: 24),

            //
            // STUDY TASKS
            //
            const _StudyTask(
              time: '09:00',
              title: 'Data Structures',
              subtitle: 'Review Trees & Graphs',
              duration: '60 min',
              color: Color(0xFF7C3AED),
              icon: Icons.account_tree_rounded,
            ),

            const SizedBox(height: 12),

            const _StudyTask(
              time: '11:30',
              title: 'Database Systems',
              subtitle: 'SQL practice session',
              duration: '45 min',
              color: Color(0xFF1683FF),
              icon: Icons.storage_rounded,
            ),

            const SizedBox(height: 12),

            const _StudyTask(
              time: '04:00',
              title: 'Mathematics',
              subtitle: 'Calculus revision',
              duration: '50 min',
              color: Color(0xFF00D7C5),
              icon: Icons.calculate_rounded,
            ),

            const SizedBox(height: 22),

            //
            // PROGRESS
            //
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1129),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(
                    alpha: 0.06,
                  ),
                ),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Today\'s progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '68%',
                        style: TextStyle(
                          color: Color(0xFFA56CFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  _ProgressBar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// WEEK DAYS
// ================================================================

class _WeekDays extends StatelessWidget {
  const _WeekDays();

  @override
  Widget build(BuildContext context) {
    const days = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
    ];

    const dates = [
      '03',
      '04',
      '05',
      '06',
      '07',
    ];

    return Row(
      children: List.generate(
        days.length,
        (index) {
          final selected = index == 2;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: index == days.length - 1 ? 0 : 7,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 11,
              ),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6D35FF),
                          Color(0xFF9C3DFF),
                        ],
                      )
                    : null,
                color: selected
                    ? null
                    : const Color(0xFF0C122B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : Colors.white.withValues(
                          alpha: 0.05,
                        ),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(0xFF7F879E),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    dates[index],
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(0xFFC2C6D3),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================================================================
// STUDY TASK
// ================================================================

class _StudyTask extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final String duration;
  final Color color;
  final IconData icon;

  const _StudyTask({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            time,
            style: const TextStyle(
              color: Color(0xFF747C93),
              fontSize: 11,
            ),
          ),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(
                  alpha: 0.25,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(
                      alpha: 0.15,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF8D94A9),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  duration,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// PROGRESS BAR
// ================================================================

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 7,
        child: Stack(
          children: [
            Container(
              color: const Color(0xFF161C34),
            ),

            FractionallySizedBox(
              widthFactor: 0.68,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF315EFF),
                      Color(0xFF7C3AED),
                      Color(0xFFE83CD7),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// RIGHT CONTENT
// ================================================================

class _PlannerContent extends StatelessWidget {
  const _PlannerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan smarter.\nStudy with purpose.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            height: 1.18,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Instead of manually deciding what to study every day, Acadexa '
          'helps turn your academic workload into an organized and '
          'manageable plan.',
          style: TextStyle(
            color: Color(0xFFA8AEC3),
            fontSize: 15,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 30),

        const _PlannerFeature(
          icon: Icons.auto_awesome_rounded,
          title: 'AI-powered scheduling',
          description:
              'Build personalized study sessions around your subjects and priorities.',
          color: Color(0xFF9B5CFF),
        ),

        const SizedBox(height: 22),

        const _PlannerFeature(
          icon: Icons.event_available_rounded,
          title: 'Deadline-aware planning',
          description:
              'Keep exams, assignments, and important academic deadlines in view.',
          color: Color(0xFF1683FF),
        ),

        const SizedBox(height: 22),

        const _PlannerFeature(
          icon: Icons.track_changes_rounded,
          title: 'Goal-based progress',
          description:
              'Connect your study sessions with goals and track how much you complete.',
          color: Color(0xFF00D7C5),
        ),

        const SizedBox(height: 22),

        const _PlannerFeature(
          icon: Icons.insights_rounded,
          title: 'Performance insights',
          description:
              'Use your study activity and progress to understand where to focus next.',
          color: Color(0xFFE83CD7),
        ),

        const SizedBox(height: 34),

        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF315EFF),
                Color(0xFF7C3AED),
                Color(0xFFD83DDA),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 19,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create My Study Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// PLANNER FEATURE
// ================================================================

class _PlannerFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _PlannerFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(
                alpha: 0.18,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF969DB2),
                  fontSize: 13,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}