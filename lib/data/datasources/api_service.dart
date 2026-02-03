import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monster/core/error/exceptions.dart';
import 'package:monster/data/datasources/api_service_interface.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';

/// Real API Service that makes HTTP calls to backend
/// Implements actual REST API communication
class ApiService implements ApiServiceInterface {
  ApiService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
  });

  final String baseUrl;
  final Duration timeout;

  /// Handles standard exceptions and converts them to custom exceptions
  T _handleCommonApiExceptions<T>(final T Function() apiCall) {
    try {
      return apiCall();
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Network request failed');
    } on FormatException {
      throw DataParsingException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is DataParsingException) {
        rethrow;
      }
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  /// GET /api/monster
  /// Returns the current monster with all its properties
  /// Used for initial load and fetching current state
  @override
  Future<Monster> getCurrentMonster() async =>
      _handleCommonApiExceptions(() async {
        final response = await http
            .get(
              Uri.parse('$baseUrl/api/monster'),
              headers: {'Content-Type': 'application/json'},
            )
            .timeout(timeout);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body) as Map<String, dynamic>;
          final jsonList = jsonData['properties'] as List;
          final properties = jsonList
              .map(
                (final json) => _propertyFromJson(json as Map<String, dynamic>),
              )
              .toList();

          return Monster(
            name: jsonData['name'] as String,
            description: jsonData['description'] as String,
            icon: Icons.water_drop, // Icon kann später auch aus JSON kommen
            properties: properties,
          );
        } else {
          throw ServerException(
            message: 'Failed to load monster',
            statusCode: response.statusCode,
          );
        }
      });

  /// POST /api/properties/reduce
  /// Reduces a specific property by the given amount
  /// Body: { "propertyName": string, "amount": double }
  @override
  Future<List<MonsterProperty>> reduceProperty({
    required final String propertyName,
    required final double amount,
  }) async => _handleCommonApiExceptions(() async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/properties/reduce'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'propertyName': propertyName, 'amount': amount}),
        )
        .timeout(timeout);

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List;
      return jsonList
          .map((final json) => _propertyFromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException(
        message: 'Failed to reduce property',
        statusCode: response.statusCode,
      );
    }
  });

  /// POST /api/properties/reset
  /// Resets all properties to their maximum values
  @override
  Future<List<MonsterProperty>> resetProperties() async =>
      _handleCommonApiExceptions(() async {
        final response = await http
            .post(
              Uri.parse('$baseUrl/api/properties/reset'),
              headers: {'Content-Type': 'application/json'},
            )
            .timeout(timeout);

        if (response.statusCode == 200) {
          final jsonList = json.decode(response.body) as List;
          return jsonList
              .map(
                (final json) => _propertyFromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          throw ServerException(
            message: 'Failed to reset properties',
            statusCode: response.statusCode,
          );
        }
      });

  /// Helper method to parse JSON to MonsterProperty
  MonsterProperty _propertyFromJson(final Map<String, dynamic> json) {
    try {
      return MonsterProperty(
        name: json['name'] as String,
        unit: json['unit'] as String,
        currentValue: (json['currentValue'] as num).toDouble(),
        maxValue: (json['maxValue'] as num).toDouble(),
      );
    } catch (e) {
      throw DataParsingException(message: 'Failed to parse property: $e');
    }
  }
}
