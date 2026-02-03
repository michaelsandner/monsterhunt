import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:monster/domain/repositories/monster_repository.dart';
import 'package:monster/domain/usecases/reset_monster_usecase.dart';

class MockMonsterRepository extends Mock implements MonsterRepository {}

void main() {
  late ResetMonsterUseCase useCase;
  late MockMonsterRepository mockRepository;

  setUp(() {
    mockRepository = MockMonsterRepository();
    useCase = ResetMonsterUseCase(mockRepository);
  });

  const tMonster = Monster(
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

  const tResetMonster = Monster(
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

  setUpAll(() {
    registerFallbackValue(tMonster);
  });

  group('ResetMonsterUseCase', () {
    group('Given a monster with partially completed properties', () {
      group('When resetting the monster successfully', () {
        setUp(() {
          when(
            () => mockRepository.resetMonster(any()),
          ).thenAnswer((_) async => const Right(tResetMonster));
        });

        test('Then it should return reset monster from repository', () async {
          final result = await useCase(tMonster);

          expect(result, const Right(tResetMonster));
          verify(() => mockRepository.resetMonster(tMonster)).called(1);
          verifyNoMoreInteractions(mockRepository);
        });

        test('Then all properties should be reset to max value', () async {
          final result = await useCase(tMonster);

          result.fold((final failure) => fail('Expected Right but got Left'), (
            final monster,
          ) {
            for (final property in monster.properties) {
              expect(
                property.currentValue,
                property.maxValue,
                reason: '${property.name} should be reset to max value',
              );
            }
          });
        });

        test('Then it should pass correct monster to repository', () async {
          await useCase(tMonster);

          verify(() => mockRepository.resetMonster(tMonster)).called(1);
        });
      });

      group('When repository fails with network error', () {
        const tFailure = NetworkFailure(message: 'No internet connection');

        setUp(() {
          when(
            () => mockRepository.resetMonster(any()),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return NetworkFailure', () async {
          final result = await useCase(tMonster);

          expect(result, const Left(tFailure));
          verify(() => mockRepository.resetMonster(tMonster)).called(1);
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
            () => mockRepository.resetMonster(any()),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return ServerFailure', () async {
          final result = await useCase(tMonster);

          expect(result, const Left(tFailure));
          verify(() => mockRepository.resetMonster(tMonster)).called(1);
          verifyNoMoreInteractions(mockRepository);
        });
      });
    });
  });
}
