import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/layout/widgets/puzzle_board.dart';
import 'package:flutter_puzzle_hack/layout/widgets/raw_image_tile.dart';
import 'package:flutter_puzzle_hack/layout/widgets/sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';

typedef ImageSlidingPuzzleWidgetBuilder = Widget Function(
  BuildContext context,
  int index,
  ui.Image source,
);

class ImageSlidingPuzzleDelegate extends SlidingPuzzleDelegate {
  const ImageSlidingPuzzleDelegate({
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context, SlidingPuzzleConfiguration configuration) {
    return ImageSlidingPuzzle(
      imagePath: imagePath,
      columns: configuration.columns,
      rows: configuration.rows,
      tiles: configuration.tiles,
      columnSpacing: 2,
      tileBuilder: configuration.tileBuilder,
    );
  }
}

class ImageSlidingPuzzle extends StatefulWidget {
  const ImageSlidingPuzzle({
    Key? key,
    required this.imagePath,
    required this.columns,
    required this.rows,
    required this.tiles,
    this.columnSpacing = 0,
    required this.tileBuilder,
  }) : super(key: key);

  final String imagePath;
  final int columns;
  final int rows;
  final List<Tile> tiles;
  final double columnSpacing;
  final TileWidgetBuilder tileBuilder;

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = widget.columns;
          final rows = widget.rows;
          final size = constraints.biggest;
          final rowSpacing = widget.columnSpacing / aspectRatio;
          final maxWidth = size.width - (columns - 1) * widget.columnSpacing;
          final maxHeight = size.height - (rows - 1) * rowSpacing;
          final boardSize = Size(maxWidth, maxHeight);
          return PuzzleBoard(
            columns: columns,
            rows: rows,
            columnSpacing: widget.columnSpacing,
            children: [
              ...widget.tiles.map(
                (tile) {
                  return widget.tileBuilder(
                    context,
                    tile,
                    IndexedImageTile(
                      index: tile.correctIndex,
                      rows: rows,
                      columns: columns,
                      source: source,
                      boardSize: boardSize,
                    ),
                  );
                },
              ),
            ],
          );
        },
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
    required this.boardSize,
  })  : dx = (index % columns) / columns,
        dy = (index ~/ columns) / rows,
        super(key: key);

  final int index;
  final int rows;
  final int columns;
  final double dx;
  final double dy;
  final ui.Image source;
  final Size boardSize;

  @override
  Widget build(BuildContext context) {
    final sizeFactor = Size(1 / columns, 1 / rows);
    return RawImageTile(
      dx: dx,
      dy: dy,
      fit: BoxFit.cover,
      sizeFactor: sizeFactor,
      source: source,
      boardSize: boardSize,
    );
  }
}
