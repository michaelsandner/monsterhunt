import 'dart:convert';

import 'package:monster/core/error/exceptions.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching monster properties
class LocalDataSource {
  LocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const String _propertiesKey = 'cached_properties';
  static const String _timestampKey = 'cache_timestamp';

  /// Get cached properties
  Future<List<MonsterProperty>> getCachedProperties() async {
    try {
      final jsonString = _prefs.getString(_propertiesKey);
      if (jsonString == null) {
        throw CacheException(message: 'No cached data found');
      }

      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((final json) => _propertyFromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException(message: 'Failed to read cache: $e');
    }
  }

  /// Cache properties
  Future<void> cacheProperties(final List<MonsterProperty> properties) async {
    try {
      final jsonList = properties.map(_propertyToJson).toList();
      final jsonString = json.encode(jsonList);

      await _prefs.setString(_propertiesKey, jsonString);
      await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(message: 'Failed to write cache: $e');
    }
  }

  /// Check if cache exists
  bool hasCachedData() => _prefs.containsKey(_propertiesKey);

  /// Get cache age in minutes
  int? getCacheAgeInMinutes() {
    final timestamp = _prefs.getInt(_timestampKey);
    if (timestamp == null) {
      return null;
    }

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    return now.difference(cacheTime).inMinutes;
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    await _prefs.remove(_propertiesKey);
    await _prefs.remove(_timestampKey);
  }

  /// Convert MonsterProperty to JSON
  Map<String, dynamic> _propertyToJson(final MonsterProperty property) => {
    'name': property.name,
    'unit': property.unit,
    'currentValue': property.currentValue,
    'maxValue': property.maxValue,
  };

  /// Convert JSON to MonsterProperty
  MonsterProperty _propertyFromJson(final Map<String, dynamic> json) {
    try {
      return MonsterProperty(
        name: json['name'] as String,
        unit: json['unit'] as String,
        currentValue: (json['currentValue'] as num).toDouble(),
        maxValue: (json['maxValue'] as num).toDouble(),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to parse cached property: $e');
    }
  }
}
