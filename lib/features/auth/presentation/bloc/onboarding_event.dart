import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// NEXT STEP
// ============================================================

class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

// ============================================================
// BACK STEP
// ============================================================

class OnboardingBackPressed extends OnboardingEvent {
  const OnboardingBackPressed();
}

// ============================================================
// STEP CHANGED
// ============================================================

class OnboardingStepChanged extends OnboardingEvent {
  final int step;

  const OnboardingStepChanged(this.step);

  @override
  List<Object?> get props => [step];
}

// ============================================================
// NAME
// ============================================================

class OnboardingNameChanged extends OnboardingEvent {
  final String name;

  const OnboardingNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

// ============================================================
// EDUCATION LEVEL
// ============================================================

class EducationLevelChanged extends OnboardingEvent {
  final String educationLevel;

  const EducationLevelChanged(this.educationLevel);

  @override
  List<Object?> get props => [educationLevel];
}

// ============================================================
// INSTITUTION
// ============================================================

class InstitutionChanged extends OnboardingEvent {
  final String institution;

  const InstitutionChanged(this.institution);

  @override
  List<Object?> get props => [institution];
}

// ============================================================
// FIELD OF STUDY
// ============================================================

class FieldOfStudyChanged extends OnboardingEvent {
  final String fieldOfStudy;

  const FieldOfStudyChanged(this.fieldOfStudy);

  @override
  List<Object?> get props => [fieldOfStudy];
}

// ============================================================
// SEMESTER
// ============================================================

class SemesterChanged extends OnboardingEvent {
  final String semester;

  const SemesterChanged(this.semester);

  @override
  List<Object?> get props => [semester];
}

// ============================================================
// ADD SUBJECT
// ============================================================

class SubjectAdded extends OnboardingEvent {
  final String subject;

  const SubjectAdded(this.subject);

  @override
  List<Object?> get props => [subject];
}

// ============================================================
// REMOVE SUBJECT
// ============================================================

class SubjectRemoved extends OnboardingEvent {
  final String subject;

  const SubjectRemoved(this.subject);

  @override
  List<Object?> get props => [subject];
}

// ============================================================
// PRIMARY GOAL
// ============================================================

class PrimaryGoalChanged extends OnboardingEvent {
  final String goal;

  const PrimaryGoalChanged(this.goal);

  @override
  List<Object?> get props => [goal];
}

// ============================================================
// DAILY STUDY HOURS
// ============================================================

class DailyStudyHoursChanged extends OnboardingEvent {
  final double hours;

  const DailyStudyHoursChanged(this.hours);

  @override
  List<Object?> get props => [hours];
}

// ============================================================
// PREFERRED STUDY TIME
// ============================================================

class PreferredStudyTimeChanged extends OnboardingEvent {
  final String time;

  const PreferredStudyTimeChanged(this.time);

  @override
  List<Object?> get props => [time];
}

// ============================================================
// COMPLETE ONBOARDING
// ============================================================

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

// ============================================================
// CLEAR ERROR
// ============================================================

class OnboardingErrorCleared extends OnboardingEvent {
  const OnboardingErrorCleared();
}

// ============================================================
// RESET
// ============================================================

class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}