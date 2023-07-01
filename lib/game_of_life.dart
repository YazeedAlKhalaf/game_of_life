import 'package:flutter/material.dart';
import 'package:game_of_life/src/universe.dart';

class GameOfLife extends StatefulWidget {
  final Universe universe;

  const GameOfLife({
    super.key,
    required this.universe,
  });

  @override
  State<GameOfLife> createState() => _GameOfLifeState();
}

class _GameOfLifeState extends State<GameOfLife> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FilledButton(
            onPressed: () {
              setState(() {
                widget.universe.tick();
              });
            },
            child: const Text('Tick'),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 15.0,
              boundaryMargin: const EdgeInsets.all(20),
              child: Text(
                widget.universe.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
