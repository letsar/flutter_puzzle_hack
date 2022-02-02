import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({
    Key? key,
    required this.initialRows,
    required this.initialColumns,
    required this.child,
  }) : super(key: key);

  final int initialRows;
  final int initialColumns;
  final Widget child;

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  late final controller = PuzzleController(
    columns: widget.initialColumns,
    rows: widget.initialColumns,
  )..shuffle();

  @override
  Widget build(BuildContext context) {
    return ValueProvider(
      value: controller,
      child: MaterialApp(
        home: SlidingPuzzleSuccessDisplayer(
          controller: controller,
          child: widget.child,
        ),
      ),
    );
  }
}
