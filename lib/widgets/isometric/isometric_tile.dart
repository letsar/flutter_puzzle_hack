import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class IsometricTile extends LeafRenderObjectWidget {
  const IsometricTile({
    Key? key,
    required this.top,
    required this.left,
    required this.right,
  }) : super(key: key);

  final Color top;
  final Color left;
  final Color right;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderIsometricTile(top: top, left: left, right: right);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderIsometricTile renderObject,
  ) {
    renderObject
      ..top = top
      ..left = left
      ..right = right;
  }
}

class RenderIsometricTile extends RenderBox {
  RenderIsometricTile({
    required Color top,
    required Color left,
    required Color right,
  })  : _top = top,
        _left = left,
        _right = right;

  Color get top => _top;
  Color _top;
  set top(Color value) {
    if (_top == value) {
      return;
    }
    _top = value;
    markNeedsPaint();
  }

  Color get left => _left;
  Color _left;
  set left(Color value) {
    if (_left == value) {
      return;
    }
    _left = value;
    markNeedsPaint();
  }

  Color get right => _right;
  Color _right;
  set right(Color value) {
    if (_right == value) {
      return;
    }
    _right = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
    final width = size.width;
    final height = size.height;
    final halfWidth = width / 2;
    final halfHeight = height / 2;

    final h = size.aspectRatio > 2 ? halfHeight : width / 4;
    final w = halfWidth;

    return !_isAboveLine(Offset(0, h), Offset(w, 0), position) &&
        !_isAboveLine(Offset(w, 0), Offset(width, h), position) &&
        _isAboveLine(Offset(0, height - h), Offset(w, height), position) &&
        _isAboveLine(Offset(w, height - h), Offset(w, height), position);
  }

  bool _isAboveLine(Offset a, Offset b, Offset position) {
    return ((b.dx - a.dx) * (position.dy - a.dy) -
            (b.dy - a.dy) * (position.dx - a.dx)) >
        0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;
    final halfWidth = width / 2;
    final halfHeight = height / 2;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    paint.color = _top;

    void drawPolygon(List<Offset> points) {
      canvas.drawPath(
        Path()..addPolygon(points, true),
        paint,
      );
    }

    if (size.aspectRatio > 2) {
      // We cannot draw the left and right parts.
      drawPolygon(
        [
          Offset(0, halfHeight),
          Offset(halfWidth, 0),
          Offset(width, halfHeight),
          Offset(halfWidth, height),
        ],
      );
    } else {
      final quarterWidth = width / 4;
      drawPolygon(
        [
          Offset(0, quarterWidth),
          Offset(halfWidth, 0),
          Offset(width, quarterWidth),
          Offset(halfWidth, halfWidth),
        ],
      );

      paint.color = _left;
      drawPolygon(
        [
          Offset(0, quarterWidth),
          Offset(halfWidth, halfWidth),
          Offset(halfWidth, height),
          Offset(0, height - quarterWidth),
        ],
      );

      paint.color = _right;
      drawPolygon(
        [
          Offset(width, quarterWidth),
          Offset(halfWidth, halfWidth),
          Offset(halfWidth, height),
          Offset(width, height - quarterWidth),
        ],
      );
    }
    canvas.restore();
  }
}
