import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository_impl.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl repository;

  AuthBloc(this.repository) : super(const AuthState()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<ForgotPasswordRequested>(_onForgotPassword);
    on<GoogleSignInRequested>(_onGoogleSignIn);
    on<AppleSignInRequested>(_onAppleSignIn);
    on<LogoutRequested>(_onLogout);
    on<AuthErrorCleared>(_onClearError);
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final user = await repository.login(
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final user = await repository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ============================================================
  // GOOGLE SIGN IN
  // ============================================================

  Future<void> _onGoogleSignIn(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final user = await repository.signInWithGoogle();

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Google sign-in failed.',
        ),
      );
    }
  }

  // ============================================================
  // APPLE SIGN IN
  // ============================================================

  Future<void> _onAppleSignIn(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      final user = await repository.signInWithApple();

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Apple sign-in failed.',
        ),
      );
    }
  }

  // ============================================================
  // FORGOT PASSWORD
  // ============================================================

  Future<void> _onForgotPassword(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        clearError: true,
        clearSuccess: true,
      ),
    );

    try {
      await repository.forgotPassword(
        email: event.email,
      );

      emit(
        state.copyWith(
          status: AuthStatus.success,
          successMessage:
              'Password reset link has been sent to your email.',
          clearError: true,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await repository.logout();

      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: _firebaseErrorMessage(e),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: 'Unable to logout.',
        ),
      );
    }
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void _onClearError(
    AuthErrorCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        clearError: true,
        clearSuccess: true,
      ),
    );
  }

  // ============================================================
  // FIREBASE ERROR MESSAGE
  // ============================================================

  String _firebaseErrorMessage(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';

      case 'popup-blocked':
        return 'The sign-in popup was blocked by your browser.';

      case 'account-exists-with-different-credential':
        return 'An account already exists with another sign-in method.';

      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'credential-already-in-use':
        return 'This account is already linked to another user.';

      case 'cancelled-popup-request':
        return 'Sign-in was cancelled.';

      default:
        return error.message ?? 'Authentication failed.';
    }
  }
}