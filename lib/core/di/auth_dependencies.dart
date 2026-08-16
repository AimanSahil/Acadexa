import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_firestore_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

void setupAuthDependencies() {
  // ============================================================
  // FIREBASE AUTH
  // ============================================================

  if (!sl.isRegistered<FirebaseAuth>()) {
    sl.registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    );
  }

  // ============================================================
  // FIREBASE FIRESTORE
  // ============================================================

  if (!sl.isRegistered<FirebaseFirestore>()) {
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
  }

  // ============================================================
  // AUTH REMOTE DATASOURCE
  // ============================================================

  if (!sl.isRegistered<AuthRemoteDatasource>()) {
    sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(
        sl<FirebaseAuth>(),
      ),
    );
  }

  // ============================================================
  // AUTH FIRESTORE DATASOURCE
  // ============================================================

  if (!sl.isRegistered<AuthFirestoreDatasource>()) {
    sl.registerLazySingleton<AuthFirestoreDatasource>(
      () => AuthFirestoreDatasource(
        sl<FirebaseFirestore>(),
      ),
    );
  }

  // ============================================================
  // AUTH REPOSITORY
  // ============================================================

  if (!sl.isRegistered<AuthRepositoryImpl>()) {
    sl.registerLazySingleton<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        sl<AuthRemoteDatasource>(),
        sl<AuthFirestoreDatasource>(),
      ),
    );
  }

  // ============================================================
  // AUTH BLOC
  // ============================================================

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(
        sl<AuthRepositoryImpl>(),
      ),
    );
  }
}