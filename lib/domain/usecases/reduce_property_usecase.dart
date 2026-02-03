import 'package:dartz/dartz.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class ReducePropertyUseCase {
  ReducePropertyUseCase(this.repository);
  final MonsterRepository repository;

  Future<Either<Failure, Monster>> call(
    final Monster monster,
    final String propertyName,
    final double amount,
  ) => repository.reduceProperty(monster, propertyName, amount);
}
