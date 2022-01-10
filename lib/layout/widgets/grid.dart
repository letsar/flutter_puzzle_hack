import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/layout/rendering/grid.dart';

class Grid extends MultiChildRenderObjectWidget {
  Grid({
    Key? key,
    required this.columns,
    required this.rows,
    required List<Widget> children,
  }) : super(key: key, children: children);

  final int columns;
  final int rows;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGrid(
      columns: columns,
      rows: rows,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderGrid renderObject) {
    renderObject
      ..columns = columns
      ..rows = rows;
  }
}
