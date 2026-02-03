import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';

void main() {
  group('Monster Entity', () {
    const tProperties = [
      MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 50,
        maxValue: 50,
      ),
      MonsterProperty(
        name: 'Schwimmen',
        unit: 'm',
        currentValue: 1000,
        maxValue: 1000,
      ),
    ];

    const tMonster = Monster(
      name: 'Test Monster',
      description: 'A test monster',
      icon: Icons.water_drop,
      properties: tProperties,
    );

    test('should be a valid Monster entity', () {
      expect(tMonster.name, 'Test Monster');
      expect(tMonster.description, 'A test monster');
      expect(tMonster.icon, Icons.water_drop);
      expect(tMonster.properties, tProperties);
    });

    test(
      'isDefeated should return false when not all properties are completed',
      () {
        const monster = Monster(
          name: 'Test Monster',
          description: 'A test monster',
          icon: Icons.water_drop,
          properties: [
            MonsterProperty(
              name: 'Laufen',
              unit: 'km',
              currentValue: 25,
              maxValue: 50,
            ),
            MonsterProperty(
              name: 'Schwimmen',
              unit: 'm',
              currentValue: 500,
              maxValue: 1000,
            ),
          ],
        );

        expect(monster.isDefeated, false);
      },
    );

    test('isDefeated should return true when all properties are completed', () {
      const monster = Monster(
        name: 'Test Monster',
        description: 'A test monster',
        icon: Icons.water_drop,
        properties: [
          MonsterProperty(
            name: 'Laufen',
            unit: 'km',
            currentValue: 0,
            maxValue: 50,
          ),
          MonsterProperty(
            name: 'Schwimmen',
            unit: 'm',
            currentValue: 0,
            maxValue: 1000,
          ),
        ],
      );

      expect(monster.isDefeated, true);
    });

    test('isDefeated should return true for empty properties list', () {
      const monster = Monster(
        name: 'Test Monster',
        description: 'A test monster',
        icon: Icons.water_drop,
        properties: [],
      );

      expect(monster.isDefeated, true);
    });

    test('copyWith should create a new instance with updated values', () {
      const newProperties = [
        MonsterProperty(
          name: 'Laufen',
          unit: 'km',
          currentValue: 40,
          maxValue: 50,
        ),
      ];

      final updatedMonster = tMonster.copyWith(
        name: 'Updated Monster',
        properties: newProperties,
      );

      expect(updatedMonster.name, 'Updated Monster');
      expect(updatedMonster.description, 'A test monster');
      expect(updatedMonster.properties, newProperties);
    });

    test(
      'copyWith should keep original values when no parameters provided',
      () {
        final copiedMonster = tMonster.copyWith();

        expect(copiedMonster.name, tMonster.name);
        expect(copiedMonster.description, tMonster.description);
        expect(copiedMonster.icon, tMonster.icon);
        expect(copiedMonster.properties, tMonster.properties);
      },
    );

    test('two monsters with same values should be equal (Equatable)', () {
      const monster1 = Monster(
        name: 'Test',
        description: 'Desc',
        icon: Icons.water_drop,
        properties: [],
      );

      const monster2 = Monster(
        name: 'Test',
        description: 'Desc',
        icon: Icons.water_drop,
        properties: [],
      );

      expect(monster1, monster2);
    });

    test('two monsters with different values should not be equal', () {
      const monster1 = Monster(
        name: 'Test1',
        description: 'Desc',
        icon: Icons.water_drop,
        properties: [],
      );

      const monster2 = Monster(
        name: 'Test2',
        description: 'Desc',
        icon: Icons.water_drop,
        properties: [],
      );

      expect(monster1, isNot(monster2));
    });
  });
}
