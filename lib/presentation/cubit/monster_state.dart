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
  });
  final Monster monster;
  final String propertyName;

  @override
  List<Object?> get props => [monster, propertyName];
}

class MonsterDefeated extends MonsterState {
  const MonsterDefeated({required this.monster});
  final Monster monster;

  @override
  List<Object?> get props => [monster];
}
