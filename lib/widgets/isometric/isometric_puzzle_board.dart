import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/render_isometric_puzzle_board.dart';

class IsometricPuzzleBoard extends MultiChildRenderObjectWidget {
  IsometricPuzzleBoard({
    Key? key,
    required this.columns,
    required this.rows,
    this.spacing = 0,
    required List<Widget> children,
  }) : super(key: key, children: children);

  final int columns;
  final int rows;
  final double spacing;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderIsometricPuzzleBoard(
      columns: columns,
      rows: rows,
      spacing: spacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderIsometricPuzzleBoard renderObject,
  ) {
    renderObject
      ..columns = columns
      ..rows = rows
      ..spacing = spacing;
  }
}
