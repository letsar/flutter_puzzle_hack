import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef _Painter = ClipRectLayer? Function(
  PaintingContext context,
  Offset offset,
  int index,
  ContainerLayer? oldLayer,
);

class WidgetPuzzleBoardPainter {
  _Painter? _paint;
  _Painter? get paint => _paint;
}

class WidgetPuzzleBoardParentData extends ContainerBoxParentData<RenderBox> {
  double? row;
  double? column;
}

class RenderWidgetPuzzleBoard extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, WidgetPuzzleBoardParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            WidgetPuzzleBoardParentData> {
  RenderWidgetPuzzleBoard({
    List<RenderBox>? children,
    required int columns,
    required int rows,
    required WidgetPuzzleBoardPainter painter,
    double columnSpacing = 0,
  })  : _columns = columns,
        _rows = rows,
        _columnSpacing = columnSpacing,
        _painter = painter {
    addAll(children);
    _painter._paint = _pushPermutationLayer;
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

  WidgetPuzzleBoardPainter get painter => _painter;
  WidgetPuzzleBoardPainter _painter;
  set painter(WidgetPuzzleBoardPainter value) {
    if (_painter == value) {
      return;
    }
    _painter._paint = null;
    _painter = value;
    _painter._paint = _pushPermutationLayer;
    markNeedsPaint();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! WidgetPuzzleBoardParentData) {
      child.parentData = WidgetPuzzleBoardParentData();
    }
  }

  late Size _sourceSize;
  late Rect _inputSubrect;
  late Rect _outputSubrect;
  late double _childWidth;
  late double _childHeight;
  late double _rowSpacing;

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

    _rowSpacing = _columnSpacing / _sourceSize.aspectRatio;
    _childWidth =
        (_sourceSize.width - _columnSpacing * (columns - 1)) / _columns;
    _childHeight = (_sourceSize.height - _rowSpacing * (rows - 1)) / _rows;
    final childConstraints = BoxConstraints.tightFor(
      width: _childWidth,
      height: _childHeight,
    );

    visitTileChildren((child) {
      child.layout(childConstraints);
      final childParentData = child.parentData as WidgetPuzzleBoardParentData;
      final row = childParentData.row!;
      final column = childParentData.column!;
      final parentData = child.parentData as WidgetPuzzleBoardParentData;
      parentData.offset = Offset(
        column * (_childWidth + _columnSpacing),
        row * (_childHeight + _rowSpacing),
      );
    });
  }

  void visitTileChildren(RenderObjectVisitor visitor) {
    RenderBox? child = childAfter(firstChild!);
    while (child != null) {
      visitor(child);
      final childParentData = child.parentData! as WidgetPuzzleBoardParentData;
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  ClipRectLayer? _pushPermutationLayer(
    PaintingContext context,
    Offset offset,
    int index,
    ContainerLayer? oldLayer,
  ) {
    final column = index % _columns;
    final row = index ~/ _columns;
    final source = firstChild!;

    final sourceOffset = Offset(
      column * (_childWidth + _columnSpacing),
      row * (_childHeight + _rowSpacing),
    );

    layer = context.pushClipRect(
      needsCompositing,
      offset,
      Rect.fromLTWH(
        0,
        0,
        _childWidth,
        _childHeight,
      ),
      (context, offset) {
        context.paintChild(source, offset - sourceOffset);
      },
      oldLayer: layer as ClipRectLayer?,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    const alignment = Alignment.center;
    final inputRect = Offset.zero & _sourceSize;
    final outputRect = Offset.zero & size;
    final sizes = applyBoxFit(BoxFit.cover, _sourceSize, size);
    _inputSubrect = alignment.inscribe(sizes.source, inputRect);
    _outputSubrect = alignment.inscribe(sizes.destination, outputRect);

    RenderBox? child = childAfter(firstChild!);
    while (child != null) {
      final childParentData = child.parentData! as WidgetPuzzleBoardParentData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }
}
