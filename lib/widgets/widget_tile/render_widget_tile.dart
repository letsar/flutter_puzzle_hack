import 'package:flutter/rendering.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';

class RenderWidgetTile extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderWidgetTile({
    RenderBox? child,
    required int index,
    required WidgetPuzzleBoardPainter painter,
  })  : _index = index,
        _painter = painter {
    this.child = child;
  }

  int get index => _index;
  int _index;
  set index(int value) {
    if (_index == value) {
      return;
    }
    _index = value;
    markNeedsPaint();
  }

  WidgetPuzzleBoardPainter get painter => _painter;
  WidgetPuzzleBoardPainter _painter;
  set painter(WidgetPuzzleBoardPainter value) {
    if (_painter == value) {
      return;
    }
    _painter = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    layer = _painter.paint!(context, offset, index, layer);
  }
}
