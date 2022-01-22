import 'package:flutter/rendering.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';

class RenderWidgetTile extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  RenderWidgetTile({
    RenderBox? child,
    required int index,
    required WidgetPuzzleBoardLink link,
  })  : _index = index,
        _link = link {
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

  WidgetPuzzleBoardLink get link => _link;
  WidgetPuzzleBoardLink _link;
  set link(WidgetPuzzleBoardLink value) {
    if (_link == value) {
      return;
    }
    _link = value;
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
    _link.paint!(context, offset, index);
  }
}
