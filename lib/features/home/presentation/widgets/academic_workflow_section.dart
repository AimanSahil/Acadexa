import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AcademicWorkflowSection extends StatelessWidget {
  const AcademicWorkflowSection({super.key});

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
                  // ==========================================================
                  // SECTION HEADER
                  // ==========================================================

                  _SectionHeader(
                    isMobile: isMobile,
                  ),

                  SizedBox(
                    height: isMobile ? 45 : 70,
                  ),

                  // ==========================================================
                  // MAIN CONTENT
                  // ==========================================================

                  if (isMobile)
                    const Column(
                      children: [
                        _WorkflowVisual(),
                        SizedBox(height: 50),
                        _WorkflowContent(),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 11,
                          child: _WorkflowVisual(),
                        ),

                        SizedBox(
                          width: isTablet ? 45 : 85,
                        ),

                        const Expanded(
                          flex: 9,
                          child: _WorkflowContent(),
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

// ============================================================================
// SECTION HEADER
// ============================================================================

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
            color: const Color(0xFF1683FF).withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF1683FF).withValues(
                alpha: 0.30,
              ),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hub_rounded,
                color: Color(0xFF4C9DFF),
                size: 15,
              ),
              SizedBox(width: 7),
              Text(
                'YOUR ACADEMIC WORKFLOW',
                style: TextStyle(
                  color: Color(0xFF65A9FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Everything connected in one place',
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
            maxWidth: 700,
          ),
          child: const Text(
            'From choosing your subjects to tracking your performance, '
            'Acadexa connects every part of your academic journey into '
            'one focused workflow.',
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

// ============================================================================
// WORKFLOW VISUAL
// ============================================================================

class _WorkflowVisual extends StatelessWidget {
  const _WorkflowVisual();

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
            const Color(0xFF1683FF).withValues(alpha: 0.65),
            const Color(0xFF7C3AED).withValues(alpha: 0.30),
            const Color(0xFF00D7C5).withValues(alpha: 0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1683FF).withValues(
              alpha: 0.08,
            ),
            blurRadius: 50,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF070B1D),
          borderRadius: BorderRadius.circular(21),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardHeader(),

            SizedBox(height: 28),

            _WorkflowSteps(),

            SizedBox(height: 28),

            _UpcomingDeadlineCard(),

            SizedBox(height: 14),

            _TodayFocusCard(),

            SizedBox(height: 14),

            _WeeklyProgressCard(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// DASHBOARD HEADER
// ============================================================================

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF315EFF),
                Color(0xFF7C3AED),
              ],
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.dashboard_customize_rounded,
            color: Colors.white,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Academic Overview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Your learning journey at a glance',
                style: TextStyle(
                  color: Color(0xFF858DA5),
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
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: Color(0xFF00D7C5),
                size: 7,
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
    );
  }
}

// ============================================================================
// WORKFLOW STEPS
// ============================================================================

class _WorkflowSteps extends StatelessWidget {
  const _WorkflowSteps();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 500;

        if (compact) {
          return const Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _WorkflowStep(
                      icon: Icons.menu_book_rounded,
                      label: 'Subjects',
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  _SmallArrow(),
                  Expanded(
                    child: _WorkflowStep(
                      icon: Icons.track_changes_rounded,
                      label: 'Goals',
                      color: Color(0xFF1683FF),
                    ),
                  ),
                  _SmallArrow(),
                  Expanded(
                    child: _WorkflowStep(
                      icon: Icons.auto_awesome_rounded,
                      label: 'AI Plan',
                      color: Color(0xFFE83CD7),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: _WorkflowStep(
                      icon: Icons.task_alt_rounded,
                      label: 'Study',
                      color: Color(0xFF00D7C5),
                    ),
                  ),
                  _SmallArrow(),
                  SizedBox(
                    width: 100,
                    child: _WorkflowStep(
                      icon: Icons.insights_rounded,
                      label: 'Analytics',
                      color: Color(0xFFFF8618),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(
              child: _WorkflowStep(
                icon: Icons.menu_book_rounded,
                label: 'Subjects',
                color: Color(0xFF7C3AED),
              ),
            ),

            _SmallArrow(),

            Expanded(
              child: _WorkflowStep(
                icon: Icons.track_changes_rounded,
                label: 'Goals',
                color: Color(0xFF1683FF),
              ),
            ),

            _SmallArrow(),

            Expanded(
              child: _WorkflowStep(
                icon: Icons.auto_awesome_rounded,
                label: 'AI Plan',
                color: Color(0xFFE83CD7),
              ),
            ),

            _SmallArrow(),

            Expanded(
              child: _WorkflowStep(
                icon: Icons.task_alt_rounded,
                label: 'Study',
                color: Color(0xFF00D7C5),
              ),
            ),

            _SmallArrow(),

            Expanded(
              child: _WorkflowStep(
                icon: Icons.insights_rounded,
                label: 'Analytics',
                color: Color(0xFFFF8618),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WorkflowStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _WorkflowStep({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(
              alpha: 0.12,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(
                alpha: 0.25,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),

        const SizedBox(height: 9),

        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFC4C9D7),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SmallArrow extends StatelessWidget {
  const _SmallArrow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 20,
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: Color(0xFF505873),
        size: 16,
      ),
    );
  }
}

// ============================================================================
// UPCOMING DEADLINE
// ============================================================================

class _UpcomingDeadlineCard extends StatelessWidget {
  const _UpcomingDeadlineCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8618).withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.event_rounded,
              color: Color(0xFFFF8618),
              size: 21,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Deadline',
                  style: TextStyle(
                    color: Color(0xFF81899F),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Database Systems Final',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8618).withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '8 days',
              style: TextStyle(
                color: Color(0xFFFF9B43),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TODAY FOCUS
// ============================================================================

class _TodayFocusCard extends StatelessWidget {
  const _TodayFocusCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: Color(0xFFB05CFF),
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'Today\'s Focus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                '3 sessions',
                style: TextStyle(
                  color: Color(0xFF9A72FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const _FocusItem(
            color: Color(0xFF7C3AED),
            subject: 'Data Structures',
            task: 'Graph algorithms',
            time: '60 min',
          ),

          const SizedBox(height: 10),

          const _FocusItem(
            color: Color(0xFF1683FF),
            subject: 'Database Systems',
            task: 'SQL practice',
            time: '45 min',
          ),

          const SizedBox(height: 10),

          const _FocusItem(
            color: Color(0xFF00D7C5),
            subject: 'Mathematics',
            task: 'Calculus revision',
            time: '50 min',
          ),
        ],
      ),
    );
  }
}

class _FocusItem extends StatelessWidget {
  final Color color;
  final String subject;
  final String task;
  final String time;

  const _FocusItem({
    required this.color,
    required this.subject,
    required this.task,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 35,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE4E6ED),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                task,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF7E869C),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          time,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// WEEKLY PROGRESS
// ============================================================================

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: Color(0xFF00D7C5),
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'Weekly Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Text(
                '78%',
                style: TextStyle(
                  color: Color(0xFF00D7C5),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 7,
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFF161C34),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.78,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1683FF),
                            Color(0xFF7C3AED),
                            Color(0xFF00D7C5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Text(
                '11 of 14 study sessions completed',
                style: TextStyle(
                  color: Color(0xFF7F879D),
                  fontSize: 10,
                ),
              ),
              Spacer(),
              Text(
                '+12% this week',
                style: TextStyle(
                  color: Color(0xFF00D7C5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DASHBOARD CARD
// ============================================================================

class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

// ============================================================================
// RIGHT CONTENT
// ============================================================================

class _WorkflowContent extends StatelessWidget {
  const _WorkflowContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'One workflow.\nLess academic chaos.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            height: 1.18,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Acadexa keeps your academic information connected. Your subjects '
          'shape your goals, your goals shape your study plan, and your '
          'completed sessions turn into useful performance insights.',
          style: TextStyle(
            color: Color(0xFFA8AEC3),
            fontSize: 15,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 30),

        const _WorkflowFeature(
          number: '01',
          icon: Icons.menu_book_rounded,
          title: 'Organize your subjects',
          description:
              'Keep courses and academic responsibilities organized in one place.',
          color: Color(0xFF7C3AED),
        ),

        const SizedBox(height: 22),

        const _WorkflowFeature(
          number: '02',
          icon: Icons.flag_rounded,
          title: 'Connect goals & deadlines',
          description:
              'Link exams, assignments, and personal study goals to what matters most.',
          color: Color(0xFF1683FF),
        ),

        const SizedBox(height: 22),

        const _WorkflowFeature(
          number: '03',
          icon: Icons.auto_awesome_rounded,
          title: 'Turn priorities into action',
          description:
              'Use AI-assisted planning to transform your workload into focused study sessions.',
          color: Color(0xFFE83CD7),
        ),

        const SizedBox(height: 22),

        const _WorkflowFeature(
          number: '04',
          icon: Icons.analytics_rounded,
          title: 'Learn from your progress',
          description:
              'Track completed work and use performance insights to decide what needs attention next.',
          color: Color(0xFF00D7C5),
        ),

        const SizedBox(height: 34),

        _GradientButton(),
      ],
    );
  }
}

// ============================================================================
// WORKFLOW FEATURE
// ============================================================================

class _WorkflowFeature extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _WorkflowFeature({
    required this.number,
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
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.12,
                ),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: color.withValues(
                    alpha: 0.20,
                  ),
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),

            Positioned(
              top: -7,
              right: -7,
              child: Container(
                width: 19,
                height: 19,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

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

// ============================================================================
// BUTTON
// ============================================================================

class _GradientButton extends StatefulWidget {
  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
                    color: const Color(0xFF7C3AED).withValues(
                      alpha: 0.25,
                    ),
                    blurRadius: 25,
                  ),
                ]
              : [],
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
                'Explore Your Dashboard',
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
    );
  }
}