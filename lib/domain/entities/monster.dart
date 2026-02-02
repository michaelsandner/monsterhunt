import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:monster/domain/entities/monster_property.dart';

class Monster extends Equatable {
  const Monster({
    required this.name,
    required this.description,
    required this.icon,
    required this.properties,
  });
  final String name;
  final String description;
  final IconData icon;
  final List<MonsterProperty> properties;

  bool get isDefeated => properties.every((final p) => p.isCompleted);

  Monster copyWith({
    final String? name,
    final String? description,
    final IconData? icon,
    final List<MonsterProperty>? properties,
  }) => Monster(
    name: name ?? this.name,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    properties: properties ?? this.properties,
  );

  @override
  List<Object?> get props => [name, description, icon, properties];
}
