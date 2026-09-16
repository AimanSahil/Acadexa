import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/main_app_shell.dart';
import '../widgets/bottom_statistics.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_main_grid.dart';
import '../widgets/top_statistics.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainAppShell(
      selectedRoute: '/dashboard',
      child: _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 700;
          final bool isTablet = constraints.maxWidth < 1100;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? 16
                  : isTablet
                      ? 22
                      : 30,
              vertical: isMobile ? 18 : 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHeader(),

                SizedBox(
                  height: isMobile ? 18 : 24,
                ),

                const TopStatistics(),

                SizedBox(
                  height: isMobile ? 16 : 20,
                ),

                const DashboardMainGrid(),

                SizedBox(
                  height: isMobile ? 16 : 20,
                ),

                const BottomStatistics(),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}