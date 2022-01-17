import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_puzzle_hack/models/puzzle.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';

class PuzzleController {
  PuzzleController({
    required Puzzle puzzle,
  })  : _puzzle = puzzle,
        isSolved = ValueNotifier<bool>(puzzle.isComplete()),
        tilesLeft = ValueNotifier<int>(puzzle.tilesLeft),
        moveCount = ValueNotifier<int>(0),
        tiles = _createTiles(puzzle.tiles),
        _random = Random();

  final Random _random;

  Puzzle _puzzle;
  Puzzle get puzzle => _puzzle;

  final List<Tile> tiles;
  final ValueNotifier<bool> isSolved;
  final ValueNotifier<int> tilesLeft;
  final ValueNotifier<int> moveCount;

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
    final tiles = List.generate(_puzzle.tiles.length, (index) => index);
    Puzzle newPuzzle;
    do {
      tiles.shuffle(_random);
      newPuzzle = Puzzle(
        columns: _puzzle.columns,
        rows: _puzzle.rows,
        tiles: tiles,
        emptyTileCorrectIndex: _puzzle.emptyTileCorrectIndex,
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
