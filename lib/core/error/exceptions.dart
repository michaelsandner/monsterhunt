/// Base class for all exceptions in the data layer
/// Exceptions are thrown by data sources and caught by repositories
/// They are then transformed into Failures for the domain layer
abstract class AppException implements Exception {
  AppException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  String toString() => message ?? 'AppException occurred';
}

/// Exception when server returns an error response
class ServerException extends AppException {
  ServerException({super.message = 'Server error occurred', super.statusCode});

  @override
  String toString() =>
      'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception when there's no internet connection or request times out
class NetworkException extends AppException {
  NetworkException({super.message = 'Network connection failed'});

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception when cached data operations fail
class CacheException extends AppException {
  CacheException({super.message = 'Cache operation failed'});

  @override
  String toString() => 'CacheException: $message';
}

/// Exception when parsing/deserializing data fails
class DataParsingException extends AppException {
  DataParsingException({super.message = 'Failed to parse data'});

  @override
  String toString() => 'DataParsingException: $message';
}
