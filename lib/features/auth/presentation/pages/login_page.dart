import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // EMAIL/PASSWORD LOGIN
  // ============================================================

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  // ============================================================
  // GOOGLE LOGIN
  // ============================================================

  void _googleLogin() {
    context.read<AuthBloc>().add(
          GoogleSignInRequested(),
        );
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030517),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/home');
          }

          if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Login failed',
                ),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            if (isMobile) {
              return _buildMobileLayout(context);
            }

            return _buildDesktopLayout(context);
          },
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1500,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 45,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // LEFT SIDE
                  // ==================================================

                  Expanded(
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 55,
                      ),
                      child: _buildLeftSide(),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // ==================================================
                  // RIGHT SIDE
                  // ==================================================

                  Expanded(
                    flex: 9,
                    child: _buildLoginCard(),
                  ),
                ],
              ),
            ),
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
        // BRAND
        Row(
          children: [
            _buildLogo(size: 48),
            const SizedBox(width: 15),
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

        const SizedBox(height: 75),

        // BADGE
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF17142F),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF6D35D9).withValues(
                alpha: 0.45,
              ),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 17,
                color: Color(0xFFB47CFF),
              ),
              SizedBox(width: 9),
              Text(
                'AI-Powered Study Planning',
                style: TextStyle(
                  color: Color(0xFFD5B9FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // HEADING
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 56,
              height: 1.08,
              fontWeight: FontWeight.w700,
              letterSpacing: -2,
            ),
            children: [
              TextSpan(
                text: 'Welcome ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'Back!',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        const SizedBox(
          width: 560,
          child: Text(
            'Log in to continue your journey and achieve\n'
            'your academic goals.',
            style: TextStyle(
              color: Color(0xFFB1B3C5),
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 35),

        // ILLUSTRATION
        SizedBox(
          height: 500,
          width: double.infinity,
          child: Image.asset(
            'assets/images/home/hero_illustration.png',
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
            errorBuilder: (context, error, stackTrace) {
              return _buildFallbackIllustration();
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOGIN CARD
  // ============================================================

  Widget _buildLoginCard() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 650,
      ),
      padding: const EdgeInsets.fromLTRB(
        48,
        42,
        48,
        38,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF08091D).withValues(
          alpha: 0.85,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF9B5CFF).withValues(
            alpha: 0.75,
          ),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D28D9).withValues(
              alpha: 0.10,
            ),
            blurRadius: 50,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==================================================
            // ICON
            // ==================================================

            Center(
              child: _buildLogo(
                size: 68,
                borderRadius: 22,
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // TITLE
            // ==================================================

            const Text(
              'Log in',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 43,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Welcome back! Please log in\n'
              'to continue your journey.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB5B7C8),
                fontSize: 18,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 38),

            // ==================================================
            // GOOGLE BUTTON
            // ==================================================

            SizedBox(
              height: 64,
              child: SignInButton(
                Buttons.google,
                text: 'Continue with Google',
                onPressed: _googleLogin,
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // OR
            // ==================================================

            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.white.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Color(0xFF8D8FA4),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.white.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ==================================================
            // EMAIL
            // ==================================================

            const Text(
              'Email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            AuthTextField(
              controller: _emailController,
              label: '',
              hint: 'Your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: _validateEmail,
            ),

            const SizedBox(height: 25),

            // ==================================================
            // PASSWORD
            // ==================================================

            const Text(
              'Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            AuthTextField(
              controller: _passwordController,
              label: '',
              hint: 'Enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
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
                  color: const Color(0xFF8E91A7),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // LOGIN BUTTON
            // ==================================================

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return _buildGradientLoginButton(
                  loading: state.status == AuthStatus.loading,
                );
              },
            ),

            const SizedBox(height: 24),

            // ==================================================
            // FORGOT PASSWORD
            // ==================================================

            Center(
              child: TextButton(
                onPressed: () {
                  context.go('/forgot-password');
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Color(0xFFA66BFF),
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // ==================================================
            // SIGN UP
            // ==================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Color(0xFFB4B6C7),
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFFA66BFF),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 30,
        ),
        child: Column(
          children: [
            // BRAND
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(size: 42),
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

            const SizedBox(height: 35),

            _buildLoginCard(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo({
    required double size,
    double? borderRadius,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6D28D9),
            Color(0xFF4F46E5),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(
          borderRadius ?? size * 0.24,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(
              alpha: 0.35,
            ),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        Icons.school_rounded,
        color: Colors.white,
        size: size * 0.48,
      ),
    );
  }

  // ============================================================
  // GRADIENT LOGIN BUTTON
  // ============================================================

  Widget _buildGradientLoginButton({
    required bool loading,
  }) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF2855FF),
            Color(0xFF7C3AED),
            Color(0xFFB832D8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(
              alpha: 0.25,
            ),
            blurRadius: 20,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  // ============================================================
  // FALLBACK ILLUSTRATION
  // ============================================================

  Widget _buildFallbackIllustration() {
    return Center(
      child: Container(
        width: 420,
        height: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: RadialGradient(
            colors: [
              const Color(0xFF6D28D9).withValues(
                alpha: 0.25,
              ),
              Colors.transparent,
            ],
          ),
        ),
        child: const Icon(
          Icons.menu_book_rounded,
          size: 180,
          color: Color(0xFF7C3AED),
        ),
      ),
    );
  }
}