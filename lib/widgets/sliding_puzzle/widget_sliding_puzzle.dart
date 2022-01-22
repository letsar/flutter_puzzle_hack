import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_tile/widget_tile.dart';

class WidgetSlidingPuzzleDelegate extends SlidingPuzzleDelegate {
  const WidgetSlidingPuzzleDelegate({
    required this.source,
  });

  final Widget source;

  @override
  Widget build(BuildContext context, SlidingPuzzleConfiguration configuration) {
    return WidgetSlidingPuzzle(
      source: source,
      configuration: configuration,
    );
  }
}

class WidgetSlidingPuzzle extends StatefulWidget {
  const WidgetSlidingPuzzle({
    Key? key,
    required this.configuration,
    required this.source,
  }) : super(key: key);

  final Widget source;
  final SlidingPuzzleConfiguration configuration;

  @override
  State<WidgetSlidingPuzzle> createState() => _WidgetSlidingPuzzleState();
}

class _WidgetSlidingPuzzleState extends State<WidgetSlidingPuzzle> {
  final link = WidgetPuzzleBoardLink();

  @override
  Widget build(BuildContext context) {
    final config = widget.configuration;
    return WidgetPuzzleBoard(
      columns: config.columns,
      rows: config.rows,
      columnSpacing: config.columnSpacing,
      link: link,
      source: widget.source,
      children: [
        ...config.tiles.map(
          (tile) {
            return config.tileBuilder(
              context,
              tile,
              WidgetTile(
                link: link,
                index: tile.correctIndex,
              ),
            );
          },
        ),
      ],
    );
  }
}
