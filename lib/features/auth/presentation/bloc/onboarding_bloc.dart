import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository_impl.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc
    extends Bloc<OnboardingEvent, OnboardingState> {
  final AuthRepositoryImpl repository;

  OnboardingBloc(this.repository)
      : super(const OnboardingState()) {
    // ============================================================
    // STEP
    // ============================================================

    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingBackPressed>(_onBackPressed);
    on<OnboardingStepChanged>(_onStepChanged);

    // ============================================================
    // USER INFORMATION
    // ============================================================

    on<OnboardingNameChanged>(_onNameChanged);

    // ============================================================
    // EDUCATION
    // ============================================================

    on<EducationLevelChanged>(
      _onEducationLevelChanged,
    );

    on<InstitutionChanged>(
      _onInstitutionChanged,
    );

    on<FieldOfStudyChanged>(
      _onFieldOfStudyChanged,
    );

    on<SemesterChanged>(
      _onSemesterChanged,
    );

    // ============================================================
    // SUBJECTS
    // ============================================================

    on<SubjectAdded>(_onSubjectAdded);
    on<SubjectRemoved>(_onSubjectRemoved);

    // ============================================================
    // GOAL
    // ============================================================

    on<PrimaryGoalChanged>(
      _onPrimaryGoalChanged,
    );

    // ============================================================
    // PREFERENCES
    // ============================================================

    on<DailyStudyHoursChanged>(
      _onDailyStudyHoursChanged,
    );

    on<PreferredStudyTimeChanged>(
      _onPreferredStudyTimeChanged,
    );

    // ============================================================
    // COMPLETE
    // ============================================================

    on<OnboardingCompleted>(_onCompleted);

    // ============================================================
    // ERROR
    // ============================================================

    on<OnboardingErrorCleared>(
      _onErrorCleared,
    );

    // ============================================================
    // RESET
    // ============================================================

    on<OnboardingReset>(_onReset);
  }

  // ============================================================
  // NEXT
  // ============================================================

  void _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) {
    // Validate current step before continuing.
    if (!state.isCurrentStepValid) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: _validationMessage(),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // LAST STEP
    // ----------------------------------------------------------

    if (state.isLastStep) {
      add(const OnboardingCompleted());
      return;
    }

    // ----------------------------------------------------------
    // NEXT STEP
    // ----------------------------------------------------------

    emit(
      state.copyWith(
        currentStep: state.currentStep + 1,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // BACK
  // ============================================================

  void _onBackPressed(
    OnboardingBackPressed event,
    Emitter<OnboardingState> emit,
  ) {
    // Already on first step.
    if (state.isFirstStep) {
      return;
    }

    emit(
      state.copyWith(
        currentStep: state.currentStep - 1,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // MANUAL STEP CHANGE
  // ============================================================

  void _onStepChanged(
    OnboardingStepChanged event,
    Emitter<OnboardingState> emit,
  ) {
    if (event.step < 0 ||
        event.step >= OnboardingState.totalSteps) {
      return;
    }

    emit(
      state.copyWith(
        currentStep: event.step,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // NAME
  // ============================================================

  void _onNameChanged(
    OnboardingNameChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // EDUCATION LEVEL
  // ============================================================

  void _onEducationLevelChanged(
    EducationLevelChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        educationLevel: event.educationLevel,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // INSTITUTION
  // ============================================================

  void _onInstitutionChanged(
    InstitutionChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        institution: event.institution,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // FIELD OF STUDY
  // ============================================================

  void _onFieldOfStudyChanged(
    FieldOfStudyChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        fieldOfStudy: event.fieldOfStudy,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // SEMESTER
  // ============================================================

  void _onSemesterChanged(
    SemesterChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        semester: event.semester,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // ADD SUBJECT
  // ============================================================

  void _onSubjectAdded(
    SubjectAdded event,
    Emitter<OnboardingState> emit,
  ) {
    final String subject = event.subject.trim();

    // Don't add empty subjects.
    if (subject.isEmpty) {
      return;
    }

    // Don't add duplicates.
    if (state.subjects.contains(subject)) {
      return;
    }

    final List<String> updatedSubjects = [
      ...state.subjects,
      subject,
    ];

    emit(
      state.copyWith(
        subjects: updatedSubjects,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // REMOVE SUBJECT
  // ============================================================

  void _onSubjectRemoved(
    SubjectRemoved event,
    Emitter<OnboardingState> emit,
  ) {
    final List<String> updatedSubjects = state.subjects
        .where(
          (subject) => subject != event.subject,
        )
        .toList();

    emit(
      state.copyWith(
        subjects: updatedSubjects,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // PRIMARY GOAL
  // ============================================================

  void _onPrimaryGoalChanged(
    PrimaryGoalChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        primaryGoal: event.goal,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // DAILY STUDY HOURS
  // ============================================================

  void _onDailyStudyHoursChanged(
    DailyStudyHoursChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        dailyStudyHours: event.hours,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // PREFERRED STUDY TIME
  // ============================================================

  void _onPreferredStudyTimeChanged(
    PreferredStudyTimeChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        preferredStudyTime: event.time,
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // COMPLETE ONBOARDING
  // ============================================================

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    // ==========================================================
    // VALIDATE EVERYTHING
    // ==========================================================

    if (!state.isComplete) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage:
              'Please complete all onboarding information.',
        ),
      );

      return;
    }

    // ==========================================================
    // LOADING
    // ==========================================================

    emit(
      state.copyWith(
        status: OnboardingStatus.loading,
        clearError: true,
      ),
    );

    // ==========================================================
    // SAVE TO FIRESTORE
    // ==========================================================

    try {
      await repository.saveOnboardingData(
        data: {
          // ====================================================
          // BASIC INFORMATION
          // ====================================================

          'name': state.name.trim(),

          // ====================================================
          // EDUCATION
          // ====================================================

          'educationLevel':
              state.educationLevel.trim(),

          'institution':
              state.institution.trim(),

          'fieldOfStudy':
              state.fieldOfStudy.trim(),

          'semester':
              state.semester.trim(),

          // ====================================================
          // SUBJECTS
          // ====================================================

          'subjects':
              List<String>.from(state.subjects),

          // ====================================================
          // GOAL
          // ====================================================

          'primaryGoal':
              state.primaryGoal.trim(),

          // ====================================================
          // STUDY PREFERENCES
          // ====================================================

          'dailyStudyHours':
              state.dailyStudyHours,

          'preferredStudyTime':
              state.preferredStudyTime.trim(),

          // ====================================================
          // ONBOARDING STATUS
          // ====================================================

          'onboardingCompleted': true,

          // ====================================================
          // TIMESTAMP
          // ====================================================

          'updatedAt': DateTime.now(),
        },
      );

      // ========================================================
      // SUCCESS
      // ========================================================

      emit(
        state.copyWith(
          status: OnboardingStatus.success,
          clearError: true,
        ),
      );
    } catch (e) {
      // ========================================================
      // FAILURE
      // ========================================================

      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage:
              'Unable to save your onboarding information. '
              'Please try again.',
        ),
      );
    }
  }

  // ============================================================
  // CLEAR ERROR
  // ============================================================

  void _onErrorCleared(
    OnboardingErrorCleared event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        status: OnboardingStatus.initial,
        clearError: true,
      ),
    );
  }

  // ============================================================
  // RESET
  // ============================================================

  void _onReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      const OnboardingState(),
    );
  }

  // ============================================================
  // VALIDATION MESSAGE
  // ============================================================

  String _validationMessage() {
    switch (state.currentStep) {
      // --------------------------------------------------------
      // STEP 1 - NAME
      // --------------------------------------------------------

      case 0:
        if (state.name.trim().isEmpty) {
          return 'Please enter your name.';
        }

        return 'Please enter your name.';

      // --------------------------------------------------------
      // STEP 2 - EDUCATION
      // --------------------------------------------------------

      case 1:
        if (state.educationLevel.trim().isEmpty) {
          return 'Please select your education level.';
        }

        return 'Please select your education level.';

      // --------------------------------------------------------
      // STEP 3 - ACADEMIC INFO
      // --------------------------------------------------------

      case 2:
        if (state.institution.trim().isEmpty) {
          return 'Please enter your institution.';
        }

        if (state.fieldOfStudy.trim().isEmpty) {
          return 'Please enter your field of study.';
        }

        if (state.semester.trim().isEmpty) {
          return 'Please select your semester.';
        }

        return 'Please complete your academic information.';

      // --------------------------------------------------------
      // STEP 4 - SUBJECTS
      // --------------------------------------------------------

      case 3:
        if (state.subjects.isEmpty) {
          return 'Please add at least one subject.';
        }

        return 'Please add at least one subject.';

      // --------------------------------------------------------
      // STEP 5 - GOALS
      // --------------------------------------------------------

      case 4:
        if (state.primaryGoal.trim().isEmpty) {
          return 'Please select your primary goal.';
        }

        if (state.preferredStudyTime.trim().isEmpty) {
          return 'Please select your preferred study time.';
        }

        return 'Please complete your study preferences.';

      // --------------------------------------------------------
      // DEFAULT
      // --------------------------------------------------------

      default:
        return 'Please complete this step.';
    }
  }
}