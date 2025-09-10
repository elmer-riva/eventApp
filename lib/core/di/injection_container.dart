import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/database/database_helper.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/core/services/auth_manager.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/domain/repositories/auth_repository.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/auth/presentation/bloc/login_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/datasources/event_local_data_source.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/datasources/event_remote_data_source.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/data/repositories/event_repository_impl.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/domain/repositories/event_repository.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/event_detail_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/event_list_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/favorites_bloc.dart';
import 'package:upc_flutter_202510_1acc0238_eb_u202220829/features/events/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => LoginBloc(authRepository: sl()));
  sl.registerFactory(() => HomeBloc());
  sl.registerFactory(() => EventListBloc(eventRepository: sl()));
  sl.registerFactory(() => FavoritesBloc(eventRepository: sl()));
  sl.registerFactory(() => EventDetailBloc(eventRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), authManager: sl()));
  sl.registerLazySingleton<EventRepository>(() => EventRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<EventRemoteDataSource>(() => EventRemoteDataSourceImpl(client: sl(), authManager: sl()));
  sl.registerLazySingleton<EventLocalDataSource>(() => EventLocalDataSourceImpl(dbHelper: sl()));

  // Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DatabaseHelper.instance);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AuthManager(sl()));
}