import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_puzzle_hack/models/puzzle.dart';

class GameGenerator {
  const GameGenerator();

  /// Generate a 15 puzzle game with the specified [seed].
  Puzzle generateForSeed(int seed) {
    final random = Random(seed);
    final tiles = List.generate(16, (index) => index);

    // We want to puzzle generated with a total moves between 40 and 80.
    final moves = random.nextInt(41) + 40;

    int lastIndex = 15;
    int emptyIndex = 15;
    for (int i = 0; i < moves; i++) {
      final possibilites = tiles.validNeighbors(emptyIndex, lastIndex).toList();

      final newIndex =
          possibilites.length == 1 ? 0 : random.nextInt(possibilites.length);

      tiles.swap(newIndex, emptyIndex);
      lastIndex = emptyIndex;
      emptyIndex = newIndex;
    }

    return Puzzle(columns: 4, rows: 4, tiles: tiles);
  }

  Puzzle generatorForDate(DateTime time) {
    final seed = time.millisecondsSinceEpoch;
    return generateForSeed(seed);
  }

  Puzzle generateForToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return generatorForDate(today);
  }
}

extension on List<int> {
  Iterable<int> validNeighbors(int emptyIndex, int lastIndex) sync* {
    final column = emptyIndex % 4;
    final row = emptyIndex ~/ 4;

    if (column - 1 > 0) {
      final n1 = indexOf(column - 1, row);
      if (n1 != lastIndex) {
        yield n1;
      }
    }

    if (column + 1 < 4) {
      final n2 = indexOf(column + 1, row);
      if (n2 != lastIndex) {
        yield n2;
      }
    }

    if (row - 1 > 0) {
      final n3 = indexOf(column, row - 1);
      if (n3 != lastIndex) {
        yield n3;
      }
    }

    if (row + 1 < 4) {
      final n4 = indexOf(column, row + 1);
      if (n4 != lastIndex) {
        yield n4;
      }
    }
  }

  int indexOf(int column, int row) {
    return row * 4 + column;
  }
}
