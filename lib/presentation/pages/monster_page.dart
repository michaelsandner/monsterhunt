import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monster/domain/entities/monster.dart';
import 'package:monster/presentation/cubit/monster_cubit.dart';
import 'package:monster/presentation/cubit/monster_state.dart';
import 'package:monster/presentation/widgets/monster_card.dart';
import 'package:monster/presentation/widgets/property_card.dart';
import 'package:monster/presentation/widgets/property_input_form.dart';

class MonsterPage extends StatelessWidget {
  const MonsterPage({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Monster Challenge'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    ),
    body: BlocConsumer<MonsterCubit, MonsterState>(
      listener: (final context, final state) {
        if (state is MonsterPropertyCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 ${state.propertyName} abgeschlossen!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is MonsterDefeated) {
          _showVictoryDialog(context, state.monster);
        }
      },
      builder: (final context, final state) {
        if (state is MonsterInitial) {
          unawaited(context.read<MonsterCubit>().loadMonster());
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MonsterLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MonsterError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Fehler: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      unawaited(context.read<MonsterCubit>().loadMonster()),
                  child: const Text('Erneut versuchen'),
                ),
              ],
            ),
          );
        }

        final monster = _getMonsterFromState(state);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MonsterCard(monster: monster),
                const SizedBox(height: 24),
                Text(
                  'Monster-Eigenschaften',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...monster.properties.map(
                  (final property) => PropertyCard(property: property),
                ),
                const SizedBox(height: 24),
                PropertyInputForm(monster: monster),
              ],
            ),
          ),
        );
      },
    ),
  );

  Monster _getMonsterFromState(final MonsterState state) {
    if (state is MonsterLoaded) {
      return state.monster;
    }
    if (state is MonsterPropertyCompleted) {
      return state.monster;
    }
    if (state is MonsterDefeated) {
      return state.monster;
    }
    throw Exception('Invalid state');
  }

  void _showVictoryDialog(final BuildContext context, final Monster monster) {
    unawaited(
      showDialog(
        context: context,
        builder: (final dialogContext) => AlertDialog(
          title: const Text('🏆 Sieg!'),
          content: Text('Du hast ${monster.name} besiegt!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                unawaited(context.read<MonsterCubit>().resetMonsterState());
              },
              child: const Text('Neuer Kampf'),
            ),
          ],
        ),
      ),
    );
  }
}
