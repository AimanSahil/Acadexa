import 'package:equatable/equatable.dart';

enum OnboardingStatus {
  initial,
  loading,
  success,
  failure,
}

class OnboardingState extends Equatable {
  // ============================================================
  // STEP
  // ============================================================

  final int currentStep;

  static const int totalSteps = 5;

  // ============================================================
  // USER INFORMATION
  // ============================================================

  final String name;

  // ============================================================
  // EDUCATION
  // ============================================================

  final String educationLevel;

  final String institution;

  final String fieldOfStudy;

  final String semester;

  // ============================================================
  // SUBJECTS
  // ============================================================

  final List<String> subjects;

  // ============================================================
  // GOAL
  // ============================================================

  final String primaryGoal;

  // ============================================================
  // PREFERENCES
  // ============================================================

  final double dailyStudyHours;

  final String preferredStudyTime;

  // ============================================================
  // STATUS
  // ============================================================

  final OnboardingStatus status;

  final String? errorMessage;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const OnboardingState({
    this.currentStep = 0,
    this.name = '',
    this.educationLevel = '',
    this.institution = '',
    this.fieldOfStudy = '',
    this.semester = '',
    this.subjects = const [],
    this.primaryGoal = '',
    this.dailyStudyHours = 2.0,
    this.preferredStudyTime = '',
    this.status = OnboardingStatus.initial,
    this.errorMessage,
  });

  // ============================================================
  // COPY WITH
  // ============================================================

  OnboardingState copyWith({
    int? currentStep,
    String? name,
    String? educationLevel,
    String? institution,
    String? fieldOfStudy,
    String? semester,
    List<String>? subjects,
    String? primaryGoal,
    double? dailyStudyHours,
    String? preferredStudyTime,
    OnboardingStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      educationLevel: educationLevel ?? this.educationLevel,
      institution: institution ?? this.institution,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      semester: semester ?? this.semester,
      subjects: subjects ?? this.subjects,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      dailyStudyHours: dailyStudyHours ?? this.dailyStudyHours,
      preferredStudyTime:
          preferredStudyTime ?? this.preferredStudyTime,
      status: status ?? this.status,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  // ============================================================
  // CURRENT STEP CHECKS
  // ============================================================

  bool get isFirstStep => currentStep == 0;

  bool get isLastStep => currentStep == totalSteps - 1;

  // ============================================================
  // PROGRESS
  // ============================================================

  double get progress {
    return (currentStep + 1) / totalSteps;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool get isCurrentStepValid {
    switch (currentStep) {
      case 0:
        return name.trim().isNotEmpty;

      case 1:
        return educationLevel.trim().isNotEmpty;

      case 2:
        return institution.trim().isNotEmpty &&
            fieldOfStudy.trim().isNotEmpty &&
            semester.trim().isNotEmpty;

      case 3:
        return subjects.isNotEmpty;

      case 4:
        return primaryGoal.trim().isNotEmpty &&
            preferredStudyTime.trim().isNotEmpty &&
            dailyStudyHours > 0;

      default:
        return false;
    }
  }

  // ============================================================
  // COMPLETE VALIDATION
  // ============================================================

  bool get isComplete {
    return name.trim().isNotEmpty &&
        educationLevel.trim().isNotEmpty &&
        institution.trim().isNotEmpty &&
        fieldOfStudy.trim().isNotEmpty &&
        semester.trim().isNotEmpty &&
        subjects.isNotEmpty &&
        primaryGoal.trim().isNotEmpty &&
        dailyStudyHours > 0 &&
        preferredStudyTime.trim().isNotEmpty;
  }

  // ============================================================
  // FIRESTORE DATA
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'educationLevel': educationLevel,
      'institution': institution.trim(),
      'fieldOfStudy': fieldOfStudy.trim(),
      'semester': semester,
      'subjects': subjects,
      'primaryGoal': primaryGoal,
      'dailyStudyHours': dailyStudyHours,
      'preferredStudyTime': preferredStudyTime,
      'onboardingCompleted': true,
    };
  }

  // ============================================================
  // EQUATABLE
  // ============================================================

  @override
  List<Object?> get props => [
        currentStep,
        name,
        educationLevel,
        institution,
        fieldOfStudy,
        semester,
        subjects,
        primaryGoal,
        dailyStudyHours,
        preferredStudyTime,
        status,
        errorMessage,
      ];
}