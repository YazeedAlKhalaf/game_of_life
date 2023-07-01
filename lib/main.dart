import 'package:flutter/material.dart';
import 'package:game_of_life/game_of_life.dart';
import 'package:game_of_life/src/universe.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game of Life',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: GameOfLife(
          universe: Universe.something(),
        ),
      ),
    );
  }
}
