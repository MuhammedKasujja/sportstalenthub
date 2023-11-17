import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sth/core/core.dart';

final sl = GetIt.instance; // sl -> service_locator

Future<void> init() async {
  // Core
  // sl.registerLazySingleton(() => ApiService(apiClient: sl()));
  sl.registerLazySingleton(() => ApiClient(dio: sl()));
  // Blocs
  // sl.registerFactory(() => AuthBloc(authService: sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}
