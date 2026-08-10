import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ============================================================
  // REGISTER
  // ============================================================

  void _register() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          RegisterRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  // ============================================================
  // GOOGLE
  // ============================================================

  void _googleSignIn() {
    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
          const GoogleSignInRequested(),
        );
  }

  // ============================================================
  // APPLE
  // ============================================================

  void _appleSignIn() {
    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
          const AppleSignInRequested(),
        );
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Enter your full name';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030617),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            if (isMobile) {
              return _buildMobileLayout();
            }

            return _buildDesktopLayout();
          },
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 64,
        vertical: 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1440,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 55,
                    top: 10,
                  ),
                  child: _buildLeftSide(),
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                flex: 5,
                child: _buildRegisterCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEFT SIDE
  // ============================================================

  Widget _buildLeftSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LOGO

        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFF312EFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(
                      alpha: 0.35,
                    ),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),

            const SizedBox(width: 16),

            const Text(
              'Acadexa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 78),

        // BADGE

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF7C3AED).withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF7C3AED).withValues(
                alpha: 0.30,
              ),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Color(0xFFA78BFA),
                size: 16,
              ),
              SizedBox(width: 9),
              Text(
                'AI-Powered Study Planning',
                style: TextStyle(
                  color: Color(0xFFD8B4FE),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 34),

        // HEADING

        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Create Your\n',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  height: 1.08,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),
              TextSpan(
                text: 'Acadexa',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 52,
                  height: 1.08,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),
              TextSpan(
                text: ' Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  height: 1.08,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Join Acadexa and start building\n'
          'smarter study habits.',
          style: TextStyle(
            color: Color(0xFFA5ABC2),
            fontSize: 19,
            height: 1.7,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 25),

        // HERO IMAGE

        SizedBox(
          width: double.infinity,
          height: 500,
          child: Image.asset(
            'assets/images/home/hero_illustration.png',
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REGISTER CARD
  // ============================================================

  Widget _buildRegisterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 46,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF07091F).withValues(
          alpha: 0.82,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(
            alpha: 0.65,
          ),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(
              alpha: 0.08,
            ),
            blurRadius: 45,
            spreadRadius: 4,
          ),
        ],
      ),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/home');
            return;
          }

          if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Registration failed',
                  ),
                  backgroundColor: Colors.red.shade700,
                ),
              );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ==================================================
              // ICON
              // ==================================================

              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF9333EA),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(
                        alpha: 0.35,
                      ),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // TITLE
              // ==================================================

              const Text(
                'Create account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Start your journey with Acadexa and\n'
                'unlock your full learning potential.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFA5ABC2),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // ==================================================
              // FULL NAME
              // ==================================================

              AuthTextField(
                controller: _nameController,
                label: 'Full name',
                hint: 'Full name',
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: _validateName,
              ),

              const SizedBox(height: 17),

              // ==================================================
              // EMAIL
              // ==================================================

              AuthTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),

              const SizedBox(height: 17),

              // ==================================================
              // PASSWORD
              // ==================================================

              AuthTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                validator: _validatePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white60,
                  ),
                ),
              ),

              const SizedBox(height: 17),

              // ==================================================
              // CONFIRM PASSWORD
              // ==================================================

              AuthTextField(
                controller: _confirmPasswordController,
                label: 'Confirm password',
                hint: 'Confirm password',
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                validator: _validateConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white60,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // CREATE ACCOUNT
              // ==================================================

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AuthButton(
                    text: 'Create account',
                    loading: state.status == AuthStatus.loading,
                    onPressed: _register,
                  );
                },
              ),

              const SizedBox(height: 28),

              // ==================================================
              // OR
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white.withValues(
                        alpha: 0.13,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white.withValues(
                        alpha: 0.13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SOCIAL BUTTONS
              // ==================================================

              // Google - SAME STYLE AS LOGIN PAGE
              SizedBox(
                width: double.infinity,
                height: 54,
                child: SignInButton(
                  Buttons.google,
                  text: 'Continue with Google',
                  onPressed: _googleSignIn,
                ),
              ),

              const SizedBox(height: 14),

              // Apple
              SizedBox(
                width: double.infinity,
                height: 54,
                child: SignInButton(
                  Buttons.appleDark,
                  text: 'Sign up with Apple',
                  onPressed: _appleSignIn,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // LOGIN
              // ==================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Color(0xFFA5ABC2),
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Color(0xFFA78BFA),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7C3AED),
                      Color(0xFF312EFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              const Text(
                'Acadexa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          _buildRegisterCard(),
        ],
      ),
    );
  }
}