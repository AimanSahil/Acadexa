import 'package:flutter/material.dart';

class GoalStep extends StatelessWidget {
  final String selectedGoal;
  final double dailyStudyHours;

  final ValueChanged<String> onGoalChanged;
  final ValueChanged<double> onHoursChanged;

  const GoalStep({
    super.key,
    required this.selectedGoal,
    required this.dailyStudyHours,
    required this.onGoalChanged,
    required this.onHoursChanged,
  });

  @override
  Widget build(BuildContext context) {
    const goals = [
      'Improve my grades',
      'Prepare for exams',
      'Build better study habits',
      'Complete assignments',
      'Learn new skills',
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
          // MAIN GOAL
          // =====================================================

          const Text(
            'What is your main goal?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 14),

          // =====================================================
          // GOALS
          // =====================================================

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;

              if (isWide) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _GoalCard(
                            title: goals[0],
                            icon: Icons.track_changes_rounded,
                            selected:
                                selectedGoal == goals[0],
                            onTap: () =>
                                onGoalChanged(goals[0]),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _GoalCard(
                            title: goals[1],
                            icon: Icons.menu_book_rounded,
                            selected:
                                selectedGoal == goals[1],
                            onTap: () =>
                                onGoalChanged(goals[1]),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _GoalCard(
                            title: goals[2],
                            icon: Icons.auto_graph_rounded,
                            selected:
                                selectedGoal == goals[2],
                            onTap: () =>
                                onGoalChanged(goals[2]),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _GoalCard(
                            title: goals[3],
                            icon: Icons.description_outlined,
                            selected:
                                selectedGoal == goals[3],
                            onTap: () =>
                                onGoalChanged(goals[3]),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _GoalCard(
                      title: goals[4],
                      icon: Icons.star_outline_rounded,
                      selected:
                          selectedGoal == goals[4],
                      onTap: () =>
                          onGoalChanged(goals[4]),
                    ),
                  ],
                );
              }

              // =================================================
              // MOBILE
              // =================================================

              return Column(
                children: goals.map(
                  (goal) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: _GoalCard(
                        title: goal,
                        icon: _getIcon(goal),
                        selected:
                            selectedGoal == goal,
                        onTap: () =>
                            onGoalChanged(goal),
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),

          const SizedBox(height: 28),

          // =====================================================
          // DAILY STUDY HOURS
          // =====================================================

          const Text(
            'How much can you study each day?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 16),

          // =====================================================
          // HOURS LABELS
          // =====================================================

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1 hour',
                style: TextStyle(
                  color: Color(0xFF9A9DAF),
                  fontSize: 14,
                ),
              ),

              Text(
                '${dailyStudyHours.toStringAsFixed(1)} hours',
                style: const TextStyle(
                  color: Color(0xFFA96BFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Text(
                '6 hours',
                style: TextStyle(
                  color: Color(0xFF9A9DAF),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // =====================================================
          // SLIDER
          // =====================================================

          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,

              activeTrackColor:
                  const Color(0xFF8B3DFF),

              inactiveTrackColor:
                  const Color(0xFF292C42),

              thumbColor:
                  const Color(0xFF9B55FF),

              overlayColor:
                  const Color(0xFF8B3DFF).withValues(
                alpha: 0.15,
              ),

              thumbShape:
                  const RoundSliderThumbShape(
                enabledThumbRadius: 9,
              ),

              overlayShape:
                  const RoundSliderOverlayShape(
                overlayRadius: 18,
              ),
            ),
            child: Slider(
              value: dailyStudyHours.clamp(
                1.0,
                6.0,
              ),
              min: 1.0,
              max: 6.0,
              divisions: 10,
              onChanged: onHoursChanged,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ICON
  // =============================================================

  IconData _getIcon(String goal) {
    switch (goal) {
      case 'Improve my grades':
        return Icons.track_changes_rounded;

      case 'Prepare for exams':
        return Icons.menu_book_rounded;

      case 'Build better study habits':
        return Icons.auto_graph_rounded;

      case 'Complete assignments':
        return Icons.description_outlined;

      case 'Learn new skills':
        return Icons.star_outline_rounded;

      default:
        return Icons.flag_outlined;
    }
  }
}

// ===============================================================
// GOAL CARD
// ===============================================================

class _GoalCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        height: 54,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF15102A)
              : const Color(0xFF090B1B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF913DFF)
                : const Color(0xFF292C43),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            // ===================================================
            // ICON
            // ===================================================

            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF28134D)
                    : const Color(0xFF15172B),
                borderRadius:
                    BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected
                    ? const Color(0xFFA96BFF)
                    : const Color(0xFF85899C),
              ),
            ),

            const SizedBox(width: 12),

            // ===================================================
            // TITLE
            // ===================================================

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : const Color(0xFFD7D8E1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // ===================================================
            // RADIO
            // ===================================================

            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFA65BFF)
                      : const Color(0xFF55596E),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration:
                            const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFA65BFF),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}