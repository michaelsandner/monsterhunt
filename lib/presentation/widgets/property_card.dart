import 'package:flutter/material.dart';
import 'package:monster/domain/entities/monster_property.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({required this.property, super.key});
  final MonsterProperty property;

  @override
  Widget build(final BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                property.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${property.currentValue.toStringAsFixed(0)} / ${property.maxValue.toStringAsFixed(0)} ${property.unit}',
                style: TextStyle(
                  fontSize: 16,
                  color: property.isCompleted ? Colors.green : Colors.black87,
                  fontWeight: property.isCompleted
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: property.percentage / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              property.isCompleted ? Colors.green : Colors.blue,
            ),
            minHeight: 12,
          ),
          const SizedBox(height: 4),
          Text(
            '${property.percentage.toStringAsFixed(1)}% verbleibend',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    ),
  );
}
