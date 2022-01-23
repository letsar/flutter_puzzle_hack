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

class _Iso01State extends State<Iso01> {
  Color top = const Color(0xFF2FE7C5);

  @override
  Widget build(BuildContext context) {
    return CustomMouseRegion(
      onEnter: (_) {
        setState(() {
          top = const Color(0xFFA4F4E6);
        });
      },
      onExit: (_) {
        setState(() {
          top = const Color(0xFF2FE7C5);
        });
      },
      onHover: (_) {},
      child: IsometricTile(
        top: top,
        left: const Color(0xFF925538),
        right: const Color(0xFFEB885A),
      ),
    );
  }
}
