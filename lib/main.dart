import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/layout/widgets/image_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/layout/widgets/puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/models/puzzle.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';

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
    puzzle: const Puzzle(
      columns: 3,
      rows: 3,
      tiles: [0, 1, 2, 3, 4, 5, 6, 8, 7],
      // tiles: [1, 4, 3, 5, 6, 7, 0, 2, 8],
    ),
  );

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ImageSlidingPuzzle(
            imagePath: 'assets/dash_fainting.gif',
            // imagePath: 'assets/dash_square.png',
            puzzle: controller.puzzle,
            tiles: controller.tiles,
            columnSpacing: 2,
            tileBuilder: (context, tile, child) {
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
            },
          ),
        ),
      ),
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
          duration: const Duration(milliseconds: 300),
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
      context.readValue<PuzzleController>().updateState();
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
