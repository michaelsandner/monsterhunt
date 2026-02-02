import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class ResetMonsterUseCase {
  ResetMonsterUseCase(this.repository);
  final MonsterRepository repository;

  Monster call(final Monster monster) => repository.resetMonster(monster);
}
