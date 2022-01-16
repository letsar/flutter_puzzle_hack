import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef Position = math.Point<int>;

@immutable
class Puzzle {
  const Puzzle({
    required this.columns,
    required this.rows,
    required this.tiles,
    int? emptyTileCorrectIndex,
  })  : assert(columns > 0),
        assert(rows > 0),
        emptyTileCorrectIndex = emptyTileCorrectIndex ?? (columns * rows - 1);

  final int columns;
  final int rows;
  final List<int> tiles;
  final int emptyTileCorrectIndex;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is! Puzzle) {
      return false;
    }

    final Puzzle otherPuzzle = other;
    return otherPuzzle.columns == columns &&
        otherPuzzle.rows == rows &&
        otherPuzzle.emptyTileCorrectIndex == emptyTileCorrectIndex &&
        otherPuzzle.tiles.length == tiles.length &&
        otherPuzzle.tiles.equals(tiles);
  }

  @override
  int get hashCode {
    return Object.hash(
      columns,
      rows,
      emptyTileCorrectIndex,
      hashList(tiles),
    );
  }

  /// Returns the number of tiles that are currently in their correct position.
  int numberOfCorrectTiles() {
    int correct = 0;
    for (int i = 0; i < tiles.length; i++) {
      final correctIndex = tiles[i];
      if (correctIndex != emptyTileCorrectIndex && correctIndex == i) {
        correct++;
      }
    }
    return correct;
  }

  bool isComplete() {
    final end = tiles.length - 1;
    for (int i = 0; i < end; i++) {
      if (tiles[i] != i) {
        return false;
      }
    }
    return true;
  }

  /// Returns true if the tile at the given [index] can be moved.
  bool isTileMovable(int index) {
    // A tile can be moved if it's in the same row or column than que the null
    // tile.
    final emptyTileIndex = getEmptyTileCurrentIndex();
    if (index == emptyTileIndex) {
      return false;
    }

    final emptyTileColumn = columnOf(emptyTileIndex);
    final emptyTileRow = rowOf(emptyTileIndex);

    final column = columnOf(index);
    final row = rowOf(index);

    return column == emptyTileColumn || row == emptyTileRow;
  }

  /// Move the tiles in the same row or column as the empty tile towards its
  /// position, starting at [index].
  ///
  /// [isTileMovable] must return true before calling this method.
  Puzzle moveTiles(int index) {
    final emptyTileIndex = getEmptyTileCurrentIndex();
    final newTiles = tiles.toList();

    final emptyTileColumn = columnOf(emptyTileIndex);
    final emptyTileRow = rowOf(emptyTileIndex);

    final column = columnOf(index);
    final row = rowOf(index);

    if (column == emptyTileColumn) {
      // We are moving the tiles in the same column as the empty tile.
      final delta = emptyTileRow - row;
      final increment = -delta.sign;
      final count = delta.abs();
      var c = emptyTileIndex;
      for (int i = 0; i < count; i++) {
        c = newTiles.swapTiles(c, c + increment * columns);
      }
    } else {
      // We are moving the tiles in the same row as the empty tile.
      final delta = emptyTileColumn - column;
      final increment = -delta.sign;
      final count = delta.abs();
      var c = emptyTileIndex;
      for (int i = 0; i < count; i++) {
        c = newTiles.swapTiles(c, c + increment);
      }
    }

    return Puzzle(
      columns: columns,
      rows: rows,
      tiles: newTiles,
      emptyTileCorrectIndex: emptyTileCorrectIndex,
    );
  }

  int getEmptyTileCurrentIndex() {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] == emptyTileCorrectIndex) {
        return i;
      }
    }
    return -1;
  }

  bool isSolvable() {
    final inversions = computeInversions();
    if (tiles.length.isOdd) {
      return inversions.isEven;
    } else {
      final emptyTileIndex = getEmptyTileCurrentIndex();
      final emptyTileRow = rowOf(emptyTileIndex);
      return (inversions + emptyTileRow).isOdd;
    }
  }

  @visibleForTesting
  int computeInversions() {
    int inversions = 0;
    for (int i = 0; i < tiles.length; i++) {
      final a = tiles[i];
      if (a == emptyTileCorrectIndex) {
        continue;
      }
      for (int j = i + 1; j < tiles.length; j++) {
        final b = tiles[j];
        if (b != emptyTileCorrectIndex && a > b) {
          inversions++;
        }
      }
    }
    return inversions;
  }

  int columnOf(int index) {
    return index % columns;
  }

  int rowOf(int index) {
    return index ~/ columns;
  }

  bool isEmptyTileIndex(int index) {
    return tiles[index] == emptyTileCorrectIndex;
  }

  @override
  String toString() {
    return 'Puzzle: [$rows x $columns]($emptyTileCorrectIndex) $tiles';
  }
}

extension on List<int> {
  int swapTiles(int from, int to) {
    swap(from, to);
    return to;
  }
}
