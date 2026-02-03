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
    test('should reset monster through repository', () async {
      // arrange
      when(
        () => mockRepository.resetMonster(any()),
      ).thenAnswer((_) async => const Right(tResetMonster));

      // act
      final result = await useCase(tMonster);

      // assert
      expect(result, const Right(tResetMonster));
      verify(() => mockRepository.resetMonster(tMonster)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return monster with all properties reset to max value',
      () async {
        // arrange
        when(
          () => mockRepository.resetMonster(any()),
        ).thenAnswer((_) async => const Right(tResetMonster));

        // act
        final result = await useCase(tMonster);

        // assert
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
      },
    );

    test('should return NetworkFailure when repository fails', () async {
      // arrange
      const tFailure = NetworkFailure(message: 'No internet connection');
      when(
        () => mockRepository.resetMonster(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tMonster);

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.resetMonster(tMonster)).called(1);
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
          () => mockRepository.resetMonster(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tMonster);

        // assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.resetMonster(tMonster)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('should pass correct monster to repository', () async {
      // arrange
      when(
        () => mockRepository.resetMonster(any()),
      ).thenAnswer((_) async => const Right(tResetMonster));

      // act
      await useCase(tMonster);

      // assert
      verify(() => mockRepository.resetMonster(tMonster)).called(1);
    });
  });
}
