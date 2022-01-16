import 'package:flutter/foundation.dart';
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
      tiles: [1, 4, 3, 5, 6, 7, 0, 2, 8],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        controller: controller,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PuzzleController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Hack Challenge'),
      ),
      body: Center(
        child: ImageSlidingPuzzle(
          // imagePath: 'assets/dash_fainting.gif',
          imagePath: 'assets/dash_square.png',
          puzzle: controller.puzzle,
          tiles: controller.tiles,
          columnSpacing: 2,
          tileBuilder: (context, tile, child) {
            final effectiveChild =
                controller.isEmptyTile(tile) ? const SizedBox() : child;

            return AnimatedBuilder(
              animation: tile,
              builder: (context, child) {
                return PuzzleTile(
                  controller: controller,
                  tile: tile,
                  child: child!,
                );
              },
              child: effectiveChild,
            );
          },
        ),
      ),
    );
  }
}

class PuzzleTile extends StatelessWidget {
  const PuzzleTile({
    Key? key,
    required this.controller,
    required this.tile,
    required this.child,
  }) : super(key: key);

  final PuzzleController controller;
  final Tile tile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final column = controller.columnOf(tile);
    final row = controller.rowOf(tile);
    return AnimatedPuzzleTilePosition(
      column: column,
      row: row,
      duration: const Duration(milliseconds: 300),
      curve: const ElasticOutCurve(1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.isTileMovable(tile)) {
              controller.moveTiles(tile);
            }
          },
          child: child,
        ),
      ),
    );
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

extension on BuildContext {
  T watch<T extends Listenable>() {
    return dependOnInheritedWidgetOfExactType<NotifierProvider<T>>()!.notifier!;
  }

  T read<T extends Listenable>() {
    final widget =
        getElementForInheritedWidgetOfExactType<NotifierProvider<T>>()!.widget
            as InheritedNotifier<T>;
    return widget.notifier!;
  }
}
