import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/onboarding_bloc.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../di/service_locator.dart';

final GoRouter appRouter = GoRouter(
  // ==========================================================
  // FIRST SCREEN
  // ==========================================================

  initialLocation: '/home',

  // ==========================================================
  // REDIRECT
  // ==========================================================

  redirect: (context, state) async {
    final User? user = FirebaseAuth.instance.currentUser;

    final String location = state.matchedLocation;

    // ========================================================
    // USER IS NOT LOGGED IN
    // ========================================================

    if (user == null) {
      // Home is public
      if (location == '/home') {
        return null;
      }

      // Authentication pages are public
      if (location == '/login' ||
          location == '/register' ||
          location == '/forgot-password') {
        return null;
      }

      // Everything else goes to home
      return '/home';
    }

    // ========================================================
    // USER IS LOGGED IN
    // ========================================================

    try {
      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final Map<String, dynamic>? data = userDocument.data();

      final bool onboardingCompleted =
          data?['onboardingCompleted'] == true;

      // ======================================================
      // ONBOARDING NOT COMPLETED
      // ======================================================

      if (!onboardingCompleted) {
        if (location != '/onboarding') {
          return '/onboarding';
        }

        return null;
      }

      // ======================================================
      // ONBOARDING COMPLETED
      // ======================================================

      if (location == '/login' ||
          location == '/register' ||
          location == '/forgot-password' ||
          location == '/onboarding') {
        return '/home';
      }

      return null;
    } catch (e) {
      // ======================================================
      // FIRESTORE ERROR
      // ======================================================

      if (location != '/onboarding') {
        return '/onboarding';
      }

      return null;
    }
  },

  // ==========================================================
  // ROUTES
  // ==========================================================

  routes: [
    // ========================================================
    // HOME
    // ========================================================

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        return const HomePage();
      },
    ),

    // ========================================================
    // ONBOARDING
    // ========================================================

    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<OnboardingBloc>(),
          child: const OnboardingPage(),
        );
      },
    ),

    // ========================================================
    // LOGIN
    // ========================================================

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const LoginPage(),
        );
      },
    ),

    // ========================================================
    // REGISTER
    // ========================================================

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const RegisterPage(),
        );
      },
    ),

    // ========================================================
    // FORGOT PASSWORD
    // ========================================================

    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const ForgotPasswordPage(),
        );
      },
    ),
  ],
);