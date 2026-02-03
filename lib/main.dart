import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monster/core/di/dependency_injection.dart';
import 'package:monster/presentation/cubit/monster_cubit.dart';
import 'package:monster/presentation/pages/monster_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
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
      create: (final context) => getIt<MonsterCubit>()..loadMonster(),
      child: const MonsterPage(),
    ),
  );
}
