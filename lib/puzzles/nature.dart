import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_button.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_string.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/isometric_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';

class NaturePuzzle extends StatefulWidget {
  const NaturePuzzle({
    Key? key,
  }) : super(key: key);

  @override
  State<NaturePuzzle> createState() => _NaturePuzzleState();
}

class _NaturePuzzleState extends State<NaturePuzzle> {
  final controller = PuzzleController(
    columns: 3,
    rows: 3,
  )..shuffle();

  @override
  Widget build(BuildContext context) {
    return ValueProvider(
      value: controller,
      child: const _Game(),
    );
  }
}

class _Game extends StatelessWidget {
  const _Game({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return Container(
      color: const Color(0xFFF7F3BA),
      child: OrientationBuilder(builder: (context, orientation) {
        return Flex(
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8.0,
                  ),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      final puzzle = controller.puzzle;

                      return SlidingPuzzle(
                        configuration: SlidingPuzzleConfiguration(
                          columns: puzzle.columns,
                          rows: puzzle.rows,
                          columnSpacing: 2,
                          tiles: controller.tiles,
                          tileBuilder: (context, tile, child) {
                            return AnimatedTile(
                              tile: tile,
                              child: child,
                            );
                          },
                        ),
                        delegate: const IsometricSlidingPuzzleDelegate(),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Flex(
                    direction: orientation == Orientation.landscape
                        ? Axis.vertical
                        : Axis.horizontal,
                    children: [
                      const Expanded(
                        child: Center(
                          child: _ElapsedTime(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: IsometricButton(
                            icon: Icons.shuffle,
                            onPressed: () {
                              context.readValue<PuzzleController>().shuffle();
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: _NumberOfMoves(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ElapsedTime extends StatelessWidget {
  const _ElapsedTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    final timer = controller.timer;

    return Tooltip(
      message: 'Elapsed time',
      child: AnimatedBuilder(
        animation: timer,
        builder: (context, child) {
          final duration = Duration(seconds: timer.seconds);
          final label = _formatDuration(duration);
          return IsometricString(
            string: label,
            duration: const Duration(milliseconds: 500),
            curve: const ElasticOutCurve(1),
            topToBottom: true,
          );
        },
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
}

class _NumberOfMoves extends StatelessWidget {
  const _NumberOfMoves({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return Tooltip(
      message: 'Number of moves',
      child: ValueListenableBuilder<int>(
        valueListenable: controller.moveCount,
        builder: (context, numberOfMoves, child) {
          return IsometricString(
            string: '$numberOfMoves',
            duration: Duration(milliseconds: 500),
            curve: ElasticOutCurve(1),
            topToBottom: false,
          );
        },
      ),
    );
  }
}
