import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/puzzles/nature.dart';
import 'package:flutter_puzzle_hack/puzzles/swapped_widget_puzzle.dart';

void main() {
  runApp(const PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const IndexPage(),
        '/nature': (context) => const NaturePuzzle(),
        '/swapped_widget': (context) => const SwappedWidgetPuzzle(),
      },
    );
  }
}

class IndexPage extends StatelessWidget {
  const IndexPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/nature');
              },
              child: const Text('Nature Puzzle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/swapped_widget');
              },
              child: const Text('Swapped Widget Puzzle'),
            ),
          ],
        ),
      ),
    );
  }
}
