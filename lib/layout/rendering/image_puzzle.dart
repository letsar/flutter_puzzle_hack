import 'dart:ui';

import 'package:flutter/rendering.dart';

class ImagePuzzleParentData extends ContainerBoxParentData<RenderBox> {
  /// Final index of the child.
  int? index;
}

class RenderImagePuzzle extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ImagePuzzleParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ImagePuzzleParentData> {
  RenderImagePuzzle({
    List<RenderBox>? children,
    required int rows,
    required int columns,
    required Image image,
  })  : _rows = rows,
        _columns = columns,
        _image = image {
    addAll(children);
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

  int get columns => _columns;
  int _columns;
  set columns(int value) {
    if (_columns == value) {
      return;
    }
    _columns = value;
    markNeedsLayout();
  }

  Image get image => _image;
  Image _image;
  set image(Image value) {
    if (_image == value) {
      return;
    }
    _image = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO:use canvas.drawAtlas.
    defaultPaint(context, offset);
  }
}
