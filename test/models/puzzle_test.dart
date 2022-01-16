import 'package:flutter_puzzle_hack/models/puzzle.dart';
import 'package:flutter_test/flutter_test.dart';

// Same tests than https://github.com/VGVentures/slide_puzzle/blob/release/test/models/puzzle_test.dart
const unsolvable3x3 = Puzzle(
  columns: 3,
  rows: 3,
  tiles: [1, 0, 2, 3, 4, 5, 6, 7, 8],
);
const solvable3x3 = Puzzle(
  columns: 3,
  rows: 3,
  tiles: [0, 2, 3, 6, 1, 8, 4, 7, 5],
);
const unsolvable4x4 = Puzzle(
  columns: 4,
  rows: 4,
  tiles: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 13, 15],
);
const solvable2x2 = Puzzle(
  columns: 2,
  rows: 2,
  tiles: [3, 0, 2, 1],
);

void main() {
  group('Puzzle', () {
    group('getEmptyTileCurrentIndex()', () {
      test('returns correct empty tile index from 2x2 puzzle', () {
        expect(solvable2x2.getEmptyTileCurrentIndex(), equals(0));
      });

      test('returns correct empty tile index from 4x4 puzzle', () {
        expect(unsolvable4x4.getEmptyTileCurrentIndex(), equals(15));
      });

      test('returns correct empty tile index from solvable 3x3 puzzle', () {
        expect(solvable3x3.getEmptyTileCurrentIndex(), equals(5));
      });
    });

    group('numberOfCorrectTiles', () {
      test('returns 0 from 1x1 puzzle with only a empty tile', () {
        const puzzle = Puzzle(columns: 1, rows: 1, tiles: [0]);
        expect(puzzle.numberOfCorrectTiles(), equals(0));
      });

      test('returns 1 from 2x2 puzzle with 1 correct tile', () {
        expect(solvable2x2.numberOfCorrectTiles(), equals(1));
      });

      test('returns 6 from 3x3 puzzle with 6 correct tiles', () {
        expect(unsolvable3x3.numberOfCorrectTiles(), equals(6));
      });
    });

    group('isTileMoveable', () {
      test('returns true when tile is adjacent to empty', () {
        expect(solvable2x2.isTileMovable(2), isTrue);
      });

      test('returns false when tile is not adjacent to empty', () {
        expect(solvable2x2.isTileMovable(3), isFalse);
      });

      test('returns true when tile is in same row/column as empty', () {
        expect(unsolvable3x3.isTileMovable(2), isTrue);
      });

      test('returns false when tile is not in same row/column as empty', () {
        expect(unsolvable3x3.isTileMovable(0), isFalse);
      });
    });

    group('isSolvable', () {
      test('returns false when given an unsolvable 3x3 puzzle', () {
        expect(unsolvable3x3.isSolvable(), isFalse);
      });

      test('returns false when given an unsolvable 4x4 puzzle', () {
        expect(unsolvable4x4.isSolvable(), isFalse);
      });

      test('returns true when given a solvable 3x3 puzzle', () {
        expect(solvable3x3.isSolvable(), isTrue);
      });

      test('returns true when given a solvable 2x2 puzzle', () {
        expect(solvable2x2.isSolvable(), isTrue);
      });
    });

    group('computePermutations', () {
      test('returns 1 when there is 1 permutations', () {
        expect(unsolvable3x3.computeInversions(), equals(1));
      });

      test('returns 6 when there are 6 permutations', () {
        expect(solvable3x3.computeInversions(), equals(6));
      });

      test('returns 63 when there are 63 permutations', () {
        const puzzle = Puzzle(
          rows: 4,
          columns: 4,
          tiles: [12, 9, 10, 5, 4, 6, 3, 8, 0, 11, 13, 8, 2, 14, 1, 15],
        );

        final permutations = puzzle.computeInversions();
        expect(permutations, 59);
        expect(puzzle.isSolvable(), isFalse);
      });
    });

    group('moveTiles', () {
      test(
          'moves one tile that is adjacent to the empty, to the '
          'position of the empty tile', () {
        const newPuzzle = Puzzle(
          columns: 2,
          rows: 2,
          tiles: [0, 3, 2, 1],
        );
        expect(
          solvable2x2.moveTiles(1),
          newPuzzle,
        );
      });

      test(
          'moves multiple tiles that are in the same row/column as the '
          'empty tile', () {
        const newPuzzle = Puzzle(
          columns: 3,
          rows: 3,
          tiles: [1, 0, 8, 3, 4, 2, 6, 7, 5],
        );
        expect(
          unsolvable3x3.moveTiles(2),
          newPuzzle,
        );
      });
    });
  });
}
