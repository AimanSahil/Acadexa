import 'package:flutter/material.dart';

import 'dashboard_stat_card.dart';

class TopStatistics extends StatelessWidget {
  const TopStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        final cards = [
          const DashboardStatCard(
            title: 'Study Streak',
            value: '7 days',
            subtitle: 'Keep it going!',
            icon: Icons.local_fire_department_rounded,
            progress: 0.70,
          ),
          const DashboardStatCard(
            title: 'Goals',
            value: '0 / 2',
            subtitle: 'Completed',
            icon: Icons.track_changes_rounded,
            progress: 0.0,
          ),
          const DashboardStatCard(
            title: 'Tasks',
            value: '0 / 4',
            subtitle: 'Today',
            icon: Icons.check_circle_outline_rounded,
            progress: 0.0,
          ),
          const DashboardStatCard(
            title: 'Upcoming Exams',
            value: '3',
            subtitle: 'This month',
            icon: Icons.event_note_rounded,
            progress: 0.0,
          ),
        ];

        // Mobile
        if (width < 700) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i != cards.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }

        // Tablet
        if (width < 1100) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 14),
                  Expanded(child: cards[1]),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: cards[2]),
                  const SizedBox(width: 14),
                  Expanded(child: cards[3]),
                ],
              ),
            ],
          );
        }

        // Desktop
        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 16),
            Expanded(child: cards[1]),
            const SizedBox(width: 16),
            Expanded(child: cards[2]),
            const SizedBox(width: 16),
            Expanded(child: cards[3]),
          ],
        );
      },
    );
  }
}