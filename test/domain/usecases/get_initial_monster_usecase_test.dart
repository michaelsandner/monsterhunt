import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:monster/domain/repositories/monster_repository.dart';
import 'package:monster/domain/usecases/get_initial_monster_usecase.dart';

class MockMonsterRepository extends Mock implements MonsterRepository {}

void main() {
  late GetInitialMonsterUseCase useCase;
  late MockMonsterRepository mockRepository;

  setUp(() {
    mockRepository = MockMonsterRepository();
    useCase = GetInitialMonsterUseCase(mockRepository);
  });

  const tMonster = Monster(
    name: 'Test Monster',
    description: 'A test monster',
    icon: Icons.water_drop,
    properties: [
      MonsterProperty(
        name: 'Test Property',
        unit: 'km',
        currentValue: 100,
        maxValue: 100,
      ),
    ],
  );

  group('GetInitialMonsterUseCase', () {
    test('should get initial monster from repository', () async {
      // arrange
      when(
        () => mockRepository.getInitialMonster(),
      ).thenAnswer((_) async => const Right(tMonster));

      // act
      final result = await useCase();

      // assert
      expect(result, const Right(tMonster));
      verify(() => mockRepository.getInitialMonster()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return NetworkFailure when repository fails with network error',
      () async {
        // arrange
        const tFailure = NetworkFailure(message: 'No internet connection');
        when(
          () => mockRepository.getInitialMonster(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase();

        // assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.getInitialMonster()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return ServerFailure when repository fails with server error',
      () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Server error',
          statusCode: 500,
        );
        when(
          () => mockRepository.getInitialMonster(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase();

        // assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.getInitialMonster()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return CacheFailure when repository fails with cache error',
      () async {
        // arrange
        const tFailure = CacheFailure(message: 'Cache corrupted');
        when(
          () => mockRepository.getInitialMonster(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase();

        // assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.getInitialMonster()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
