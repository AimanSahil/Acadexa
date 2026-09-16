import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'premium_card.dart';
import 'sidebar_item.dart';

class AppSidebar extends StatelessWidget {
  final String selectedRoute;
  final bool collapsed;

  const AppSidebar({
    super.key,
    required this.selectedRoute,
    this.collapsed = false,
  });

  void _navigate(
    BuildContext context,
    String route,
  ) {
    if (selectedRoute == route) return;

    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: collapsed ? 78 : 245,
      decoration: BoxDecoration(
        color: const Color(0xFF050918),
        border: const Border(
          right: BorderSide(
            color: Color(0xFF151B35),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildBrand(),

            const SizedBox(height: 13),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SidebarItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Dashboard',
                      selected: selectedRoute == '/dashboard',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/dashboard',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.track_changes_outlined,
                      title: 'Goals',
                      selected: selectedRoute == '/goals',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/goals',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.menu_book_outlined,
                      title: 'Subjects',
                      selected: selectedRoute == '/subjects',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/subjects',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.calendar_month_outlined,
                      title: 'Study Plans',
                      selected: selectedRoute == '/study-plans',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/study-plans',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.checklist_outlined,
                      title: 'Tasks',
                      selected: selectedRoute == '/tasks',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/tasks',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.event_note_outlined,
                      title: 'Exams',
                      selected: selectedRoute == '/exams',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/exams',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.description_outlined,
                      title: 'Notes',
                      selected: selectedRoute == '/notes',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/notes',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.style_outlined,
                      title: 'Flashcards',
                      selected: selectedRoute == '/flashcards',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/flashcards',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.quiz_outlined,
                      title: 'Quizzes',
                      selected: selectedRoute == '/quizzes',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/quizzes',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.smart_toy_outlined,
                      title: 'AI Tutor',
                      selected: selectedRoute == '/ai-tutor',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/ai-tutor',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.bar_chart_outlined,
                      title: 'Analytics',
                      selected: selectedRoute == '/analytics',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/analytics',
                      ),
                    ),

                    SidebarItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Profile',
                      selected: selectedRoute == '/profile',
                      collapsed: collapsed,
                      onTap: () => _navigate(
                        context,
                        '/profile',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (!collapsed)
              const PremiumCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        collapsed ? 0 : 17,
        18,
        collapsed ? 0 : 17,
        5,
      ),
      child: Row(
        mainAxisAlignment: collapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFF4F46E5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.38),
                  blurRadius: 15,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),

          if (!collapsed) ...[
            const SizedBox(width: 9),
            const Text(
              'Acadexa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}