import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monster/core/error/failures.dart';
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

  Future<void> loadMonster() async {
    emit(const MonsterLoading());
    final result = await getInitialMonster();
    result.fold(
      (final failure) =>
          emit(MonsterError(message: _mapFailureToMessage(failure))),
      (final monster) => emit(MonsterLoaded(monster: monster)),
    );
  }

  Future<void> reducePropertyValue(
    final String propertyName,
    final double amount,
  ) async {
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

    final result = await reduceProperty(currentMonster, propertyName, amount);

    result.fold(
      (final failure) =>
          emit(MonsterError(message: _mapFailureToMessage(failure))),
      (final updatedMonster) {
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
      },
    );
  }

  Future<void> resetMonsterState() async {
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

    final result = await resetMonster(currentMonster);
    result.fold(
      (final failure) =>
          emit(MonsterError(message: _mapFailureToMessage(failure))),
      (final resetMonsterEntity) =>
          emit(MonsterLoaded(monster: resetMonsterEntity)),
    );
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

  /// Maps failures to user-friendly error messages
  String _mapFailureToMessage(final Failure failure) {
    switch (failure.runtimeType) {
      case const (NetworkFailure):
        return 'Netzwerkfehler: Bitte überprüfen Sie Ihre Internetverbindung.';
      case const (ServerFailure):
        final serverFailure = failure as ServerFailure;
        if (serverFailure.statusCode != null) {
          return 'Server-Fehler ${serverFailure.statusCode}: ${serverFailure.message}';
        }
        return 'Server-Fehler: ${serverFailure.message}';
      case const (CacheFailure):
        return 'Keine gespeicherten Daten verfügbar. Bitte Internetverbindung prüfen.';
      case const (DataParsingFailure):
        return 'Datenverarbeitungsfehler: Die empfangenen Daten sind fehlerhaft.';
      default:
        return failure.message ?? 'Ein unbekannter Fehler ist aufgetreten.';
    }
  }
}
