import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';

class SpritePaint extends StatelessWidget {
  const SpritePaint({
    Key? key,
    required this.tile,
    required this.count,
  }) : super(key: key);

  final Rect tile;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tileSet = context.watchValue<ui.Image?>();

    if (tileSet == null) {
      return const SizedBox();
    }

    return CustomPaint(
      painter: SpritePainter(
        tileSet: tileSet,
        tile: tile,
        count: count,
      ),
    );
  }
}

const _relativeOffsets = <Offset>[
  Offset(3 / 6, 1 / 6),
  Offset(4 / 6, 2 / 6),
  Offset(5 / 6, 3 / 6),
  Offset(2 / 6, 2 / 6),
  Offset(3 / 6, 3 / 6),
  Offset(4 / 6, 4 / 6),
  Offset(1 / 6, 3 / 6),
  Offset(2 / 6, 4 / 6),
  Offset(3 / 6, 5 / 6),
];

class SpritePainter extends CustomPainter {
  const SpritePainter({
    required this.tileSet,
    required this.tile,
    required this.count,
  });

  final ui.Image tileSet;
  final Rect tile;
  final int count;

  @override
  bool? hitTest(ui.Offset position) {
    return false;
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final width = size.width;
    final height = size.height;
    final w = width;
    final h = size.aspectRatio > 2 ? height : width / 2;

    final scale = (width / 6) / tile.width;
    final effectiveCount = count.clamp(0, 9);

    canvas.drawAtlas(
      tileSet,
      List.generate(
        effectiveCount,
        (index) {
          final offset = _relativeOffsets[index];
          final x = offset.dx * w;
          final y = offset.dy * h;
          return RSTransform.fromComponents(
            rotation: 0,
            scale: scale,
            anchorX: 0,
            anchorY: 0,
            translateX: x - (tile.width / 2) * scale,
            translateY: y - (tile.height * scale),
          );
        },
      ),
      List.filled(effectiveCount, tile),
      null,
      null,
      null,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return oldDelegate.tileSet != tileSet ||
        oldDelegate.tile != tile ||
        oldDelegate.count != count;
  }
}
