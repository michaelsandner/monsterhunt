import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:monster/core/error/exceptions.dart';
import 'package:monster/core/error/failures.dart';
import 'package:monster/data/datasources/api_service_interface.dart';
import 'package:monster/data/datasources/local_data_source.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/repositories/monster_repository.dart';

class MonsterRepositoryImpl implements MonsterRepository {
  MonsterRepositoryImpl(this._apiService, this._localDataSource);

  final ApiServiceInterface _apiService;
  final LocalDataSource _localDataSource;

  @override
  Monster getInitialMonster() => const Monster(
    name: 'Aqua-Drache',
    description:
        'Ein mächtiges Wasser-Monster, das nur durch sportliche Aktivitäten besiegt werden kann!',
    icon: Icons.water_drop,
    properties: [],
  );

  @override
  Future<Either<Failure, Monster>> reduceProperty(
    final Monster monster,
    final String propertyName,
    final double amount,
  ) async {
    try {
      // Try to update via API
      final updatedProperties = await _apiService.reduceProperty(
        propertyName: propertyName,
        amount: amount,
      );

      // Cache successful response
      await _localDataSource.cacheProperties(updatedProperties);

      return Right(monster.copyWith(properties: updatedProperties));
    } on NetworkException catch (e) {
      // Network error - try cache first
      if (_localDataSource.hasCachedData()) {
        try {
          final cachedProperties = await _localDataSource.getCachedProperties();
          return Right(monster.copyWith(properties: cachedProperties));
        } on CacheException {
          return const Left(CacheFailure(message: 'Cache data corrupted'));
        }
      }
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      // Server error - try cache first
      if (_localDataSource.hasCachedData()) {
        try {
          final cachedProperties = await _localDataSource.getCachedProperties();
          return Right(monster.copyWith(properties: cachedProperties));
        } on CacheException {
          return const Left(CacheFailure(message: 'Cache data corrupted'));
        }
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Monster>> resetMonster(final Monster monster) async {
    try {
      // Try to reset via API
      final resetProperties = await _apiService.resetProperties();

      // Cache successful response
      await _localDataSource.cacheProperties(resetProperties);

      return Right(monster.copyWith(properties: resetProperties));
    } on NetworkException catch (e) {
      // Network error - try cache first
      if (_localDataSource.hasCachedData()) {
        try {
          final cachedProperties = await _localDataSource.getCachedProperties();
          return Right(monster.copyWith(properties: cachedProperties));
        } on CacheException {
          return const Left(CacheFailure(message: 'Cache data corrupted'));
        }
      }
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      // Server error - try cache first
      if (_localDataSource.hasCachedData()) {
        try {
          final cachedProperties = await _localDataSource.getCachedProperties();
          return Right(monster.copyWith(properties: cachedProperties));
        } on CacheException {
          return const Left(CacheFailure(message: 'Cache data corrupted'));
        }
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

  /// Load current properties from API
  @override
  Future<Either<Failure, Monster>> loadMonsterWithProperties(
    final Monster monster,
  ) async {
    try {
      // Try to load from API
      final properties = await _apiService.getCurrentProperties();

      // Cache successful response
      await _localDataSource.cacheProperties(properties);

      return Right(monster.copyWith(properties: properties));
    } on NetworkException catch (e) {
      // Network error - try cache first
      if (_localDataSource.hasCachedData()) {
        try {
          final cachedProperties = await _localDataSource.getCachedProperties();
          return Right(monster.copyWith(properties: cachedProperties));
        } on CacheException {
          return const Left(CacheFailure(message: 'Cache data corrupted'));
        }
      }
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      // Server error - try cache first
      if (_localDataSource.hasCachedData()) {
        try {
          final cachedProperties = await _localDataSource.getCachedProperties();
          return Right(monster.copyWith(properties: cachedProperties));
        } on CacheException {
          return const Left(CacheFailure(message: 'Cache data corrupted'));
        }
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
