import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/main.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_string.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/isometric_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';

const _angle = -30 * pi / 180;

const colors = [
  Color(0xFF8D6E63),
  Color(0xFF795548),
  Color(0xFF6D4C41),
  Color(0xFF66BB6A),
  Color(0xFF4CAF50),
  Color(0xFF43A047),
  Color(0xFF66BB6A),
  Color(0xFF795548),
  Color(0xFF6D4C41),
  Color(0xFF78909C),
  Color(0xFF607D8B),
  Color(0xFF546E7A),
  Color(0xFF43A047),
  Color(0xFF607D8B),
  Color(0xFF546E7A),
  Color(0xFFFAFAFA),
  Color(0xFFF5F5F5),
  Color(0xFFEEEEEE),
];

const _sandColor = Color(0xFFFFE7C9);
const _dirt1Color = Color(0xFFFFE7C9);
const _dirt2Color = Color(0xFFFFE7C9);
const _dirt3Color = Color(0xFFFFE7C9);
const _grassColor = Color(0xFFFFE7C9);

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
      child: Row(
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
            flex: 1,
            child: Column(
              children: [
                const TilesLeft(),
                const _ElapsedTime(),
                const SuffleButton(),
                const _NumberOfMoves(),
              ],
            ),
          )
        ],
      ),
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

    return SizedBox(
      height: 160,
      child: AnimatedBuilder(
        animation: timer,
        builder: (context, child) {
          final duration = Duration(seconds: timer.seconds);
          final label = _formatDuration(duration);
          return IsometricString(
            string: label,
            duration: Duration(milliseconds: 500),
            curve: ElasticOutCurve(1),
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
    return ValueListenableBuilder<int>(
      valueListenable: controller.moveCount,
      builder: (context, numberOfMoves, child) {
        return IsometricString(
          string: '$numberOfMoves',
          duration: Duration(milliseconds: 500),
          curve: ElasticOutCurve(1),
          topToBottom: false,
        );
      },
    );

    return Transform(
      transform: Matrix4.rotationZ(-_angle) * Matrix4.skewX(_angle),
      child: ValueListenableBuilder<int>(
        valueListenable: controller.moveCount,
        builder: (context, numberOfMoves, child) {
          return Text(
            '$numberOfMoves',
            style: Theme.of(context).textTheme.headline1!.copyWith(
              color: Color(0xFFE7C46E),
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 2.0,
                  color: Color(0xFFD1B369),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
