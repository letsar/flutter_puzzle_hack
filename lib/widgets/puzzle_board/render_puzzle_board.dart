import 'package:flutter/rendering.dart';

class BoardParentData extends ContainerBoxParentData<RenderBox> {
  double? row;
  double? column;
}

class RenderPuzzleBoard extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, BoardParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, BoardParentData> {
  RenderPuzzleBoard({
    List<RenderBox>? children,
    required int columns,
    required int rows,
    double columnSpacing = 0,
  })  : _columns = columns,
        _rows = rows,
        _columnSpacing = columnSpacing {
    addAll(children);
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

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! BoardParentData) {
      child.parentData = BoardParentData();
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {
    final size = constraints.biggest;

    final rowSpacing = _columnSpacing / size.aspectRatio;
    final childWidth = (size.width - _columnSpacing * (columns - 1)) / _columns;
    final childHeight = (size.height - rowSpacing * (rows - 1)) / _rows;
    final childConstraints = BoxConstraints.tightFor(
      width: childWidth,
      height: childHeight,
    );

    visitChildren((child) {
      child.layout(childConstraints);
      final childParentData = child.parentData as BoardParentData;
      final row = childParentData.row!;
      final column = childParentData.column!;
      childParentData.offset = Offset(
        column * (childWidth + _columnSpacing),
        row * (childHeight + rowSpacing),
      );
    });
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
