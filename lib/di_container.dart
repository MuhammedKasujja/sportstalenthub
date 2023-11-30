import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sth/core/core.dart';
import 'package:sth/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final sl = GetIt.instance; // sl -> service_locator

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient(dio: sl()));
  sl.registerLazySingleton(() => PlayerAttachmentsRepo(apiClient: sl()));
  // Blocs
  sl.registerFactory(() => PlayerAttachmentsBloc(playerAttachmentsRepo: sl()));

  // External
  sl.registerLazySingleton(() => Dio());
}

List<BlocProvider> get blocs => [
      BlocProvider<PlayerAttachmentsBloc>(
          create: (context) => sl<PlayerAttachmentsBloc>()),
    ];
