import 'package:dartz/dartz.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';

abstract class MonsterRepository {
  Future<Either<Failure, Monster>> getInitialMonster();
  Future<Either<Failure, Monster>> reduceProperty(
    final Monster monster,
    final String propertyName,
    final double amount,
  );
  Future<Either<Failure, Monster>> resetMonster(final Monster monster);
}
