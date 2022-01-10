import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/layout/rendering/image_tile.dart';

class ImageTile extends StatefulWidget {
  const ImageTile({
    Key? key,
    required this.imagePath,
    required this.dx,
    required this.dy,
    required this.sizeFactor,
    required this.fit,
  }) : super(key: key);

  final String imagePath;
  final double dx;
  final double dy;
  final Size sizeFactor;
  final BoxFit fit;

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  ui.Image? image;
  ImageStream? imageStream;
  ImageStreamListener? imageStreamListener;

  @override
  void initState() {
    super.initState();
    updateImage();
  }

  @override
  void didUpdateWidget(ImageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imagePath != oldWidget.imagePath) {
      updateImage();
    }
  }

  void updateImage() {
    removeImageStreamListener();
    final provider = ExactAssetImage(widget.imagePath);
    final newImageStream = provider.resolve(ImageConfiguration.empty);
    final newImageStreamListener = ImageStreamListener((frame, _) {
      setState(() {
        image = frame.image;
      });
    });
    newImageStream.addListener(newImageStreamListener);
    imageStream = newImageStream;
    imageStreamListener = newImageStreamListener;
  }

  void removeImageStreamListener() {
    final oldImageStream = imageStream;
    final oldImageStreamListener = imageStreamListener;
    if (oldImageStream != null && oldImageStreamListener != null) {
      oldImageStream.removeListener(oldImageStreamListener);
    }
  }

  @override
  void dispose() {
    removeImageStreamListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = image;
    if (source == null) {
      return const SizedBox();
    }
    return RawImageTile(
      source: source,
      dx: widget.dx,
      dy: widget.dy,
      sizeFactor: widget.sizeFactor,
      fit: widget.fit,
    );
  }
}

class RawImageTile extends LeafRenderObjectWidget {
  const RawImageTile({
    Key? key,
    required this.source,
    required this.dx,
    required this.dy,
    required this.sizeFactor,
    required this.fit,
  }) : super(key: key);

  final ui.Image source;
  final double dx;
  final double dy;
  final Size sizeFactor;
  final BoxFit fit;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderImageTile(
      source: source,
      dx: dx,
      dy: dy,
      sizeFactor: sizeFactor,
      fit: fit,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderImageTile renderObject) {
    renderObject
      ..source = source
      ..dx = dx
      ..dy = dy
      ..sizeFactor = sizeFactor
      ..fit = fit;
  }
}
