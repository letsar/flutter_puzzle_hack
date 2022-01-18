import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_panel/render_puzzle_panel.dart';

class PuzzlePanel extends MultiChildRenderObjectWidget {
  PuzzlePanel({
    Key? key,
    required this.topLeftAreaExtent,
    required Widget top,
    required Widget left,
    required Widget main,
  }) : super(key: key, children: [top, left, main]);

  final double topLeftAreaExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPuzzlePanel(
      topLeftAreaExtent: topLeftAreaExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPuzzlePanel renderObject,
  ) {
    renderObject.topLeftAreaExtent = topLeftAreaExtent;
  }
}
