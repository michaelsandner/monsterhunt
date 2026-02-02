import 'package:monster/domain/entities/monster.dart';

abstract class MonsterRepository {
  Monster getInitialMonster();
  Monster reduceProperty(
    final Monster monster,
    final String propertyName,
    final double amount,
  );
  Monster resetMonster(final Monster monster);
}
