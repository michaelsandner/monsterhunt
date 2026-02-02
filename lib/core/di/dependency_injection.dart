import 'package:monster/data/repositories/monster_repository_impl.dart';
import 'package:monster/domain/repositories/monster_repository.dart';
import 'package:monster/domain/usecases/get_initial_monster_usecase.dart';
import 'package:monster/domain/usecases/reduce_property_usecase.dart';
import 'package:monster/domain/usecases/reset_monster_usecase.dart';
import 'package:monster/presentation/cubit/monster_cubit.dart';

// Singleton pattern for dependency injection
// ignore: avoid_classes_with_only_static_members
class DependencyInjection {
  static MonsterRepository? _repository;
  static GetInitialMonsterUseCase? _getInitialMonster;
  static ReducePropertyUseCase? _reduceProperty;
  static ResetMonsterUseCase? _resetMonster;
  static MonsterRepository get repository {
    _repository ??= MonsterRepositoryImpl();
    return _repository!;
  }

  static GetInitialMonsterUseCase get getInitialMonster {
    _getInitialMonster ??= GetInitialMonsterUseCase(repository);
    return _getInitialMonster!;
  }

  static ReducePropertyUseCase get reduceProperty {
    _reduceProperty ??= ReducePropertyUseCase(repository);
    return _reduceProperty!;
  }

  static ResetMonsterUseCase get resetMonster {
    _resetMonster ??= ResetMonsterUseCase(repository);
    return _resetMonster!;
  }

  static MonsterCubit createMonsterCubit() => MonsterCubit(
    getInitialMonster: getInitialMonster,
    reduceProperty: reduceProperty,
    resetMonster: resetMonster,
  );

  static void reset() {
    _repository = null;
    _getInitialMonster = null;
    _reduceProperty = null;
    _resetMonster = null;
  }
}
