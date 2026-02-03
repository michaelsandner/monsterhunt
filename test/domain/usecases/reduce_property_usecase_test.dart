import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:monster/domain/repositories/monster_repository.dart';
import 'package:monster/domain/usecases/reduce_property_usecase.dart';

class MockMonsterRepository extends Mock implements MonsterRepository {}

void main() {
  late ReducePropertyUseCase useCase;
  late MockMonsterRepository mockRepository;

  setUp(() {
    mockRepository = MockMonsterRepository();
    useCase = ReducePropertyUseCase(mockRepository);
  });

  const tMonster = Monster(
    name: 'Test Monster',
    description: 'A test monster',
    icon: Icons.water_drop,
    properties: [
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
    ],
  );

  const tUpdatedMonster = Monster(
    name: 'Test Monster',
    description: 'A test monster',
    icon: Icons.water_drop,
    properties: [
      MonsterProperty(
        name: 'Laufen',
        unit: 'km',
        currentValue: 45,
        maxValue: 50,
      ),
      MonsterProperty(
        name: 'Schwimmen',
        unit: 'm',
        currentValue: 1000,
        maxValue: 1000,
      ),
    ],
  );

  const tPropertyName = 'Laufen';
  const tAmount = 5.0;

  setUpAll(() {
    registerFallbackValue(tMonster);
  });

  group('ReducePropertyUseCase', () {
    test('should reduce property value through repository', () async {
      // arrange
      when(
        () => mockRepository.reduceProperty(any(), any(), any()),
      ).thenAnswer((_) async => const Right(tUpdatedMonster));

      // act
      final result = await useCase(tMonster, tPropertyName, tAmount);

      // assert
      expect(result, const Right(tUpdatedMonster));
      verify(
        () => mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return updated monster with reduced property value', () async {
      // arrange
      when(
        () => mockRepository.reduceProperty(any(), any(), any()),
      ).thenAnswer((_) async => const Right(tUpdatedMonster));

      // act
      final result = await useCase(tMonster, tPropertyName, tAmount);

      // assert
      result.fold((final failure) => fail('Expected Right but got Left'), (
        final monster,
      ) {
        final updatedProperty = monster.properties.firstWhere(
          (final p) => p.name == tPropertyName,
        );
        expect(updatedProperty.currentValue, 45.0);
        expect(updatedProperty.maxValue, 50.0);
      });
    });

    test('should return NetworkFailure when repository fails', () async {
      // arrange
      const tFailure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockRepository.reduceProperty(any(), any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tMonster, tPropertyName, tAmount);

      // assert
      expect(result, const Left(tFailure));
      verify(
        () => mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return ServerFailure when repository fails with server error',
      () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Server error',
          statusCode: 500,
        );
        when(
          () => mockRepository.reduceProperty(any(), any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tMonster, tPropertyName, tAmount);

        // assert
        expect(result, const Left(tFailure));
        verify(
          () => mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should pass correct parameters to repository', () async {
      // arrange
      when(
        () => mockRepository.reduceProperty(any(), any(), any()),
      ).thenAnswer((_) async => const Right(tUpdatedMonster));

      // act
      await useCase(tMonster, tPropertyName, tAmount);

      // assert
      verify(
        () => mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
      ).called(1);
    });
  });
}
