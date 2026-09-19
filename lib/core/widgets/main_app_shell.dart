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
    final size = MediaQuery.sizeOf(context);
    final width = size.width;

    // ==========================================================
    // DESKTOP
    // ==========================================================

    if (width >= 1100) {
      return Scaffold(
        backgroundColor: const Color(0xFF030418),
        body: SizedBox.expand(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 258,
                child: AppSidebar(
                  selectedRoute: selectedRoute,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ==========================================================
    // TABLET
    // ==========================================================

    if (width >= 700) {
      return Scaffold(
        backgroundColor: const Color(0xFF030418),
        body: SizedBox.expand(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 78,
                child: AppSidebar(
                  selectedRoute: selectedRoute,
                  collapsed: true,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ==========================================================
    // MOBILE
    // ==========================================================

    return Scaffold(
      backgroundColor: const Color(0xFF030418),
      drawer: Drawer(
        backgroundColor: const Color(0xFF050918),
        width: 258,
        child: AppSidebar(
          selectedRoute: selectedRoute,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF030418),
        elevation: 0,
        scrolledUnderElevation: 0,
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
      body: Align(
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }
}