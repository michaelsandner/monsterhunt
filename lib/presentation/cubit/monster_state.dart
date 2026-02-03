import 'package:equatable/equatable.dart';
import 'package:monster/domain/entities/monster.dart';

abstract class MonsterState extends Equatable {
  const MonsterState();

  @override
  List<Object?> get props => [];
}

class MonsterInitial extends MonsterState {
  const MonsterInitial();
}

class MonsterLoading extends MonsterState {
  const MonsterLoading();
}

class MonsterLoaded extends MonsterState {
  const MonsterLoaded({required this.monster, this.message});
  final Monster monster;
  final String? message;

  @override
  List<Object?> get props => [monster, message];
}

class MonsterPropertyCompleted extends MonsterState {
  const MonsterPropertyCompleted({
    required this.monster,
    required this.propertyName,
    this.message,
  });
  final Monster monster;
  final String propertyName;
  final String? message;

  @override
  List<Object?> get props => [monster, propertyName, message];
}

class MonsterDefeated extends MonsterState {
  const MonsterDefeated({required this.monster, this.message});
  final Monster monster;
  final String? message;

  @override
  List<Object?> get props => [monster, message];
}

class MonsterError extends MonsterState {
  const MonsterError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
