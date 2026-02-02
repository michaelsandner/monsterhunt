import 'package:flutter/material.dart';
import 'package:monster/domain/entities/monster.dart';

class MonsterCard extends StatelessWidget {
  const MonsterCard({required this.monster, super.key});
  final Monster monster;

  @override
  Widget build(final BuildContext context) => Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            monster.icon,
            size: 120,
            color: monster.isDefeated ? Colors.grey : Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            monster.name,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            monster.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}
