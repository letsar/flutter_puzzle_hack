import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';
import 'package:flutter_puzzle_hack/widgets/dialogs/app_dialog.dart';
import 'package:flutter_puzzle_hack/widgets/dialogs/puzzle_solved_dialog.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_board.dart';

typedef TileWidgetBuilder = Widget Function(
  BuildContext context,
  Tile tile,
  Widget child,
);

class SlidingPuzzleConfiguration {
  const SlidingPuzzleConfiguration({
    required this.rows,
    required this.columns,
    required this.columnSpacing,
    required this.tiles,
    required this.tileBuilder,
  });

  final int rows;
  final int columns;
  final double columnSpacing;
  final List<Tile> tiles;
  final TileWidgetBuilder tileBuilder;
}

abstract class SlidingPuzzleDelegate {
  const SlidingPuzzleDelegate();

  Widget build(BuildContext context, SlidingPuzzleConfiguration configuration);
}

abstract class SimpleSlidingPuzzleDelegate extends SlidingPuzzleDelegate {
  const SimpleSlidingPuzzleDelegate();

  @override
  Widget build(
    BuildContext context,
    SlidingPuzzleConfiguration configuration,
  ) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: PuzzleBoard(
        columns: configuration.columns,
        rows: configuration.rows,
        columnSpacing: configuration.columnSpacing,
        children: [
          ...configuration.tiles.map(
            (tile) => buildTile(context, tile, configuration),
          ),
        ],
      ),
    );
  }

  Widget buildTile(
    BuildContext context,
    Tile tile,
    SlidingPuzzleConfiguration configuration,
  );
}

class SlidingPuzzle extends StatelessWidget {
  const SlidingPuzzle({
    Key? key,
    required this.delegate,
    required this.configuration,
  }) : super(key: key);

  final SlidingPuzzleDelegate delegate;
  final SlidingPuzzleConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return delegate.build(context, configuration);
  }
}

class SlidingPuzzleSuccessDisplayer extends StatefulWidget {
  const SlidingPuzzleSuccessDisplayer({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  final PuzzleController controller;
  final Widget child;

  @override
  _SlidingPuzzleSuccessDisplayerState createState() =>
      _SlidingPuzzleSuccessDisplayerState();
}

class _SlidingPuzzleSuccessDisplayerState
    extends State<SlidingPuzzleSuccessDisplayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.isSolved.addListener(_onSolvedChanged);
  }

  void _onSolvedChanged() {
    if (widget.controller.isSolved.value) {
      AppDialog.show(
        context: context,
        child: ValueProvider(
          value: widget.controller,
          child: const PuzzleSolvedDialog(),
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.controller.isSolved.removeListener(_onSolvedChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
