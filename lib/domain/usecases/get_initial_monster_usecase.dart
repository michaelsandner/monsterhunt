import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class GetInitialMonsterUseCase {
  GetInitialMonsterUseCase(this.repository);
  final MonsterRepository repository;

  Monster call() => repository.getInitialMonster();
}
