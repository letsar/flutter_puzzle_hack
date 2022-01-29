import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/render_puzzle_board.dart';

typedef _Painter = void Function(
  PaintingContext context,
  Offset offset,
  int index,
);

class WidgetPuzzleBoardLink {
  _Painter? _paint;
  _Painter? get paint => _paint;
}

class RenderWidgetPuzzleBoard extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, BoardParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, BoardParentData> {
  RenderWidgetPuzzleBoard({
    List<RenderBox>? children,
    required int columns,
    required int rows,
    required WidgetPuzzleBoardLink link,
    double columnSpacing = 0,
  })  : _columns = columns,
        _rows = rows,
        _columnSpacing = columnSpacing,
        _link = link {
    addAll(children);
    _link._paint = _pushPermutationLayer;
  }

  int get columns => _columns;
  int _columns;
  set columns(int value) {
    if (_columns == value) {
      return;
    }
    _columns = value;
    markNeedsLayout();
  }

  int get rows => _rows;
  int _rows;
  set rows(int value) {
    if (_rows == value) {
      return;
    }
    _rows = value;
    markNeedsLayout();
  }

  double get columnSpacing => _columnSpacing;
  double _columnSpacing;
  set columnSpacing(double value) {
    if (_columnSpacing == value) {
      return;
    }
    _columnSpacing = value;
    markNeedsLayout();
  }

  WidgetPuzzleBoardLink get link => _link;
  WidgetPuzzleBoardLink _link;
  set link(WidgetPuzzleBoardLink value) {
    if (_link == value) {
      return;
    }
    _link._paint = null;
    _link = value;
    _link._paint = _pushPermutationLayer;
    markNeedsPaint();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoardParentData) {
      child.parentData = BoardParentData();
    }
  }

  // @override
  // bool get alwaysNeedsCompositing => true;

  late Size _sourceSize;
  late double _childWidth;
  late double _childHeight;
  late double _rowSpacing;
  late Rect _childClipRect;

  @override
  void performLayout() {
    final source = firstChild;
    if (source == null) {
      size = constraints.biggest;
      return;
    }

    source.layout(constraints, parentUsesSize: true);
    _sourceSize = source.size;
    size = constraints.constrain(_sourceSize);

    final BoxConstraints childConstraints;
    if (size == Size.zero) {
      _childWidth = 0;
      _childHeight = 0;
      _rowSpacing = 0;
      _childClipRect = Rect.zero;
      childConstraints = BoxConstraints.tight(Size.zero);
    } else {
      _rowSpacing = _columnSpacing / _sourceSize.aspectRatio;
      _childWidth =
          (_sourceSize.width - _columnSpacing * (columns - 1)) / _columns;
      _childHeight = (_sourceSize.height - _rowSpacing * (rows - 1)) / _rows;
      childConstraints = BoxConstraints.tightFor(
        width: _childWidth,
        height: _childHeight,
      );
      _childClipRect = Rect.fromLTWH(
        0,
        0,
        _childWidth,
        _childHeight,
      );
    }

    visitTileChildren((child) {
      child.layout(childConstraints);
      final childParentData = child.parentData as BoardParentData;
      final row = childParentData.row!;
      final column = childParentData.column!;
      childParentData.offset = Offset(
        column * (_childWidth + _columnSpacing),
        row * (_childHeight + _rowSpacing),
      );
    });
  }

  void visitTileChildren(RenderObjectVisitor visitor) {
    RenderBox? child = childAfter(firstChild!);
    while (child != null) {
      visitor(child);
      final childParentData = child.parentData! as BoardParentData;
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  void _pushPermutationLayer(
    PaintingContext context,
    Offset offset,
    int index,
  ) {
    final column = index % _columns;
    final row = index ~/ _columns;
    final source = firstChild!;

    final sourceOffset = Offset(
      column * (_childWidth + _columnSpacing),
      row * (_childHeight + _rowSpacing),
    );
    // layer = context.pushClipRect(
    //   // Should be true only with RepaintBoundaries ?
    //   false,
    //   offset,
    //   _childClipRect,
    //   (context, offset) {
    //     context.paintChild(source, offset - sourceOffset);
    //   },
    //   oldLayer: layer as ClipRectLayer?,
    // );
    context.clipRectAndPaint(
        Rect.fromLTWH(offset.dx, offset.dy, _childWidth, _childHeight),
        Clip.hardEdge,
        Rect.largest, () {
      context.paintChild(source, offset - sourceOffset);
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = childAfter(firstChild!);
    while (child != null) {
      final childParentData = child.parentData! as BoardParentData;
      context.paintChild(child, childParentData.offset + offset);
      context.canvas.saveLayer(Rect.largest, Paint());
      context.canvas.restore();
      context.canvas.restore();
      child = childParentData.nextSibling;
    }
  }
}
