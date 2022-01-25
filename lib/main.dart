import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_tile.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/isometric_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';

void main() {
  // runApp(const MyWidgetApp());
  // runApp(const IsometricApp());
  runApp(const MyApp());
}

class IsometricApp extends StatelessWidget {
  const IsometricApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1.6,
              child: Container(
                color: Colors.red,
                child: const IsoBoard(
                  columns: 4,
                  rows: 4,
                  spacing: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IsoBoard extends StatelessWidget {
  const IsoBoard({
    Key? key,
    required this.columns,
    required this.rows,
    this.spacing = 0,
  }) : super(key: key);

  final int columns;
  final int rows;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return IsometricPuzzleBoard(
      columns: columns,
      rows: rows,
      spacing: spacing,
      children: List.generate(
        columns * rows,
        (index) {
          return PuzzleTilePosition(
            column: (index % columns).toDouble(),
            row: (index ~/ columns).toDouble(),
            child: const Iso01(),
          );
        },
      ),
    );
  }
}

class Iso01 extends StatelessWidget {
  const Iso01({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IsometricTile(
      top: Color(0xFF2FE7C5),
      left: Color(0xFF925538),
      right: Color(0xFFEB885A),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PuzzleController controller = PuzzleController(
    columns: 3,
    rows: 3,
  )..shuffle();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ValueProvider(
        value: controller,
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Hack Challenge'),
      ),
      body: Center(
        child: Column(
          children: [
            const NumberOfMoves(),
            const TilesLeft(),
            const ElapsedTime(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        // delegate: WidgetSlidingPuzzleDelegate(
                        //   // source: SizedBox.expand(
                        //   //   child: ColoredBox(
                        //   //     color: Colors.amber,
                        //   //     // child: MyTemplateHomePage(),
                        //   //     child: Center(
                        //   //       child: Padding(
                        //   //         padding: const EdgeInsets.all(8.0),
                        //   //         child: AspectRatio(
                        //   //           aspectRatio: 1,
                        //   //           child: CircularProgressIndicator(),
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //   ),
                        //   // ),
                        //   // source: const FlutterTemplatePuzzle(),
                        //   source: const FlutterLogoPuzzle(),
                        // ),
                        delegate: IsometricSlidingPuzzleDelegate(),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SuffleButton(),
          ],
        ),
      ),
    );
  }
}

class DimensionButton extends StatelessWidget {
  const DimensionButton({
    Key? key,
    this.min = 2,
    this.max = 8,
    required this.valueNotifier,
    required this.direction,
  })  : assert(min < max),
        super(key: key);

  final int min;
  final int max;
  final ValueNotifier<int> valueNotifier;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Flex(
          direction: direction,
          children: [
            TextButton(
              onPressed: value > min ? () => valueNotifier.value-- : null,
              child: Text('-'),
            ),
            Expanded(
              child: Center(child: Text('$value')),
            ),
            TextButton(
              onPressed: value < max ? () => valueNotifier.value++ : null,
              child: Text('+'),
            ),
          ],
        );
      },
    );
  }
}

class SuffleButton extends StatelessWidget {
  const SuffleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: const Text('Shuffle'),
      onPressed: () {
        context.readValue<PuzzleController>().shuffle();
      },
    );
  }
}

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    Key? key,
    required this.tile,
    required this.child,
  }) : super(key: key);

  final Tile tile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    final isEmptyTile = controller.isEmptyTile(tile);
    final effectiveChild = isEmptyTile
        ? PuzzleEmptyTile(
            tile: tile,
            child: child,
          )
        : child;

    return AnimatedBuilder(
      animation: tile,
      builder: (context, child) {
        return PuzzleTile(
          tile: tile,
          child: child!,
          ignorePointer: isEmptyTile,
        );
      },
      child: effectiveChild,
    );
  }
}

class NumberOfMoves extends StatelessWidget {
  const NumberOfMoves({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return ValueListenableBuilder<int>(
      valueListenable: controller.moveCount,
      builder: (context, numberOfMoves, child) {
        return Text(
          'Number of moves: $numberOfMoves',
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}

class ElapsedTime extends StatelessWidget {
  const ElapsedTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    final timer = controller.timer;
    return AnimatedBuilder(
      animation: timer,
      builder: (context, child) {
        return Text(
          'Elapsed seconds: ${timer.seconds}',
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}

class TilesLeft extends StatelessWidget {
  const TilesLeft({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return ValueListenableBuilder<int>(
      valueListenable: controller.tilesLeft,
      builder: (context, tilesLeft, child) {
        return Text(
          'Tiles left: $tilesLeft',
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}

class PuzzleEmptyTile extends StatelessWidget {
  const PuzzleEmptyTile({
    Key? key,
    required this.tile,
    required this.child,
  }) : super(key: key);

  final Tile tile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();

    return ValueListenableBuilder<bool>(
      valueListenable: controller.isSolved,
      builder: (context, isSolved, child) {
        return AnimatedOpacity(
          opacity: isSolved ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: child,
        );
      },
      child: child,
    );
  }
}

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.child,
    this.ignorePointer = false,
  }) : super(key: key);

  final Tile tile;
  final Widget child;
  final bool ignorePointer;

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();

    final column = controller.columnOf(widget.tile);
    final row = controller.rowOf(widget.tile);
    return AnimatedPuzzleTilePosition(
      column: column,
      row: row,
      duration: const Duration(milliseconds: 300),
      curve: const ElasticOutCurve(1),
      onEnd: handleAnimationEnded,
      child: IgnorePointer(
        ignoring: widget.ignorePointer,
        child: GestureDetector(
          onTap: () {
            if (controller.isTileMovable(widget.tile)) {
              tapped = true;
              controller.moveTiles(widget.tile);
            }
          },
          child: widget.child,
        ),
      ),
    );
  }

  void handleAnimationEnded() {
    if (tapped) {
      tapped = false;
      // context.readValue<PuzzleController>().updateState();
    }
  }
}
