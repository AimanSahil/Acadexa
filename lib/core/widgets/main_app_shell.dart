import 'package:flutter/material.dart';

import 'app_sidebar.dart';

class MainAppShell extends StatelessWidget {
  final Widget child;
  final String selectedRoute;

  const MainAppShell({
    super.key,
    required this.child,
    required this.selectedRoute,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    // Desktop
    if (width >= 1100) {
      return Scaffold(
        backgroundColor: const Color(0xFF030617),
        body: Row(
          children: [
            AppSidebar(
              selectedRoute: selectedRoute,
            ),

            Expanded(
              child: child,
            ),
          ],
        ),
      );
    }

    // Tablet
    if (width >= 700) {
      return Scaffold(
        backgroundColor: const Color(0xFF030617),
        body: Row(
          children: [
            AppSidebar(
          selectedRoute: selectedRoute,
          collapsed: true,
            ),
            Expanded(
              child: child,
            ),
          ],
        ),
      );
    }

    // Mobile
    return Scaffold(
      backgroundColor: const Color(0xFF030617),
      drawer: Drawer(
        backgroundColor: const Color(0xFF050918),
        width: 245,
        child: AppSidebar(
          selectedRoute: selectedRoute,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030617),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Acadexa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: child,
    );
  }
}