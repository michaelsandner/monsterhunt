import 'package:flutter/material.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class MonsterRepositoryImpl implements MonsterRepository {
  @override
  Monster getInitialMonster() => const Monster(
    name: 'Aqua-Drache',
    description:
        'Ein mächtiges Wasser-Monster, das nur durch sportliche Aktivitäten besiegt werden kann!',
    icon: Icons.water_drop,
    properties: [
      MonsterProperty(
        name: 'Schwimmen',
        unit: 'm',
        currentValue: 1000,
        maxValue: 1000,
      ),
      MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 50,
        maxValue: 50,
      ),
      MonsterProperty(
        name: 'Radfahren',
        unit: 'km',
        currentValue: 100,
        maxValue: 100,
      ),
      MonsterProperty(
        name: 'Krafttraining',
        unit: 'min',
        currentValue: 300,
        maxValue: 300,
      ),
    ],
  );

  @override
  Monster reduceProperty(
    final Monster monster,
    final String propertyName,
    final double amount,
  ) {
    final updatedProperties = monster.properties.map((final property) {
      if (property.name == propertyName) {
        final newValue = (property.currentValue - amount).clamp(
          0.0,
          property.maxValue,
        );
        return property.copyWith(currentValue: newValue);
      }
      return property;
    }).toList();

    return monster.copyWith(properties: updatedProperties);
  }

  @override
  Monster resetMonster(final Monster monster) {
    final resetProperties = monster.properties
        .map(
          (final property) =>
              property.copyWith(currentValue: property.maxValue),
        )
        .toList();

    return monster.copyWith(properties: resetProperties);
  }
}
