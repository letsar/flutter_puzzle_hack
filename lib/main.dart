import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/layout/widgets/image_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/layout/widgets/puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/models/puzzle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PuzzleNotifier notifier = PuzzleNotifier(
    puzzle: const Puzzle(
      columns: 3,
      rows: 3,
      tiles: [1, 4, 3, 5, 6, 7, 0, 2, 8],
    ),
  );

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotifierProvider(
        notifier: notifier,
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
    final puzzle = context.watch<PuzzleNotifier>().puzzle;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Hack Challenge'),
      ),
      body: Center(
        child: ImageSlidingPuzzle(
          // imagePath: 'assets/dash_fainting.gif',
          imagePath: 'assets/dash_square.png',
          puzzle: puzzle,
          columnSpacing: 2,
          tileBuilder: (context, index, child) {
            if (puzzle.isEmptyTileIndex(index)) {
              return PuzzleTile(
                puzzle: puzzle,
                index: index,
                child: const SizedBox(),
              );
            }

            return PuzzleTile(
              puzzle: puzzle,
              index: index,
              child: child,
            );
          },
          // indexes: [0, 1, 2, 3, 4, 5, 6, 7, 8],
        ),
      ),
    );
  }
}

class PuzzleTile extends StatelessWidget {
  const PuzzleTile({
    Key? key,
    required this.puzzle,
    required this.index,
    required this.child,
  }) : super(key: key);

  final Puzzle puzzle;
  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedPuzzleTilePosition(
      column: puzzle.columnOf(index).toDouble(),
      row: puzzle.rowOf(index).toDouble(),
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (puzzle.isTileMovable(index)) {
              final notifier = context.read<PuzzleNotifier>();
              notifier.moveTiles(index);
            }
          },
          child: child,
        ),
      ),
    );
  }
}

class PuzzleNotifier extends ChangeNotifier {
  PuzzleNotifier({
    required Puzzle puzzle,
  }) : _puzzle = puzzle;

  Puzzle _puzzle;
  Puzzle get puzzle => _puzzle;

  bool isTileMovable(int index) {
    return _puzzle.isTileMovable(index);
  }

  void moveTiles(int index) {
    _puzzle = _puzzle.moveTiles(index);
    notifyListeners();
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
