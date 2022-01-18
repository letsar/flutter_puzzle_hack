import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_panel/puzzle_panel.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/image_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PuzzleController controller = PuzzleController(
    columns: 6,
    rows: 3,
  )..shuffle();

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
            Expanded(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        final puzzle = controller.puzzle;

                        return PuzzlePanel(
                          topLeftAreaExtent: 40,
                          top: DimensionButton(
                            valueNotifier: controller.columns,
                            direction: Axis.horizontal,
                          ),
                          left: DimensionButton(
                            valueNotifier: controller.rows,
                            direction: Axis.vertical,
                          ),
                          main: SlidingPuzzle(
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
                            delegate: const ImageSlidingPuzzleDelegate(
                              imagePath: 'assets/dash_fainting.gif',
                            ),
                          ),
                        );
                      },
                    )),
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
    final effectiveChild = controller.isEmptyTile(tile)
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
  }) : super(key: key);

  final Tile tile;
  final Widget child;

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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
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

class NotifierProvider<T extends Listenable> extends InheritedNotifier<T> {
  const NotifierProvider({
    Key? key,
    required Widget child,
    required T notifier,
  }) : super(
          key: key,
          notifier: notifier,
          child: child,
        );
}

class ValueProvider<T> extends InheritedWidget {
  const ValueProvider({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  final T value;

  @override
  bool updateShouldNotify(ValueProvider oldWidget) => value != oldWidget.value;
}

extension on BuildContext {
  T watchValue<T>() {
    return watchExactType<ValueProvider<T>>().value!;
  }

  T readValue<T>() {
    return readExactType<ValueProvider<T>>().value!;
  }

  T watchNotifier<T extends Listenable>() {
    return watchExactType<NotifierProvider<T>>().notifier!;
  }

  T readNotifier<T extends Listenable>() {
    return readExactType<NotifierProvider<T>>().notifier!;
  }

  T watchExactType<T extends InheritedWidget>() {
    return dependOnInheritedWidgetOfExactType<T>()!;
  }

  T readExactType<T extends InheritedWidget>() {
    return getElementForInheritedWidgetOfExactType<T>()!.widget as T;
  }
}
