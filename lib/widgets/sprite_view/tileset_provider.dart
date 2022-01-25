import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';

class TilesetProvider extends StatefulWidget {
  const TilesetProvider({
    Key? key,
    required this.tileSet,
    required this.child,
  }) : super(key: key);

  final String tileSet;
  final Widget child;

  @override
  _TilesetProviderState createState() => _TilesetProviderState();
}

class _TilesetProviderState extends State<TilesetProvider> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    updateImage();
  }

  void updateImage() {
    final provider = ExactAssetImage(widget.tileSet);
    final newImageStream = provider.resolve(ImageConfiguration.empty);
    late ImageStreamListener newImageStreamListener;
    newImageStreamListener = ImageStreamListener((frame, _) {
      newImageStream.removeListener(newImageStreamListener);
      setState(() {
        image = frame.image;
      });
    });
    newImageStream.addListener(newImageStreamListener);
  }

  @override
  Widget build(BuildContext context) {
    return ValueProvider(
      value: image,
      child: widget.child,
    );
  }
}
