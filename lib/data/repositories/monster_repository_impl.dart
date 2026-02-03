import 'package:dartz/dartz.dart';
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

  /// Loads monster from cache if available
  /// Returns Right with cached monster or Left with CacheFailure
  Future<Either<Failure, Monster>> _loadFromCache() async {
    if (_localDataSource.hasCachedData()) {
      try {
        final cachedMonster = await _localDataSource.getCachedMonster();
        return Right(cachedMonster);
      } on CacheException {
        return const Left(CacheFailure(message: 'Cache data corrupted'));
      }
    }
    return const Left(CacheFailure(message: 'No cached data available'));
  }

  @override
  Future<Either<Failure, Monster>> getInitialMonster() async {
    try {
      // Load monster from API
      final monster = await _apiService.getCurrentMonster();

      // Cache successful response
      await _localDataSource.cacheMonster(monster);

      return Right(monster);
    } on NetworkException catch (e) {
      // Network error - try cache first
      final cacheResult = await _loadFromCache();
      return cacheResult.fold(
        (final failure) => Left(NetworkFailure(message: e.message)),
        Right.new,
      );
    } on ServerException catch (e) {
      // Server error - try cache
      final cacheResult = await _loadFromCache();
      return cacheResult.fold(
        (final failure) =>
            Left(ServerFailure(message: e.message, statusCode: e.statusCode)),
        Right.new,
      );
    } on DataParsingException catch (e) {
      return Left(DataParsingFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }

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

      final updatedMonster = monster.copyWith(properties: updatedProperties);

      // Cache successful response
      await _localDataSource.cacheMonster(updatedMonster);

      return Right(updatedMonster);
    } on NetworkException catch (e) {
      // Network error - return error without cache fallback
      // UI should show error while keeping current state
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      // Server error - return error without cache fallback
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

      final resetMonster = monster.copyWith(properties: resetProperties);

      // Cache successful response
      await _localDataSource.cacheMonster(resetMonster);

      return Right(resetMonster);
    } on NetworkException catch (e) {
      // Network error - return error without cache fallback
      // UI should show error while keeping current state
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      // Server error - return error without cache fallback
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
