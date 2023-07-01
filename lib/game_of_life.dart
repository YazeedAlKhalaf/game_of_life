import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool tickManually = true;
  int millisecondsPerTick = 1000;
  int lastElapsedMilliseconds = 0;

  late Ticker ticker;

  @override
  void initState() {
    super.initState();

    ticker = Ticker((elapsed) {
      final elapsedMilliseconds = elapsed.inMilliseconds;
      if ((elapsedMilliseconds - lastElapsedMilliseconds) >=
          millisecondsPerTick) {
        setState(() {
          widget.universe.tick();
          lastElapsedMilliseconds = elapsedMilliseconds;
        });
      }
    });
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(),
          ColoredBox(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: FittedBox(
              fit: BoxFit.fill,
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 15.0,
                boundaryMargin: const EdgeInsets.all(50),
                child: Text(
                  widget.universe.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Auto\nTick',
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 10),
              Switch.adaptive(
                value: tickManually,
                onChanged: (bool newValue) {
                  setState(() {
                    tickManually = newValue;

                    if (tickManually) {
                      ticker.stop();
                    } else {
                      ticker.start();
                    }
                  });
                },
              ),
              const SizedBox(width: 10),
              const Text(
                'Manual\nTick',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(300, 50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tick Speed: '),
                Expanded(
                  child: Slider.adaptive(
                    value: millisecondsPerTick.toDouble(),
                    min: 100,
                    max: 1000,
                    onChanged: tickManually
                        ? null
                        : (double newValue) {
                            setState(() {
                              millisecondsPerTick = newValue.round();
                            });
                          },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: tickManually
                ? () {
                    setState(() {
                      widget.universe.tick();
                    });
                  }
                : null,
            child: const Text('Tick'),
          ),
        ],
      ),
    );
  }
}
