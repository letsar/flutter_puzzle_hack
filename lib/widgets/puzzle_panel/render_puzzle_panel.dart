import 'package:flutter/rendering.dart';

class PuzzlePanelParentData extends ContainerBoxParentData<RenderBox> {}

class RenderPuzzlePanel extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, PuzzlePanelParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, PuzzlePanelParentData> {
  RenderPuzzlePanel({
    List<RenderBox>? children,
    required double topLeftAreaExtent,
  }) : _topLeftAreaExtent = topLeftAreaExtent {
    addAll(children);
  }

  double get topLeftAreaExtent => _topLeftAreaExtent;
  double _topLeftAreaExtent;
  set topLeftAreaExtent(double value) {
    if (_topLeftAreaExtent == value) {
      return;
    }
    _topLeftAreaExtent = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! PuzzlePanelParentData) {
      child.parentData = PuzzlePanelParentData();
    }
  }

  @override
  void performLayout() {
    final widgets = getChildrenAsList();
    final top = widgets[0];
    final left = widgets[1];
    final main = widgets[2];

    final mainChildConstraints = constraints.deflate(EdgeInsets.only(
      left: _topLeftAreaExtent,
      top: _topLeftAreaExtent,
    ));

    main.layout(mainChildConstraints, parentUsesSize: true);
    _positionBox(main, Offset(_topLeftAreaExtent, _topLeftAreaExtent));

    final mainSize = main.size;

    final leftChildConstraints = BoxConstraints(
      maxWidth: _topLeftAreaExtent,
      minHeight: mainSize.height,
      maxHeight: mainSize.height,
    );

    left.layout(leftChildConstraints, parentUsesSize: true);
    _positionBox(
      left,
      Offset((_topLeftAreaExtent - left.size.width) / 2, _topLeftAreaExtent),
    );

    final topChildConstraints = BoxConstraints(
      minWidth: mainSize.width,
      maxWidth: mainSize.width,
      maxHeight: _topLeftAreaExtent,
    );

    top.layout(topChildConstraints, parentUsesSize: true);
    _positionBox(
      top,
      Offset(_topLeftAreaExtent, (_topLeftAreaExtent - top.size.height) / 2),
    );

    size = Size(
      mainSize.width + _topLeftAreaExtent,
      mainSize.height + _topLeftAreaExtent,
    );
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    return defaultPaint(context, offset);
  }
}
