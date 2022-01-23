import 'package:flutter/widgets.dart';
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

class Iso01 extends StatelessWidget {
  const Iso01({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const IsometricTile(
      top: Color(0xFF2FE7C5),
      left: Color(0xFF925538),
      right: Color(0xFFEB885A),
    );
  }
}
