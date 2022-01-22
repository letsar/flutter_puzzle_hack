// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';
// import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/widget_puzzle_board.dart';

// class WidgetPuzzleTilePosition
//     extends ParentDataWidget<WidgetPuzzleBoardParentData> {
//   const WidgetPuzzleTilePosition({
//     Key? key,
//     required this.column,
//     required this.row,
//     required Widget child,
//   }) : super(key: key, child: child);

//   final double column;
//   final double row;

//   @override
//   void applyParentData(RenderObject renderObject) {
//     assert(renderObject.parentData is WidgetPuzzleBoardParentData);
//     final parentData = renderObject.parentData! as WidgetPuzzleBoardParentData;
//     bool needsLayout = false;

//     if (parentData.column != column) {
//       parentData.column = column;
//       needsLayout = true;
//     }

//     if (parentData.row != row) {
//       parentData.row = row;
//       needsLayout = true;
//     }

//     if (needsLayout) {
//       final AbstractNode? targetParent = renderObject.parent;
//       if (targetParent is RenderObject) targetParent.markNeedsLayout();
//     }
//   }

//   @override
//   Type get debugTypicalAncestorWidgetClass => WidgetPuzzleBoard;

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DoubleProperty('column', column));
//     properties.add(DoubleProperty('row', row));
//   }
// }

// class AnimatedWidgetPuzzleTilePosition extends ImplicitlyAnimatedWidget {
//   const AnimatedWidgetPuzzleTilePosition({
//     Key? key,
//     required this.column,
//     required this.row,
//     required Curve curve,
//     required Duration duration,
//     VoidCallback? onEnd,
//     required this.child,
//   }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

//   final double column;
//   final double row;
//   final Widget child;

//   @override
//   AnimatedWidgetBaseState<AnimatedWidgetPuzzleTilePosition> createState() =>
//       _AnimatedWidgetPuzzleTilePositionState();

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DoubleProperty('column', column));
//     properties.add(DoubleProperty('row', row));
//   }
// }

// class _AnimatedWidgetPuzzleTilePositionState
//     extends AnimatedWidgetBaseState<AnimatedWidgetPuzzleTilePosition> {
//   Tween<double>? _column;
//   Tween<double>? _row;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant AnimatedWidgetPuzzleTilePosition oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void forEachTween(TweenVisitor<dynamic> visitor) {
//     _column = visitor(_column, widget.column, (dynamic value) {
//       return Tween<double>(begin: value as double);
//     }) as Tween<double>?;

//     _row = visitor(_row, widget.row, (dynamic value) {
//       return Tween<double>(begin: value as double);
//     }) as Tween<double>?;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = this.animation;
//     return WidgetPuzzleTilePosition(
//       column: _column!.evaluate(animation),
//       row: _row!.evaluate(animation),
//       child: widget.child,
//     );
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder description) {
//     super.debugFillProperties(description);
//     description.add(ObjectFlagProperty<Tween<double>>.has('column', _column));
//     description.add(ObjectFlagProperty<Tween<double>>.has('row', _row));
//   }
// }
