import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/layout/rendering/image_tile.dart';

class RawImageTile extends LeafRenderObjectWidget {
  const RawImageTile({
    Key? key,
    required this.source,
    required this.dx,
    required this.dy,
    required this.sizeFactor,
    required this.fit,
    required this.boardSize,
  }) : super(key: key);

  final ui.Image source;
  final double dx;
  final double dy;
  final Size sizeFactor;
  final BoxFit fit;
  final Size boardSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderImageTile(
      source: source,
      dx: dx,
      dy: dy,
      sizeFactor: sizeFactor,
      fit: fit,
      boardSize: boardSize,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderImageTile renderObject) {
    renderObject
      ..source = source
      ..dx = dx
      ..dy = dy
      ..sizeFactor = sizeFactor
      ..fit = fit
      ..boardSize = boardSize;
  }
}
