import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/layout/widgets/grid.dart';
import 'package:flutter_puzzle_hack/layout/widgets/image_tile.dart';

class ImageSlidingPuzzle extends StatefulWidget {
  const ImageSlidingPuzzle({
    Key? key,
    required this.imagePath,
    required this.rows,
    required this.columns,
    required this.indexes,
    // required this.width,
    // required this.height,
  }) : super(key: key);

  final String imagePath;
  final int rows;
  final int columns;
  final List<int> indexes;
  // final double width;
  // final double height;

  @override
  _ImageSlidingPuzzleState createState() => _ImageSlidingPuzzleState();
}

class _ImageSlidingPuzzleState extends State<ImageSlidingPuzzle> {
  ui.Image? image;
  ImageStream? imageStream;
  ImageStreamListener? imageStreamListener;

  @override
  void initState() {
    super.initState();
    updateImage();
  }

  @override
  void didUpdateWidget(ImageSlidingPuzzle oldWidget) {
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
    final aspectRatio = source.width / source.height;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Grid(
        columns: widget.columns,
        rows: widget.rows,
        children: [
          ...widget.indexes.map(
            (index) => IndexedImageTile(
              index: index,
              rows: widget.rows,
              columns: widget.columns,
              source: source,
            ),
          )
        ],
      ),
    );
  }
}

class IndexedImageTile extends StatelessWidget {
  const IndexedImageTile({
    Key? key,
    required this.index,
    required this.rows,
    required this.columns,
    required this.source,
  })  : dx = (index % columns) / columns,
        dy = (index / columns) / rows,
        super(key: key);

  final int index;
  final int rows;
  final int columns;
  final double dx;
  final double dy;
  final ui.Image source;

  @override
  Widget build(BuildContext context) {
    final sizeFactor = Size(1 / columns, 1 / rows);
    return RawImageTile(
      dx: dx,
      dy: dy,
      fit: BoxFit.cover,
      sizeFactor: sizeFactor,
      source: source,
    );
  }
}
