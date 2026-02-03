import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
/// Failures represent errors that have been handled and transformed
/// into a format suitable for the domain/presentation layer
abstract class Failure extends Equatable {
  const Failure({this.message, this.statusCode});

  final String? message;
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Failure when server returns an error response (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.statusCode,
  });

  @override
  String toString() =>
      'ServerFailure: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Failure when there's no internet connection or request times out
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network connection failed'});

  @override
  String toString() => 'NetworkFailure: $message';
}

/// Failure when cached data is not available
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'No cached data available'});

  @override
  String toString() => 'CacheFailure: $message';
}

/// Failure when parsing/deserializing data fails
class DataParsingFailure extends Failure {
  const DataParsingFailure({super.message = 'Failed to parse data'});

  @override
  String toString() => 'DataParsingFailure: $message';
}

/// Failure when an unexpected error occurs
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred'});

  @override
  String toString() => 'UnexpectedFailure: $message';
}
