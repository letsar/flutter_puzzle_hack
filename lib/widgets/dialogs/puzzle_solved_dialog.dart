import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';

class PuzzleSolvedDialog extends StatelessWidget {
  const PuzzleSolvedDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final puzzleController = context.readValue<PuzzleController>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Yiihaaaa!',
            style: textTheme.headline1,
          ),
          Text(
            '''Congratulations! You solved a puzzle '''
            '''(${puzzleController.columns.value} columns and '''
            '''${puzzleController.rows.value} rows) in '''
            '''${puzzleController.timer.seconds} seconds with '''
            '''${puzzleController.moveCount.value} moves!''',
            style: textTheme.headline4,
          ),
        ],
      ),
    );
  }
}
