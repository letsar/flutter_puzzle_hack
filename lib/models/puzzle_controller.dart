import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_puzzle_hack/models/puzzle.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';

class PuzzleController extends ChangeNotifier {
  PuzzleController({
    required int columns,
    required int rows,
  }) : this.fromPuzzle(
          puzzle: Puzzle(
            columns: columns,
            rows: rows,
            tiles: List.generate(columns * rows, (index) => index),
          ),
        );

  PuzzleController.fromPuzzle({
    required Puzzle puzzle,
  })  : _puzzle = puzzle,
        isSolved = ValueNotifier<bool>(puzzle.isComplete()),
        tilesLeft = ValueNotifier<int>(puzzle.tilesLeft),
        moveCount = ValueNotifier<int>(0),
        tiles = _createTiles(puzzle.tiles),
        columns = ValueNotifier<int>(puzzle.columns),
        rows = ValueNotifier<int>(puzzle.rows),
        _random = Random() {
    columns.addListener(_handleDimensionsChanged);
    rows.addListener(_handleDimensionsChanged);
  }

  final Random _random;

  Puzzle _puzzle;
  Puzzle get puzzle => _puzzle;

  final List<Tile> tiles;
  final ValueNotifier<bool> isSolved;
  final ValueNotifier<int> tilesLeft;
  final ValueNotifier<int> moveCount;
  final ValueNotifier<int> columns;
  final ValueNotifier<int> rows;

  void _handleDimensionsChanged() {
    final length = tiles.length;
    final count = columns.value * rows.value;
    if (count < length) {
      tiles.length = count;
    } else if (count > length) {
      tiles.addAll(
        List.generate(
          count - length,
          (index) => Tile(
            correctIndex: index + length,
            currentIndex: index + length,
          ),
        ),
      );
    }
    shuffle();
    notifyListeners();
  }

  bool isEmptyTile(Tile tile) {
    return puzzle.emptyTileCorrectIndex == tile.correctIndex;
  }

  bool isTileMovable(Tile tile) {
    return !_puzzle.isComplete() && _puzzle.isTileMovable(tile.currentIndex);
  }

  double columnOf(Tile tile) {
    return _puzzle.columnOf(tile.currentIndex).toDouble();
  }

  double rowOf(Tile tile) {
    return _puzzle.rowOf(tile.currentIndex).toDouble();
  }

  void moveTiles(Tile tile) {
    _puzzle = _puzzle.moveTiles(tile.currentIndex);
    update();
  }

  void updateState() {
    isSolved.value = _puzzle.isComplete();
    tilesLeft.value = _puzzle.tilesLeft;
    moveCount.value++;
  }

  void shuffle() {
    final rows = this.rows.value;
    final columns = this.columns.value;
    final count = rows * columns;
    final tiles = List.generate(count, (index) => index);
    Puzzle newPuzzle;
    do {
      tiles.shuffle(_random);
      newPuzzle = Puzzle(
        columns: columns,
        rows: rows,
        tiles: tiles,
      );
    } while (
        newPuzzle.getEmptyTileCurrentIndex() > 1 || !newPuzzle.isSolvable());

    _puzzle = newPuzzle;
    moveCount.value = -1;
    update();
  }

  void update() {
    _updateTiles(tiles, _puzzle.tiles);
    updateState();
  }
}

extension on Puzzle {
  int get tilesLeft => tiles.length - numberOfCorrectTiles() - 1;
}

List<Tile> _createTiles(List<int> indexes) {
  final tiles = List.generate(
    indexes.length,
    (index) => Tile(
      correctIndex: index,
      currentIndex: index,
    ),
  );
  _updateTiles(tiles, indexes);
  return tiles;
}

void _updateTiles(List<Tile> tiles, List<int> indexes) {
  for (int i = 0; i < indexes.length; i++) {
    final tileIndex = indexes[i];
    final tile = tiles[tileIndex];
    tile.currentIndex = i;
  }
}
