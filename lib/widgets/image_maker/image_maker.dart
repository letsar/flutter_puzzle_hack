import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

typedef ImageMakerWidgetBuilder = Widget Function(
  BuildContext context,
  ui.Image? image,
  Widget? child,
);

class ImageMaker extends StatefulWidget {
  const ImageMaker({
    Key? key,
    required this.source,
    required this.builder,
    required this.size,
    this.child,
    this.isAnimated = false,
  }) : super(key: key);

  /// The widget to transform into an image.
  final Widget source;
  final ImageMakerWidgetBuilder builder;
  final Widget? child;
  final Size size;
  final bool isAnimated;

  @override
  State<ImageMaker> createState() => _ImageMakerState();
}

class _ImageMakerState extends State<ImageMaker>
    with SingleTickerProviderStateMixin {
  ui.Image? image;
  Ticker? ticker;
  var repaintBoundary = RenderRepaintBoundary();
  late var renderView = RenderView(
    window: ui.window,
    child: repaintBoundary,
    configuration: ViewConfiguration(
      size: widget.size,
      devicePixelRatio: 1,
    ),
  );
  var pipelineOwner = PipelineOwner();
  var buildOwner = BuildOwner(focusManager: FocusManager());
  late var rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: widget.source,
  ).attachToRenderTree(buildOwner);

  @override
  void initState() {
    super.initState();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    if (widget.isAnimated) {
      ticker = createTicker(handleTick)..start();
    } else {
      computeImage();
    }
  }

  @override
  void didUpdateWidget(covariant ImageMaker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.size != widget.size ||
        oldWidget.source.runtimeType != widget.source.runtimeType) {
      repaintBoundary = RenderRepaintBoundary();

      renderView = RenderView(
        window: ui.window,
        child: repaintBoundary,
        configuration: ViewConfiguration(
          size: widget.size,
          devicePixelRatio: 1,
        ),
      );
      pipelineOwner = PipelineOwner();
      buildOwner = BuildOwner(focusManager: FocusManager());
      rootElement = RenderObjectToWidgetAdapter<RenderBox>(
        container: repaintBoundary,
        child: widget.source,
      ).attachToRenderTree(buildOwner);

      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();
    }

    if (oldWidget.isAnimated != widget.isAnimated) {
      if (widget.isAnimated) {
        ticker = createTicker(handleTick)..start();
        return;
      } else {
        ticker?.dispose();
      }
    }
    computeImage();
  }

  void handleTick(Duration elapsed) {
    computeImage();
  }

  Future<void> computeImage() async {
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    image = await repaintBoundary.toImage();

    setState(() {});
  }

  @override
  void dispose() {
    ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, image, widget.child);
  }
}
