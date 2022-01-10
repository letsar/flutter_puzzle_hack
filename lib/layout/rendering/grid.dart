import 'package:flutter/rendering.dart';

class GridParentData extends ContainerBoxParentData<RenderBox> {}

class RenderGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, GridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, GridParentData> {
  RenderGrid({
    List<RenderBox>? children,
    required int columns,
    required int rows,
  })  : _columns = columns,
        _rows = rows {
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

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! GridParentData) {
      child.parentData = GridParentData();
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
    final childWidth = size.width / _columns;
    final childHeight = size.height / _rows;
    final childConstraints = BoxConstraints.tightFor(
      width: childWidth,
      height: childHeight,
    );

    int index = 0;
    visitChildren((child) {
      child.layout(childConstraints);
      final row = index ~/ _columns;
      final column = index % _columns;
      final parentData = child.parentData as GridParentData;
      parentData.offset = Offset(column * childWidth, row * childHeight);
      index++;
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
