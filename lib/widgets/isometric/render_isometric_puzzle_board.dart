import 'package:flutter/rendering.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/render_puzzle_board.dart';

class RenderIsometricPuzzleBoard extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, PuzzleBoardParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, PuzzleBoardParentData> {
  RenderIsometricPuzzleBoard({
    List<RenderBox>? children,
    required int columns,
    required int rows,
    double spacing = 0,
  })  : _columns = columns,
        _rows = rows,
        _spacing = spacing {
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

  double get spacing => _spacing;
  double _spacing;
  set spacing(double value) {
    if (_spacing == value) {
      return;
    }
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! PuzzleBoardParentData) {
      child.parentData = PuzzleBoardParentData();
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  late List<RenderBox> _orderedList;

  @override
  void performLayout() {
    final size = constraints.biggest;

    final totalSpacing = (spacing * (columns + rows - 2));
    final effectiveWidth = size.width - totalSpacing;
    final childWidth = 2 * effectiveWidth / (columns + rows);
    final halfChildWidth = childWidth / 2;
    final quarterChildWidth = childWidth / 4;
    final effectiveHeight = size.height - totalSpacing / 2;
    final childHeight =
        effectiveHeight - (rows + columns - 2) * quarterChildWidth;

    final childConstraints = BoxConstraints.tightFor(
      width: childWidth,
      height: childHeight,
    );

    visitChildren((child) {
      child.layout(childConstraints);
      final childParentData = child.parentData as PuzzleBoardParentData;
      final row = childParentData.row!;
      final column = childParentData.column!;
      childParentData.offset = Offset(
        (_rows - row + column - 1) * (halfChildWidth + spacing),
        (row + column) * (quarterChildWidth + spacing / 2),
      );
    });

    _orderedList = _paintOrderedChildren();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final list = _orderedList.reversed.toList();

    for (final child in list) {
      final childParentData = child.parentData! as PuzzleBoardParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // We need to iterate over each column, and then each row.
    for (final child in _orderedList) {
      final childParentData = child.parentData! as PuzzleBoardParentData;
      context.paintChild(child, childParentData.offset + offset);
    }
  }

  List<RenderBox> _paintOrderedChildren() {
    // The paint order depends on the direction of the animation if any.
    final list = getChildrenAsList();

    list.sort((a, b) {
      final parentDataA = a.parentData as PuzzleBoardParentData;
      final parentDataB = b.parentData as PuzzleBoardParentData;
      final depthA = parentDataA.column! + parentDataA.row!;
      final depthB = parentDataB.column! + parentDataB.row!;

      return depthA.compareTo(depthB);
    });

    return list;
  }
}
