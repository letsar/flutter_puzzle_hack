import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/puzzles/nature.dart';
import 'package:flutter_puzzle_hack/puzzles/permuted_widget_puzzle.dart';

void main() {
  runApp(const PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const NaturePuzzle();
    return const PermutedWidgetPuzzle();
  }
}
