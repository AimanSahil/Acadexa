import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_firestore_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/onboarding_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  // ==========================================================
  // FIREBASE AUTH
  // ==========================================================

  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  // ==========================================================
  // FIREBASE FIRESTORE
  // ==========================================================

  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // ==========================================================
  // AUTH REMOTE DATASOURCE
  // ==========================================================

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(
      sl<FirebaseAuth>(),
    ),
  );

  // ==========================================================
  // AUTH FIRESTORE DATASOURCE
  // ==========================================================

  sl.registerLazySingleton<AuthFirestoreDatasource>(
    () => AuthFirestoreDatasource(
      sl<FirebaseFirestore>(),
    ),
  );

  // ==========================================================
  // AUTH REPOSITORY
  // ==========================================================

  sl.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDatasource>(),
      sl<AuthFirestoreDatasource>(),
    ),
  );

  // ==========================================================
  // AUTH BLOC
  // ==========================================================

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl<AuthRepositoryImpl>(),
    ),
  );

  // ==========================================================
  // ONBOARDING BLOC
  // ==========================================================

  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      sl<AuthRepositoryImpl>(),
    ),
  );
}