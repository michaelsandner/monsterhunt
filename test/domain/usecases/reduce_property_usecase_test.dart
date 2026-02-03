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
    group('Given a monster with properties', () {
      group('When reducing a property value successfully', () {
        setUp(() {
          when(
            () => mockRepository.reduceProperty(any(), any(), any()),
          ).thenAnswer((_) async => const Right(tUpdatedMonster));
        });

        test('Then it should return updated monster from repository', () async {
          final result = await useCase(tMonster, tPropertyName, tAmount);

          expect(result, const Right(tUpdatedMonster));
          verify(
            () =>
                mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
          ).called(1);
          verifyNoMoreInteractions(mockRepository);
        });

        test('Then the property should have reduced value', () async {
          final result = await useCase(tMonster, tPropertyName, tAmount);

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

        test('Then it should pass correct parameters to repository', () async {
          await useCase(tMonster, tPropertyName, tAmount);

          verify(
            () =>
                mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
          ).called(1);
        });
      });

      group('When repository fails with network error', () {
        const tFailure = NetworkFailure(message: 'No internet connection');

        setUp(() {
          when(
            () => mockRepository.reduceProperty(any(), any(), any()),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return NetworkFailure', () async {
          final result = await useCase(tMonster, tPropertyName, tAmount);

          expect(result, const Left(tFailure));
          verify(
            () =>
                mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
          ).called(1);
          verifyNoMoreInteractions(mockRepository);
        });
      });

      group('When repository fails with server error', () {
        const tFailure = ServerFailure(
          message: 'Server error',
          statusCode: 500,
        );

        setUp(() {
          when(
            () => mockRepository.reduceProperty(any(), any(), any()),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return ServerFailure', () async {
          final result = await useCase(tMonster, tPropertyName, tAmount);

          expect(result, const Left(tFailure));
          verify(
            () =>
                mockRepository.reduceProperty(tMonster, tPropertyName, tAmount),
          ).called(1);
          verifyNoMoreInteractions(mockRepository);
        });
      });
    });
  });
}
