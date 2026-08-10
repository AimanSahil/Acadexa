import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

void setupAuthDependencies() {
  // ============================================================
  // FIREBASE AUTH
  // ============================================================

  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  // ============================================================
  // AUTH REMOTE DATASOURCE
  // ============================================================

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(
      sl<FirebaseAuth>(),
    ),
  );

  // ============================================================
  // AUTH REPOSITORY
  // ============================================================

  sl.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDatasource>(),
    ),
  );

  // ============================================================
  // AUTH BLOC
  // ============================================================

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl<AuthRepositoryImpl>(),
    ),
  );
}