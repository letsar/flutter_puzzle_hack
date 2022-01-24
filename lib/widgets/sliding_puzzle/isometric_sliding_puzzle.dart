import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/custom_mouse_region.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_tile.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';
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
    return AspectRatio(
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
                Iso01(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Iso01 extends StatefulWidget {
  const Iso01({
    Key? key,
  }) : super(key: key);

  @override
  State<Iso01> createState() => _Iso01State();
}

class _Iso01State extends State<Iso01> with SingleTickerProviderStateMixin {
  Color top = const Color(0xFF2FE7C5);
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
        child: IsometricTile(
          top: top,
          left: const Color(0xFF925538),
          right: const Color(0xFFEB885A),
        ),
      ),
    );
  }
}
