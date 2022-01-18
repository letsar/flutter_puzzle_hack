import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/render_puzzle_board.dart';

class PuzzleBoard extends MultiChildRenderObjectWidget {
  PuzzleBoard({
    Key? key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 0,
    required List<Widget> children,
  }) : super(key: key, children: children);

  final int columns;
  final int rows;
  final double columnSpacing;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPuzzleBoard(
      columns: columns,
      rows: rows,
      columnSpacing: columnSpacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPuzzleBoard renderObject,
  ) {
    renderObject
      ..columns = columns
      ..rows = rows
      ..columnSpacing = columnSpacing;
  }
}
