import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monster/core/di/dependency_injection.dart';
import 'package:monster/presentation/pages/monster_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Monster Challenge',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: BlocProvider(
      create: (final context) =>
          DependencyInjection.createMonsterCubit()..loadMonster(),
      child: const MonsterPage(),
    ),
  );
}
