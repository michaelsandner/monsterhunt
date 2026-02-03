import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monster/core/error/exceptions.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching monster data
class LocalDataSource {
  LocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  static const String _monsterKey = 'cached_monster';
  static const String _timestampKey = 'cache_timestamp';

  /// Get cached monster
  Future<Monster> getCachedMonster() async {
    try {
      final jsonString = _prefs.getString(_monsterKey);
      if (jsonString == null) {
        throw CacheException(message: 'No cached data found');
      }

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return _monsterFromJson(jsonData);
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException(message: 'Failed to read cache: $e');
    }
  }

  /// Cache monster
  Future<void> cacheMonster(final Monster monster) async {
    try {
      final jsonData = _monsterToJson(monster);
      final jsonString = json.encode(jsonData);

      await _prefs.setString(_monsterKey, jsonString);
      await _prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException(message: 'Failed to write cache: $e');
    }
  }

  /// Get cached properties (deprecated - use getCachedMonster instead)
  @Deprecated('Use getCachedMonster instead')
  Future<List<MonsterProperty>> getCachedProperties() async {
    final monster = await getCachedMonster();
    return monster.properties;
  }

  /// Cache properties (deprecated - use cacheMonster instead)
  @Deprecated('Use cacheMonster instead')
  Future<void> cacheProperties(final List<MonsterProperty> properties) async {
    // Legacy method - do nothing
    // This is kept for backwards compatibility but should not be used
  }

  /// Check if cache exists
  bool hasCachedData() => _prefs.containsKey(_monsterKey);

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
    await _prefs.remove(_monsterKey);
    await _prefs.remove(_timestampKey);
  }

  /// Convert Monster to JSON
  Map<String, dynamic> _monsterToJson(final Monster monster) => {
    'name': monster.name,
    'description': monster.description,
    'iconCodePoint': monster.icon.codePoint,
    'properties': monster.properties.map(_propertyToJson).toList(),
  };

  /// Convert JSON to Monster
  Monster _monsterFromJson(final Map<String, dynamic> json) {
    try {
      final propertiesList = json['properties'] as List;
      final properties = propertiesList
          .map((final prop) => _propertyFromJson(prop as Map<String, dynamic>))
          .toList();

      return Monster(
        name: json['name'] as String,
        description: json['description'] as String,
        icon: IconData(
          json['iconCodePoint'] as int,
          fontFamily: 'MaterialIcons',
        ),
        properties: properties,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to parse cached monster: $e');
    }
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
