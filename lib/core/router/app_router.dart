import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../di/service_locator.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',

  routes: [
    // ==========================================================
    // HOME
    // ==========================================================

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        return const HomePage();
      },
    ),

    // ==========================================================
    // LOGIN
    // ==========================================================

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

    // ==========================================================
    // REGISTER
    // ==========================================================

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

    // ==========================================================
    // FORGOT PASSWORD
    // ==========================================================

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