import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/render_puzzle_board.dart';

class PuzzleTilePosition extends ParentDataWidget<BoardParentData> {
  const PuzzleTilePosition({
    Key? key,
    required this.column,
    required this.row,
    required Widget child,
  }) : super(key: key, child: child);

  final double column;
  final double row;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is BoardParentData);
    final parentData = renderObject.parentData! as BoardParentData;
    bool needsLayout = false;

    if (parentData.column != column) {
      parentData.column = column;
      needsLayout = true;
    }

    if (parentData.row != row) {
      parentData.row = row;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => PuzzleBoard;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('column', column));
    properties.add(DoubleProperty('row', row));
  }
}

class AnimatedPuzzleTilePosition extends ImplicitlyAnimatedWidget {
  const AnimatedPuzzleTilePosition({
    Key? key,
    required this.column,
    required this.row,
    required Curve curve,
    required Duration duration,
    VoidCallback? onEnd,
    required this.child,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final double column;
  final double row;
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedPuzzleTilePosition> createState() =>
      _AnimatedPuzzleTilePositionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('column', column));
    properties.add(DoubleProperty('row', row));
  }
}

class _AnimatedPuzzleTilePositionState
    extends AnimatedWidgetBaseState<AnimatedPuzzleTilePosition> {
  Tween<double>? _column;
  Tween<double>? _row;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _column = visitor(_column, widget.column, (dynamic value) {
      return Tween<double>(begin: value as double);
    }) as Tween<double>?;

    _row = visitor(_row, widget.row, (dynamic value) {
      return Tween<double>(begin: value as double);
    }) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;
    return PuzzleTilePosition(
      column: _column!.evaluate(animation),
      row: _row!.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(ObjectFlagProperty<Tween<double>>.has('column', _column));
    description.add(ObjectFlagProperty<Tween<double>>.has('row', _row));
  }
}
