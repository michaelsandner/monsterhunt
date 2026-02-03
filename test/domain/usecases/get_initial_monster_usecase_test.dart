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
    group('Given the use case is initialized', () {
      group('When calling the use case successfully', () {
        setUp(() {
          when(
            () => mockRepository.getInitialMonster(),
          ).thenAnswer((_) async => const Right(tMonster));
        });

        test('Then it should return initial monster from repository', () async {
          final result = await useCase();

          expect(result, const Right(tMonster));
          verify(() => mockRepository.getInitialMonster()).called(1);
          verifyNoMoreInteractions(mockRepository);
        });
      });

      group('When repository fails with network error', () {
        const tFailure = NetworkFailure(message: 'No internet connection');

        setUp(() {
          when(
            () => mockRepository.getInitialMonster(),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return NetworkFailure', () async {
          final result = await useCase();

          expect(result, const Left(tFailure));
          verify(() => mockRepository.getInitialMonster()).called(1);
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
            () => mockRepository.getInitialMonster(),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return ServerFailure', () async {
          final result = await useCase();

          expect(result, const Left(tFailure));
          verify(() => mockRepository.getInitialMonster()).called(1);
          verifyNoMoreInteractions(mockRepository);
        });
      });

      group('When repository fails with cache error', () {
        const tFailure = CacheFailure(message: 'Cache corrupted');

        setUp(() {
          when(
            () => mockRepository.getInitialMonster(),
          ).thenAnswer((_) async => const Left(tFailure));
        });

        test('Then it should return CacheFailure', () async {
          final result = await useCase();

          expect(result, const Left(tFailure));
          verify(() => mockRepository.getInitialMonster()).called(1);
          verifyNoMoreInteractions(mockRepository);
        });
      });
    });
  });
}
