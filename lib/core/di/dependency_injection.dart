import 'package:get_it/get_it.dart';
import 'package:monster/data/datasources/api_service_interface.dart';
import 'package:monster/data/datasources/local_data_source.dart';
import 'package:monster/data/datasources/mock_api_service.dart';
// import 'package:monster/data/datasources/api_service.dart'; // Uncomment for real backend
import 'package:monster/data/repositories/monster_repository_impl.dart';
import 'package:monster/domain/repositories/monster_repository.dart';
import 'package:monster/domain/usecases/get_initial_monster_usecase.dart';
import 'package:monster/domain/usecases/reduce_property_usecase.dart';
import 'package:monster/domain/usecases/reset_monster_usecase.dart';
import 'package:monster/presentation/cubit/monster_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    // Local Data Source (Cache)
    ..registerLazySingleton(() => LocalDataSource(getIt<SharedPreferences>()))
    // Data Sources
    // Wähle zwischen Mock und echtem Backend:
    // Option 1: Mock API (für Entwicklung ohne Backend)
    ..registerLazySingleton<ApiServiceInterface>(MockApiService.new)
    // Option 2: Echtes Backend (uncomment und BaseURL anpassen)
    // getIt.registerLazySingleton<ApiServiceInterface>(
    //   () => ApiService(baseUrl: 'https://your-backend-url.com'),
    // );
    // Repository
    ..registerLazySingleton<MonsterRepository>(
      () => MonsterRepositoryImpl(getIt(), getIt()),
    )
    // UseCases
    ..registerLazySingleton(() => GetInitialMonsterUseCase(getIt()))
    ..registerLazySingleton(() => ReducePropertyUseCase(getIt()))
    ..registerLazySingleton(() => ResetMonsterUseCase(getIt()))
    // Cubit Factory
    ..registerFactory(
      () => MonsterCubit(
        getInitialMonster: getIt(),
        reduceProperty: getIt(),
        resetMonster: getIt(),
      ),
    );
}
