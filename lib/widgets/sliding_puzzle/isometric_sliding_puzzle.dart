import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/custom_mouse_region.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_tile.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_controller_builder/puzzle_controller_builder.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sprite_view/sprite_paint.dart';
import 'package:flutter_puzzle_hack/widgets/sprite_view/tileset_provider.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';

class IsometricSlidingPuzzleDelegate extends SlidingPuzzleDelegate {
  const IsometricSlidingPuzzleDelegate();

  @override
  Widget build(BuildContext context, SlidingPuzzleConfiguration configuration) {
    return IsometricSlidingPuzzle(
      configuration: configuration,
    );
  }
}

class IsometricSlidingPuzzle extends StatefulWidget {
  const IsometricSlidingPuzzle({
    Key? key,
    required this.configuration,
  }) : super(key: key);

  final SlidingPuzzleConfiguration configuration;

  @override
  State<IsometricSlidingPuzzle> createState() => _IsometricSlidingPuzzleState();
}

class _IsometricSlidingPuzzleState extends State<IsometricSlidingPuzzle> {
  final link = WidgetPuzzleBoardLink();

  @override
  Widget build(BuildContext context) {
    final config = widget.configuration;
    return TilesetProvider(
      tileSet: 'assets/tileset.png',
      child: AspectRatio(
        aspectRatio: 1.6,
        child: IsometricPuzzleBoard(
          columns: config.columns,
          rows: config.rows,
          spacing: 8,
          children: [
            ...config.tiles.map(
              (tile) {
                return config.tileBuilder(
                  context,
                  tile,
                  HoverableIsometricTile(tile: tile),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

const _tileRects = [
  Rect.fromLTWH(0, 0, 72, 120),
  Rect.fromLTWH(72, 0, 46, 156),
  Rect.fromLTWH(118, 0, 78, 118),
  Rect.fromLTWH(196, 0, 68, 140),
  Rect.fromLTWH(264, 0, 66, 113),
  Rect.fromLTWH(330, 0, 66, 114),
  Rect.fromLTWH(396, 0, 58, 123),
  Rect.fromLTWH(454, 0, 76, 124),
  Rect.fromLTWH(648, 0, 64, 115),
];

class HoverableIsometricTile extends StatefulWidget {
  const HoverableIsometricTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  final Tile tile;

  @override
  State<HoverableIsometricTile> createState() => _HoverableIsometricTileState();
}

class _HoverableIsometricTileState extends State<HoverableIsometricTile>
    with SingleTickerProviderStateMixin {
  bool isHover = false;

  late final controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final position = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeOut.flipped,
  ).drive(Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.1),
  ));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> start() async {
    await controller.forward();
    await controller.animateBack(0);
    if (isHover) {
      start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomMouseRegion(
      onEnter: (_) {
        isHover = true;
        if (!controller.isAnimating) {
          start();
        }
      },
      onExit: (_) {
        isHover = false;
      },
      onHover: (_) {},
      child: SlideTransition(
        position: position,
        child: AnimatedBuilder(
          animation: widget.tile,
          builder: (context, child) {
            return Stack(
              children: [
                AnimatedIsometricTile(
                  top: widget.tile.isCorrect
                      ? const Color(0xFF2FE7C5)
                      : const Color(0xFFEB885A),
                  left: const Color(0xFF925538),
                  right: const Color(0xFFC6724B),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                ),
                Positioned.fill(
                  child: PuzzleControllerBuilder(
                    selector: (pc) => pc.id,
                    builder: (context, id, child) {
                      return Crop(
                        puzzleId: id,
                        isTileAtCorrectPosition: widget.tile.isCorrect,
                        tileRect: _tileRects[widget.tile.correctIndex],
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class AnimatedIsometricTile extends ImplicitlyAnimatedWidget {
  const AnimatedIsometricTile({
    Key? key,
    required this.top,
    required this.left,
    required this.right,
    required Duration duration,
    Curve? curve,
  }) : super(key: key, duration: duration, curve: curve ?? Curves.easeIn);

  final Color top;
  final Color left;
  final Color right;

  @override
  AnimatedWidgetBaseState<AnimatedIsometricTile> createState() =>
      _AnimatedIsometricTileState();
}

class _AnimatedIsometricTileState
    extends AnimatedWidgetBaseState<AnimatedIsometricTile> {
  ColorTween? top;
  ColorTween? left;
  ColorTween? right;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    top = visitor(top, widget.top,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    left = visitor(left, widget.left,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
    right = visitor(right, widget.right,
        (dynamic value) => ColorTween(begin: value as Color)) as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    return IsometricTile(
      top: top!.evaluate(animation)!,
      left: left!.evaluate(animation)!,
      right: right!.evaluate(animation)!,
    );
  }
}

class Crop extends StatefulWidget {
  const Crop({
    Key? key,
    required this.isTileAtCorrectPosition,
    required this.tileRect,
    required this.puzzleId,
  }) : super(key: key);

  final bool isTileAtCorrectPosition;
  final Rect tileRect;
  final int puzzleId;

  @override
  State<Crop> createState() => _CropState();
}

class _CropState extends State<Crop> {
  late int count = widget.isTileAtCorrectPosition ? 1 : 0;

  @override
  void didUpdateWidget(covariant Crop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.puzzleId != widget.puzzleId) {
      setState(() {
        count = 0;
      });
    }

    if (oldWidget.isTileAtCorrectPosition != widget.isTileAtCorrectPosition &&
        widget.isTileAtCorrectPosition) {
      setState(() {
        count++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpritePaint(
      tile: widget.tileRect,
      count: count,
    );
  }
}
