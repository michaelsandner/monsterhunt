import 'package:monster/domain/entities/monster.dart';
import 'package:monster/domain/entities/monster_property.dart';

/// Interface für API Services
/// Ermöglicht einfachen Wechsel zwischen Mock und echtem Backend
abstract class ApiServiceInterface {
  /// GET /api/monster
  /// Returns the current monster with all its properties
  /// Used for initial load and fetching current state
  Future<Monster> getCurrentMonster();

  /// POST /api/properties/reduce
  /// Reduces a specific property by the given amount
  /// Body: { "propertyName": string, "amount": double }
  Future<List<MonsterProperty>> reduceProperty({
    required final String propertyName,
    required final double amount,
  });

  /// POST /api/properties/reset
  /// Resets all properties to their maximum values
  Future<List<MonsterProperty>> resetProperties();
}
