import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';

import '../widgets/education_step.dart';
import '../widgets/academic_info_step.dart';
import '../widgets/subjects_step.dart';
import '../widgets/goal_step.dart';
import '../widgets/preferences_step.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _OnboardingView();
  }
}

// ============================================================================
// VIEW
// ============================================================================

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade700,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            ),
          );

          context.read<OnboardingBloc>().add(
                const OnboardingErrorCleared(),
              );
        }

        if (state.status == OnboardingStatus.success) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.go('/home');
        }
      },
      child: const _OnboardingContent(),
    );
  }
}

// ============================================================================
// CONTENT
// ============================================================================

class _OnboardingContent extends StatefulWidget {
  const _OnboardingContent();

  @override
  State<_OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<_OnboardingContent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _institutionController =
      TextEditingController();
  final TextEditingController _fieldController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030517),
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1000;

                if (isDesktop) {
                  return _buildDesktopLayout(context, state);
                }

                return _buildMobileLayout(context, state);
              },
            );
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // DESKTOP
  // ==========================================================================

  Widget _buildDesktopLayout(
    BuildContext context,
    OnboardingState state,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 18, 34, 18),
      child: Column(
        children: [
          // --------------------------------------------------------------
          // TOP
          // --------------------------------------------------------------
          SizedBox(
            height: 112,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBrand(false),
                      const SizedBox(height: 20),
                      _buildAiBadge(),
                    ],
                  ),
                ),
                const SizedBox(width: 35),
                Expanded(
                  child: _buildProgressHeader(state),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // --------------------------------------------------------------
          // MAIN TWO-COLUMN AREA
          // --------------------------------------------------------------
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LEFT ILLUSTRATION
                SizedBox(
                  width: 500,
                  child: Center(
                    child: _buildIllustration(),
                  ),
                ),

                const SizedBox(width: 50),

                // RIGHT CONTENT
                Expanded(
                  child: _buildDesktopRightSide(
                    context,
                    state,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRightSide(
    BuildContext context,
    OnboardingState state,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 820,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // MAIN TITLE
            // ------------------------------------------------------------
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 38,
                  height: 1.12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.2,
                ),
                children: [
                  TextSpan(
                    text: "Let's personalize your ",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'learning',
                    style: TextStyle(
                      color: Color(0xFFA855F7),
                    ),
                  ),
                  TextSpan(
                    text: ' experience',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Tell us a little about yourself so Acadexa can create '
              'a better study experience for you.',
              style: TextStyle(
                color: Color(0xFFA7AABE),
                fontSize: 16,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 22),

            // ------------------------------------------------------------
            // STEP / PERCENTAGE
            // ------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${state.currentStep + 1} of 5',
                  style: const TextStyle(
                    color: Color(0xFFA970FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(state.currentStep + 1) * 20}%',
                  style: const TextStyle(
                    color: Color(0xFFA7AABE),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: (state.currentStep + 1) / 5,
                minHeight: 7,
                backgroundColor: const Color(0xFF171A31),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFA855F7),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ------------------------------------------------------------
            // CURRENT STEP
            // ------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildStep(
                    context,
                    state,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ------------------------------------------------------------
            // NAVIGATION
            // ------------------------------------------------------------
            _buildDesktopNavigation(
              context,
              state,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // MOBILE
  // ==========================================================================

  Widget _buildMobileLayout(
    BuildContext context,
    OnboardingState state,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            0,
          ),
          child: Row(
            children: [
              _buildBrand(true),
              const SizedBox(width: 18),
              Expanded(
                child: _buildMobileProgress(state),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              25,
              20,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 28,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      TextSpan(
                        text: "Let's personalize your ",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'learning',
                        style: TextStyle(
                          color: Color(0xFFA855F7),
                        ),
                      ),
                      TextSpan(
                        text: ' experience',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tell us a little about yourself so Acadexa can create '
                  'a better study experience for you.',
                  style: TextStyle(
                    color: Color(0xFFA7AABE),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${state.currentStep + 1} of 5',
                      style: const TextStyle(
                        color: Color(0xFFA970FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(state.currentStep + 1) * 20}%',
                      style: const TextStyle(
                        color: Color(0xFFA7AABE),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: (state.currentStep + 1) / 5,
                    minHeight: 6,
                    backgroundColor: const Color(0xFF171A31),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Color(0xFFA855F7),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildStep(context, state),
              ],
            ),
          ),
        ),

        _buildMobileNavigation(
          context,
          state,
        ),
      ],
    );
  }

  // ==========================================================================
  // BRAND
  // ==========================================================================

  Widget _buildBrand(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isMobile ? 48 : 52,
          height: isMobile ? 48 : 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6D28D9),
                Color(0xFF8B5CF6),
              ],
            ),
            borderRadius: BorderRadius.circular(
              isMobile ? 13 : 14,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED)
                    .withValues(alpha: 0.35),
                blurRadius: 25,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: isMobile ? 26 : 29,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'Acadexa',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 25 : 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // AI BADGE
  // ==========================================================================

  Widget _buildAiBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF100A29),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF5520A5),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 17,
            color: Color(0xFFB47CFF),
          ),
          SizedBox(width: 8),
          Text(
            'AI-Powered Study Planning',
            style: TextStyle(
              color: Color(0xFFE6DBFF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ILLUSTRATION
  // ==========================================================================

  Widget _buildIllustration() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 510,
        maxHeight: 510,
      ),
      child: Image.asset(
        'assets/images/home/hero_illustration.png',
        fit: BoxFit.contain,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _buildFallbackIllustration();
        },
      ),
    );
  }

  Widget _buildFallbackIllustration() {
    return Container(
      width: 360,
      height: 360,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0D0822),
        border: Border.all(
          color: const Color(0xFF5420A0),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.school_rounded,
          size: 100,
          color: Color(0xFFA855F7),
        ),
      ),
    );
  }

  // ==========================================================================
  // DESKTOP PROGRESS
  // ==========================================================================

  Widget _buildProgressHeader(
    OnboardingState state,
  ) {
    const labels = [
      'Welcome',
      'Education',
      'Academic Info',
      'Subjects',
      'Goals',
    ];

    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        right: 10,
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final active =
                index == state.currentStep;
            final completed =
                index < state.currentStep;

            return Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 220),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active || completed
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF101329),
                          border: Border.all(
                            color: active
                                ? const Color(0xFFB47CFF)
                                : completed
                                    ? const Color(0xFF7C3AED)
                                    : const Color(0xFF292D49),
                            width: active ? 2 : 1,
                          ),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF8B5CF6)
                                        .withValues(alpha: 0.45),
                                    blurRadius: 20,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: active || completed
                                ? Colors.white
                                : const Color(0xFF9699AD),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        labels[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: active
                              ? const Color(0xFFA970FF)
                              : const Color(0xFF9FA2B6),
                          fontSize: 13,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  if (index != labels.length - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.only(
                          bottom: 31,
                          left: 8,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: index < state.currentStep
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF242740),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // MOBILE PROGRESS
  // ==========================================================================

  Widget _buildMobileProgress(
    OnboardingState state,
  ) {
    return Row(
      children: List.generate(
        5,
        (index) {
          final active =
              index == state.currentStep;
          final completed =
              index < state.currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active || completed
                        ? const Color(0xFF7C3AED)
                        : const Color(0xFF111329),
                    border: Border.all(
                      color: active
                          ? const Color(0xFFB47CFF)
                          : const Color(0xFF292D49),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (index != 4)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      color: index < state.currentStep
                          ? const Color(0xFF7C3AED)
                          : const Color(0xFF242740),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==========================================================================
  // STEP BUILDER
  // ==========================================================================

  Widget _buildStep(
    BuildContext context,
    OnboardingState state,
  ) {
    switch (state.currentStep) {
      case 0:
        return _buildStepOne(
          context,
          state,
        );

      case 1:
        return EducationStep(
          key: const ValueKey('education'),
          selectedEducation:
              state.educationLevel,
          onSelected: (value) {
            context
                .read<OnboardingBloc>()
                .add(
                  EducationLevelChanged(value),
                );
          },
        );

      case 2:
        return AcademicInfoStep(
          key: const ValueKey('academic'),
          institutionController:
              _institutionController,
          fieldController:
              _fieldController,
          selectedSemester:
              state.semester.isEmpty
                  ? null
                  : state.semester,
          onInstitutionChanged: (value) {
            context
                .read<OnboardingBloc>()
                .add(
                  InstitutionChanged(value),
                );
          },
          onFieldChanged: (value) {
            context
                .read<OnboardingBloc>()
                .add(
                  FieldOfStudyChanged(value),
                );
          },
          onSemesterChanged: (value) {
            if (value == null) return;

            context
                .read<OnboardingBloc>()
                .add(
                  SemesterChanged(value),
                );
          },
        );

      case 3:
        return SubjectsStep(
          key: const ValueKey('subjects'),
          subjects: state.subjects,
          onAdd: (subject) {
            context
                .read<OnboardingBloc>()
                .add(
                  SubjectAdded(subject),
                );
          },
          onRemove: (subject) {
            context
                .read<OnboardingBloc>()
                .add(
                  SubjectRemoved(subject),
                );
          },
        );

      case 4:
        return _buildFinalStep(
          context,
          state,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // ==========================================================================
  // STEP 1
  // ==========================================================================

  Widget _buildStepOne(
    BuildContext context,
    OnboardingState state,
  ) {
    if (_nameController.text != state.name) {
      _nameController.text = state.name;
      _nameController.selection =
          TextSelection.collapsed(
        offset: _nameController.text.length,
      );
    }

    return Container(
      key: const ValueKey('welcome'),
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0D23),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF272A45),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'What should we call you?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your name to personalize your Acadexa experience.',
            style: TextStyle(
              color: Color(0xFF9699AD),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              context
                  .read<OnboardingBloc>()
                  .add(
                    OnboardingNameChanged(value),
                  );
            },
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: 'Your full name',
              hintStyle: const TextStyle(
                color: Color(0xFF70738A),
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFFA855F7),
                size: 24,
              ),
              filled: true,
              fillColor: const Color(0xFF080A1B),
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF292C49),
                ),
              ),
              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF8B5CF6),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // FINAL STEP
  // ==========================================================================

  Widget _buildFinalStep(
    BuildContext context,
    OnboardingState state,
  ) {
    return Column(
      key: const ValueKey('final'),
      children: [
        GoalStep(
          selectedGoal: state.primaryGoal,
          dailyStudyHours:
              state.dailyStudyHours,
          onGoalChanged: (goal) {
            context
                .read<OnboardingBloc>()
                .add(
                  PrimaryGoalChanged(goal),
                );
          },
          onHoursChanged: (hours) {
            context
                .read<OnboardingBloc>()
                .add(
                  DailyStudyHoursChanged(hours),
                );
          },
        ),
        const SizedBox(height: 18),
        PreferencesStep(
          selectedStudyTime:
              state.preferredStudyTime,
          onStudyTimeChanged: (time) {
            context
                .read<OnboardingBloc>()
                .add(
                  PreferredStudyTimeChanged(time),
                );
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // DESKTOP NAVIGATION
  // ==========================================================================

  Widget _buildDesktopNavigation(
    BuildContext context,
    OnboardingState state,
  ) {
    return Row(
      children: [
        if (state.currentStep > 0)
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 58,
              child: OutlinedButton(
                onPressed:
                    state.status ==
                            OnboardingStatus.loading
                        ? null
                        : () {
                            context
                                .read<OnboardingBloc>()
                                .add(
                                  const OnboardingBackPressed(),
                                );
                          },
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF292D49),
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                    ),
                    SizedBox(width: 9),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        if (state.currentStep > 0)
          const SizedBox(width: 18),

        Expanded(
          flex: state.currentStep > 0 ? 2 : 1,
          child: _buildContinueButton(
            context,
            state,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // MOBILE NAVIGATION
  // ==========================================================================

  Widget _buildMobileNavigation(
    BuildContext context,
    OnboardingState state,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        18,
      ),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: SizedBox(
                height: 58,
                child: OutlinedButton(
                  onPressed:
                      state.status ==
                              OnboardingStatus.loading
                          ? null
                          : () {
                              context
                                  .read<
                                      OnboardingBloc>()
                                  .add(
                                    const OnboardingBackPressed(),
                                  );
                            },
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFF292D49),
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
              ),
            ),
          if (state.currentStep > 0)
            const SizedBox(width: 12),
          Expanded(
            flex: state.currentStep > 0 ? 2 : 1,
            child: _buildContinueButton(
              context,
              state,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // CONTINUE BUTTON
  // ==========================================================================

  Widget _buildContinueButton(
    BuildContext context,
    OnboardingState state,
  ) {
    final loading =
        state.status == OnboardingStatus.loading;
    final isLast =
        state.currentStep == 4;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF6824E8),
              Color(0xFF8B2BEA),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED)
                  .withValues(alpha: 0.25),
              blurRadius: 25,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: loading
              ? null
              : () {
                  context
                      .read<OnboardingBloc>()
                      .add(
                        const OnboardingNextPressed(),
                      );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor:
                Colors.transparent,
            foregroundColor: Colors.white,
            disabledForegroundColor:
                Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 23,
                  height: 23,
                  child:
                      CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Finish' : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      isLast
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                      size: 22,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
