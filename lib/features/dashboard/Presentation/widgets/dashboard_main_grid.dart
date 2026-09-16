import 'package:flutter/material.dart';

import 'ai_suggestions_card.dart';
import 'today_tasks_card.dart';

class DashboardMainGrid extends StatelessWidget {
  const DashboardMainGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 1050) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TodayTasksCard(),
              ),
              SizedBox(width: 18),
              Expanded(
                flex: 2,
                child: AiSuggestionsCard(),
              ),
            ],
          );
        }

        if (width >= 700) {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TodayTasksCard(),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AiSuggestionsCard(),
              ),
            ],
          );
        }

        return const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TodayTasksCard(),
            SizedBox(height: 16),
            AiSuggestionsCard(),
          ],
        );
      },
    );
  }
}