import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/usecases/get_initial_monster_usecase.dart';
import 'package:monster/domain/usecases/reduce_property_usecase.dart';
import 'package:monster/domain/usecases/reset_monster_usecase.dart';
import 'package:monster/presentation/cubit/monster_state.dart';

class MonsterCubit extends Cubit<MonsterState> {
  MonsterCubit({
    required this.getInitialMonster,
    required this.reduceProperty,
    required this.resetMonster,
  }) : super(const MonsterInitial());
  final GetInitialMonsterUseCase getInitialMonster;
  final ReducePropertyUseCase reduceProperty;
  final ResetMonsterUseCase resetMonster;

  void loadMonster() {
    final monster = getInitialMonster();
    emit(MonsterLoaded(monster: monster));
  }

  void reducePropertyValue(final String propertyName, final double amount) {
    final currentState = state;
    if (currentState is! MonsterLoaded &&
        currentState is! MonsterPropertyCompleted &&
        currentState is! MonsterDefeated) {
      return;
    }

    final currentMonster = _getCurrentMonster(currentState);
    if (currentMonster == null) {
      return;
    }

    final updatedMonster = reduceProperty(currentMonster, propertyName, amount);

    // Prüfe ob die Eigenschaft abgeschlossen wurde
    final property = updatedMonster.properties.firstWhere(
      (final p) => p.name == propertyName,
    );

    if (property.isCompleted &&
        !_wasAlreadyCompleted(currentMonster, propertyName)) {
      emit(
        MonsterPropertyCompleted(
          monster: updatedMonster,
          propertyName: propertyName,
        ),
      );

      // Prüfe ob das Monster besiegt wurde
      if (updatedMonster.isDefeated) {
        emit(MonsterDefeated(monster: updatedMonster));
      }
    } else if (updatedMonster.isDefeated) {
      emit(MonsterDefeated(monster: updatedMonster));
    } else {
      emit(MonsterLoaded(monster: updatedMonster));
    }
  }

  void resetMonsterState() {
    final currentState = state;
    if (currentState is! MonsterLoaded &&
        currentState is! MonsterPropertyCompleted &&
        currentState is! MonsterDefeated) {
      return;
    }

    final currentMonster = _getCurrentMonster(currentState);
    if (currentMonster == null) {
      return;
    }

    final resetMonsterEntity = resetMonster(currentMonster);
    emit(MonsterLoaded(monster: resetMonsterEntity));
  }

  Monster? _getCurrentMonster(final MonsterState state) {
    if (state is MonsterLoaded) {
      return state.monster;
    }
    if (state is MonsterPropertyCompleted) {
      return state.monster;
    }
    if (state is MonsterDefeated) {
      return state.monster;
    }
    return null;
  }

  bool _wasAlreadyCompleted(final Monster monster, final String propertyName) {
    final property = monster.properties.firstWhere(
      (final p) => p.name == propertyName,
    );
    return property.isCompleted;
  }
}
