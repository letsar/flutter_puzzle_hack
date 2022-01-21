import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';

class WidgetPuzzleBoard extends MultiChildRenderObjectWidget {
  WidgetPuzzleBoard({
    Key? key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 0,
    required this.painter,
    required Widget source,
    required List<Widget> children,
  }) : super(key: key, children: [source, ...children]);

  final int columns;
  final int rows;
  final double columnSpacing;
  final WidgetPuzzleBoardPainter painter;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderWidgetPuzzleBoard(
      columns: columns,
      rows: rows,
      columnSpacing: columnSpacing,
      painter: painter,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderWidgetPuzzleBoard renderObject,
  ) {
    renderObject
      ..columns = columns
      ..rows = rows
      ..columnSpacing = columnSpacing
      ..painter = painter;
  }
}
