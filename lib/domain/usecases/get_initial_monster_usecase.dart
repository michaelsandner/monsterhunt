import 'package:dartz/dartz.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class GetInitialMonsterUseCase {
  GetInitialMonsterUseCase(this.repository);
  final MonsterRepository repository;

  Future<Either<Failure, Monster>> call() async =>
      repository.getInitialMonster();
}
