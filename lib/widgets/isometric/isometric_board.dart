import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/render_isometric_board.dart';

class IsometricBoard extends MultiChildRenderObjectWidget {
  IsometricBoard({
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
    return RenderIsometricBoard(
      columns: columns,
      rows: rows,
      spacing: spacing,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderIsometricBoard renderObject,
  ) {
    renderObject
      ..columns = columns
      ..rows = rows
      ..spacing = spacing;
  }
}
