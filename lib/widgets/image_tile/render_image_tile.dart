import 'dart:ui';

import 'package:flutter/rendering.dart';

class RenderImageTile extends RenderBox {
  RenderImageTile({
    required Image source,
    required double dx,
    required double dy,
    required Size sizeFactor,
    required BoxFit fit,
    required Size boardSize,
  })  : _source = source,
        _sourceSize = Size(source.width.toDouble(), source.height.toDouble()),
        _dx = dx,
        _dy = dy,
        _sizeFactor = sizeFactor,
        _fit = fit,
        _boardSize = boardSize;

  Size _sourceSize;
  Image get source => _source;
  Image _source;
  set source(Image value) {
    if (_source == value) {
      return;
    }
    _source = value;
    _sourceSize = Size(value.width.toDouble(), value.height.toDouble());
    markNeedsPaint();
  }

  double get dx => _dx;
  double _dx;
  set dx(double value) {
    if (_dx == value) {
      return;
    }
    _dx = value;
    markNeedsPaint();
  }

  double get dy => _dy;
  double _dy;
  set dy(double value) {
    if (_dy == value) {
      return;
    }
    _dy = value;
    markNeedsPaint();
  }

  Size get sizeFactor => _sizeFactor;
  Size _sizeFactor;
  set sizeFactor(Size value) {
    if (_sizeFactor == value) {
      return;
    }
    _sizeFactor = value;
    markNeedsPaint();
  }

  BoxFit get fit => _fit;
  BoxFit _fit;
  set fit(BoxFit value) {
    if (_fit == value) {
      return;
    }
    _fit = value;
    markNeedsPaint();
  }

  Size get boardSize => _boardSize;
  Size _boardSize;
  set boardSize(Size value) {
    if (_boardSize == value) {
      return;
    }
    _boardSize = value;
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    const alignment = Alignment.center;
    final inputRect = Offset.zero & _sourceSize;
    final outputRect = Offset.zero & _boardSize;
    final sizes = applyBoxFit(_fit, _sourceSize, _boardSize);
    final inputSubrect = alignment.inscribe(sizes.source, inputRect);
    final outputSubrect = alignment.inscribe(sizes.destination, outputRect);
    final scale = outputSubrect.height / inputSubrect.height;

    context.canvas.drawAtlas(
      source,
      [
        RSTransform.fromComponents(
          rotation: 0,
          scale: scale,
          anchorX: 0,
          anchorY: 0,
          translateX: offset.dx + outputSubrect.left,
          translateY: offset.dy + outputSubrect.top,
        ),
      ],
      [
        Rect.fromLTWH(
          _dx * source.width + inputSubrect.left,
          _dy * source.height + inputSubrect.top,
          _sizeFactor.width * inputSubrect.width,
          _sizeFactor.height * inputSubrect.height,
        ),
      ],
      null,
      null,
      null,
      Paint()..filterQuality = FilterQuality.high,
    );
  }
}
