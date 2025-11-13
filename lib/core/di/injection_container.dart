import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:gist/core/config/app_config.dart';
import 'package:gist/core/config/environment_manager.dart';
import 'package:gist/core/l10n/locale_cubit.dart';
import 'package:gist/core/network/dio_client.dart';
import 'package:gist/core/observers/app_bloc_observer.dart';
import 'package:gist/core/services/env_loader_service.dart';
import 'package:gist/core/theme/theme_cubit.dart';
import 'package:gist/features/demo/data/datasources/joke_api_service.dart';
import 'package:gist/features/demo/data/datasources/joke_remote_data_source.dart';
import 'package:gist/features/demo/data/datasources/joke_remote_data_source_impl.dart';
import 'package:gist/features/demo/data/repositories/joke_repository_impl.dart';
import 'package:gist/features/demo/domain/repositories/joke_repository.dart';
import 'package:gist/features/demo/domain/usecases/get_jokes_by_type.dart';
import 'package:gist/features/demo/domain/usecases/get_random_joke.dart';
import 'package:gist/features/demo/presentation/bloc/joke_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> initializeDependencies({Environment? initialEnvironment}) async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Services
  getIt.registerLazySingleton(() => EnvLoaderService());

  // Environment Manager
  final envManager = EnvironmentManager(sharedPreferences);

  // Si se provee un ambiente inicial, usarlo (para debug)
  if (initialEnvironment != null) {
    await envManager.setEnvironment(initialEnvironment);
  }

  getIt.registerSingleton<EnvironmentManager>(envManager);

  // Load initial environment configuration
  final envLoader = getIt<EnvLoaderService>();
  final envVars = await envLoader.loadEnvFile(
    envManager.currentEnvironment.envFilePath,
  );

  // Core
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnvMap(envVars));
  getIt.registerSingleton<Logger>(
    Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
      ),
    ),
  );
  getIt.registerSingleton<AppBlocObserver>(AppBlocObserver(getIt<Logger>()));

  // Network
  getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<AppConfig>()));
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);

  // Theme
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<SharedPreferences>()),
  );

  // Locale/Language
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(getIt<SharedPreferences>()),
  );

  // Demo Feature
  // Data sources
  getIt.registerLazySingleton<JokeApiService>(
    () => JokeApiService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<JokeRemoteDataSource>(
    () => JokeRemoteDataSourceImpl(getIt<JokeApiService>()),
  );

  // Repositories
  getIt.registerLazySingleton<JokeRepository>(
    () => JokeRepositoryImpl(getIt<JokeRemoteDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetRandomJoke>(
    () => GetRandomJoke(getIt<JokeRepository>()),
  );
  getIt.registerLazySingleton<GetJokesByType>(
    () => GetJokesByType(getIt<JokeRepository>()),
  );

  // BLoC
  getIt.registerFactory<JokeBloc>(
    () => JokeBloc(
      getRandomJoke: getIt<GetRandomJoke>(),
      getJokesByType: getIt<GetJokesByType>(),
    ),
  );
}

/// Reload dependencies when environment changes
Future<void> reloadDependenciesForEnvironment() async {
  final envLoader = getIt<EnvLoaderService>();
  final envManager = getIt<EnvironmentManager>();

  final envVars = await envLoader.loadEnvFile(
    envManager.currentEnvironment.envFilePath,
  );

  await getIt.unregister<AppConfig>();
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnvMap(envVars));

  if (getIt.isRegistered<DioClient>()) {
    await getIt.unregister<DioClient>();
    getIt.registerLazySingleton<DioClient>(() => DioClient(getIt<AppConfig>()));
  }

  if (getIt.isRegistered<Dio>()) {
    await getIt.unregister<Dio>();
    getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);
  }

  if (getIt.isRegistered<JokeApiService>()) {
    await getIt.unregister<JokeApiService>();
    getIt.registerLazySingleton<JokeApiService>(
      () => JokeApiService(getIt<Dio>()),
    );
  }
}
