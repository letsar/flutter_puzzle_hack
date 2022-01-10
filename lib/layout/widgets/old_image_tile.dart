import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ImageTilePainter extends CustomPainter {
  _ImageTilePainter({
    required this.source,
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
  })  : assert(dx >= 0 && dx < 1),
        assert(dy >= 0 && dy < 1),
        assert(width > 0 && width <= 1),
        assert(height > 0 && height <= 1);

  final ui.Image source;
  final double dx;
  final double dy;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawAtlas(
      source,
      [
        RSTransform.fromComponents(
          rotation: 0,
          scale: 1,
          anchorX: 0,
          anchorY: 0,
          translateX: 0,
          translateY: 0,
        ),
      ],
      [
        Rect.fromLTWH(
          dx * source.width,
          dy * source.height,
          width * source.width,
          height * source.height,
        ),
      ],
      null,
      null,
      null,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(_ImageTilePainter oldDelegate) {
    return oldDelegate.source != source ||
        oldDelegate.dx != dx ||
        oldDelegate.dy != dy;
  }
}
