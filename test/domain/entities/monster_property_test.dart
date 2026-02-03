import 'package:flutter_test/flutter_test.dart';
import 'package:monster/domain/entities/monster_property.dart';

void main() {
  group('MonsterProperty Entity', () {
    const tProperty = MonsterProperty(
      name: 'Laufen',
      unit: 'km',
      currentValue: 25.5,
      maxValue: 50,
    );

    test('should be a valid MonsterProperty entity', () {
      expect(tProperty.name, 'Laufen');
      expect(tProperty.unit, 'km');
      expect(tProperty.currentValue, 25.5);
      expect(tProperty.maxValue, 50.0);
    });

    test('isCompleted should return false when currentValue > 0', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 25,
        maxValue: 50,
      );

      expect(property.isCompleted, false);
    });

    test('isCompleted should return true when currentValue is 0', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 0,
        maxValue: 50,
      );

      expect(property.isCompleted, true);
    });

    test('isCompleted should return true when currentValue is negative', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: -5,
        maxValue: 50,
      );

      expect(property.isCompleted, true);
    });

    test('percentage should return correct percentage', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 25,
        maxValue: 50,
      );

      expect(property.percentage, 50.0);
    });

    test(
      'percentage should return 100.0 when currentValue equals maxValue',
      () {
        const property = MonsterProperty(
          name: 'Laufen',
          unit: 'km',
          currentValue: 50,
          maxValue: 50,
        );

        expect(property.percentage, 100.0);
      },
    );

    test('percentage should return 0.0 when currentValue is 0', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 0,
        maxValue: 50,
      );

      expect(property.percentage, 0.0);
    });

    test('percentage should handle division by zero (maxValue is 0)', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 0,
        maxValue: 0,
      );

      // Should return 0 or handle gracefully (NaN)
      expect(property.percentage.isNaN || property.percentage == 0, true);
    });

    test('copyWith should create a new instance with updated values', () {
      final updatedProperty = tProperty.copyWith(
        currentValue: 10,
        name: 'Schwimmen',
      );

      expect(updatedProperty.name, 'Schwimmen');
      expect(updatedProperty.currentValue, 10.0);
      expect(updatedProperty.unit, 'km');
      expect(updatedProperty.maxValue, 50.0);
    });

    test(
      'copyWith should keep original values when no parameters provided',
      () {
        final copiedProperty = tProperty.copyWith();

        expect(copiedProperty.name, tProperty.name);
        expect(copiedProperty.unit, tProperty.unit);
        expect(copiedProperty.currentValue, tProperty.currentValue);
        expect(copiedProperty.maxValue, tProperty.maxValue);
      },
    );

    test('two properties with same values should be equal (Equatable)', () {
      const property1 = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 25,
        maxValue: 50,
      );

      const property2 = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 25,
        maxValue: 50,
      );

      expect(property1, property2);
    });

    test('two properties with different values should not be equal', () {
      const property1 = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 25,
        maxValue: 50,
      );

      const property2 = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 30,
        maxValue: 50,
      );

      expect(property1, isNot(property2));
    });

    test('remainingPercentage should calculate correctly', () {
      const property = MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 25,
        maxValue: 50,
      );

      // For 25/50 = 50%, remaining should be 50%
      expect(property.percentage, 50.0);
      expect(100 - property.percentage, 50.0);
    });
  });
}
