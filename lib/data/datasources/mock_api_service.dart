import 'package:monster/core/error/exceptions.dart';
import 'package:monster/data/datasources/api_service_interface.dart';
import 'package:monster/domain/entities/monster_property.dart';

/// Mock API Service that simulates REST endpoints
/// This will be replaced with actual HTTP calls to a backend later
class MockApiService implements ApiServiceInterface {
  // ============================================================
  // TESTING: Uncomment to simulate errors
  // ============================================================
  // static const bool _simulateError = true;
  // static const int _errorCode = 500;
  // static const String _errorMessage = 'Internal Server Error';

  static const bool _simulateError = true;
  static const int _errorCode = 500;
  static const String _errorMessage = 'Simulated server error';
  // ============================================================

  void _checkForTestError(final String operation) {
    if (_simulateError) {
      throw ServerException(message: _errorMessage, statusCode: _errorCode);
    }
  }

  // Simulated error mode for testing
  int? _nextErrorCode;
  String? _nextErrorMessage;

  /// Set the next API call to fail with the given error code
  void simulateError({required final int statusCode, final String? message}) {
    _nextErrorCode = statusCode;
    _nextErrorMessage = message;
  }

  /// Clear any simulated errors
  void clearError() {
    _nextErrorCode = null;
    _nextErrorMessage = null;
  }

  /// Simulate different types of network errors for testing
  void simulateNetworkError({final String? message}) {
    throw NetworkException(message: message ?? 'Simulated network error');
  }

  void simulateDataParsingError({final String? message}) {
    throw DataParsingException(message: message ?? 'Simulated parsing error');
  }

  void _checkForSimulatedError(final String operation) {
    if (_nextErrorCode != null) {
      final code = _nextErrorCode!;
      final message = _nextErrorMessage ?? 'Simulated error for $operation';
      // Clear error after throwing (one-time error)
      _nextErrorCode = null;
      _nextErrorMessage = null;
      throw ServerException(message: message, statusCode: code);
    }
  }

  // Simulated backend storage
  List<MonsterProperty> _properties = [
    const MonsterProperty(
      name: 'Schwimmen',
      unit: 'm',
      currentValue: 1000,
      maxValue: 1000,
    ),
    const MonsterProperty(
      name: 'Laufen',
      unit: 'km',
      currentValue: 50,
      maxValue: 50,
    ),
    const MonsterProperty(
      name: 'Radfahren',
      unit: 'km',
      currentValue: 100,
      maxValue: 100,
    ),
    const MonsterProperty(
      name: 'Krafttraining',
      unit: 'min',
      currentValue: 300,
      maxValue: 300,
    ),
  ];

  /// GET /api/properties
  /// Returns the current state of all monster properties
  @override
  Future<List<MonsterProperty>> getCurrentProperties() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Check for test errors (configured at top of class)
      _checkForTestError('GET /api/properties');

      // Check for simulated error
      _checkForSimulatedError('GET /api/properties');

      // Return copy of current properties
      return List.from(_properties);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on DataParsingException {
      rethrow;
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is DataParsingException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  /// POST /api/properties/reduce
  /// Reduces a specific property by the given amount
  /// Body: { "propertyName": string, "amount": double }
  @override
  Future<List<MonsterProperty>> reduceProperty({
    required final String propertyName,
    required final double amount,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Check for test errors (configured at top of class)
      _checkForTestError('POST /api/properties/reduce');

      // Check for simulated error
      _checkForSimulatedError('POST /api/properties/reduce');

      // Update the property
      _properties = _properties.map((final property) {
        if (property.name == propertyName) {
          final newValue = (property.currentValue - amount).clamp(
            0.0,
            property.maxValue,
          );
          return property.copyWith(currentValue: newValue);
        }
        return property;
      }).toList();

      // Return updated properties (as the API would)
      return List.from(_properties);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on DataParsingException {
      rethrow;
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is DataParsingException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  /// POST /api/properties/reset
  /// Reset endpoint (for testing purposes)
  @override
  Future<List<MonsterProperty>> resetProperties() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Check for test errors (configured at top of class)
      _checkForTestError('POST /api/properties/reset');

      // Check for simulated error
      _checkForSimulatedError('POST /api/properties/reset');

      _properties = _properties
          .map(
            (final property) =>
                property.copyWith(currentValue: property.maxValue),
          )
          .toList();

      return List.from(_properties);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on DataParsingException {
      rethrow;
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is DataParsingException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
