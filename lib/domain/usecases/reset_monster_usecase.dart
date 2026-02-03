import 'package:dartz/dartz.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class ResetMonsterUseCase {
  ResetMonsterUseCase(this.repository);
  final MonsterRepository repository;

  Future<Either<Failure, Monster>> call(final Monster monster) =>
      repository.resetMonster(monster);
}
