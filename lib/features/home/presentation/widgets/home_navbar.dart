import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class HomeNavbar extends StatelessWidget {
  const HomeNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;

        return Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 48,
            vertical: isMobile ? 18 : 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Row(
                children: [
                  // ==========================================
                  // LOGO
                  // ==========================================

                  Container(
                    width: isMobile ? 38 : 42,
                    height: isMobile ? 38 : 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF7C3AED),
                          Color(0xFF312EFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6D28D9)
                              .withValues(alpha: 0.18),
                          blurRadius: 14,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: isMobile ? 22 : 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ==========================================
                  // BRAND NAME
                  // ==========================================

                  Text(
                    'Acadexa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 23 : 26,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const Spacer(),

                  // ==========================================
                  // DESKTOP BUTTONS
                  // ==========================================

                  if (!isMobile) ...[
                    // LOGIN
                    SizedBox(
                      height: 42,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.go('/login');
                        },
                        icon: const Icon(
                          Icons.person_rounded,
                          size: 16,
                        ),
                        label: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          side: BorderSide(
                            color: const Color(0xFF7C3AED)
                                .withValues(alpha: 0.75),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    // ==========================================
                    // GET STARTED
                    // ==========================================

                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF2855FF),
                            Color(0xFF7C3AED),
                            Color(0xFFDC36DB),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED)
                                .withValues(alpha: 0.18),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ]

                  // ==========================================
                  // MOBILE MENU
                  // ==========================================

                  else
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7C3AED)
                              .withValues(alpha: 0.45),
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
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