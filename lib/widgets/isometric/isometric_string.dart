import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_board.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/isometric_tile.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile_position.dart';

const _charToIndexes = {
  '0': {1, 3, 5, 6, 8, 9, 11, 13},
  '1': {1, 3, 4, 7, 10, 12, 13, 14},
  '2': {0, 1, 5, 7, 9, 12, 13, 14},
  '3': {0, 1, 2, 5, 7, 8, 11, 12, 13, 14},
  '4': {0, 2, 3, 5, 6, 7, 8, 11, 14},
  '5': {0, 1, 2, 3, 6, 7, 8, 11, 12, 13},
  '6': {1, 2, 3, 6, 7, 8, 9, 11, 12, 13, 14},
  '7': {0, 1, 2, 5, 7, 9, 12},
  '8': {0, 1, 2, 3, 5, 6, 7, 8, 9, 11, 12, 13, 14},
  '9': {0, 1, 2, 3, 5, 6, 7, 8, 11, 12, 13, 14},
  ':': {4, 10},
};

class IsometricString extends StatelessWidget {
  const IsometricString({
    Key? key,
    required this.string,
    required this.duration,
    required this.curve,
    required this.topToBottom,
  }) : super(key: key);

  final String string;
  final Duration duration;
  final Curve curve;
  final bool topToBottom;

  @override
  Widget build(BuildContext context) {
    final columns = string.length * 4 - 1;
    const rows = 5;
    final x = columns + rows;
    return Container(
      color: Color(0xFF346577),
      child: AspectRatio(
        aspectRatio: (2 * x) / (2 + x),
        child: _RawIsometricString(
          columns: topToBottom ? columns : rows,
          rows: topToBottom ? rows : columns,
          string: string,
          duration: duration,
          curve: curve,
          topToBottom: topToBottom,
        ),
      ),
    );
  }
}

class _RawIsometricString extends StatelessWidget {
  const _RawIsometricString(
      {Key? key,
      required this.string,
      required this.duration,
      required this.curve,
      required this.topToBottom,
      required this.columns,
      required this.rows})
      : super(key: key);

  final String string;
  final Duration duration;
  final Curve curve;
  final bool topToBottom;
  final int columns;
  final int rows;

  @override
  Widget build(BuildContext context) {
    return IsometricBoard(
      columns: columns,
      rows: rows,
      children: _stringToTiles(),
    );
  }

  List<Widget> _stringToTiles() {
    final List<Widget> tiles = [];
    for (int i = 0; i < string.length; i++) {
      final extra = topToBottom ? 0 : (3 - (string.length - 1) * 4);
      if (i != 0) {
        final column = (i * 4 - 1).toDouble() + extra;
        tiles.addAll(
          List.generate(
            5,
            (index) => PuzzleTilePosition(
              column: topToBottom ? column : index.toDouble(),
              row: topToBottom ? index.toDouble() : columns - column,
              child: Voxel.off(
                duration: duration,
                curve: curve,
              ),
            ),
          ),
        );
      }
      final origin = i * 4 + extra;
      tiles.addAll(_charToTiles(string[i], origin));
    }
    return tiles;
  }

  Iterable<Widget> _charToTiles(String char, int origin) sync* {
    final indexes = _charToIndexes[char] ?? const {};
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < 3; c++) {
        final column = (origin + c).toDouble();
        final index = r * 3 + c;
        final isOn = indexes.contains(index);
        yield PuzzleTilePosition(
          column: topToBottom ? column : r.toDouble(),
          row: topToBottom ? r.toDouble() : columns - column,
          child: Voxel(
            isOn: isOn,
            duration: duration,
            curve: curve,
          ),
        );
      }
    }
  }
}

class Voxel extends ImplicitlyAnimatedWidget {
  const Voxel({
    Key? key,
    required this.isOn,
    required Duration duration,
    required Curve curve,
  }) : super(key: key, duration: duration, curve: curve);

  const Voxel.off({
    Key? key,
    required Duration duration,
    required Curve curve,
  }) : this(key: key, isOn: false, duration: duration, curve: curve);

  final bool isOn;

  @override
  AnimatedWidgetBaseState<Voxel> createState() => _VoxelState();
}

class _VoxelState extends AnimatedWidgetBaseState<Voxel> {
  Tween<double>? _heightFactor;
  Tween<double>? _opacity;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _heightFactor =
        visitor(_heightFactor, widget.isOn ? 1 : 0.5, (dynamic value) {
      return Tween<double>(begin: value as double);
    }) as Tween<double>?;

    _opacity = visitor(_opacity, widget.isOn ? 1 : 0, (dynamic value) {
      return Tween<double>(begin: value as double);
    }) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;

    return Opacity(
      opacity: _opacity!.evaluate(animation).clamp(0, 1),
      child: FractionallySizedBox(
        heightFactor: _heightFactor!.evaluate(animation),
        alignment: Alignment.bottomCenter,
        child: const IsometricTile(
          top: Color(0xFF8D6E63),
          right: Color(0xFF795548),
          left: Color(0xFF6D4C41),
        ),
      ),
    );
  }
}
