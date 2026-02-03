import 'package:get_it/get_it.dart';
import 'package:monster/data/repositories/monster_repository_impl.dart';
import 'package:monster/domain/repositories/monster_repository.dart';
import 'package:monster/domain/usecases/get_initial_monster_usecase.dart';
import 'package:monster/domain/usecases/reduce_property_usecase.dart';
import 'package:monster/domain/usecases/reset_monster_usecase.dart';
import 'package:monster/presentation/cubit/monster_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Repository
  getIt
    ..registerLazySingleton<MonsterRepository>(MonsterRepositoryImpl.new)
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
