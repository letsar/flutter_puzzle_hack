import 'package:flutter_puzzle_hack/models/puzzle.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';

class PuzzleController {
  PuzzleController({
    required Puzzle puzzle,
  })  : _puzzle = puzzle,
        tiles = _createTiles(puzzle.tiles);

  Puzzle _puzzle;
  Puzzle get puzzle => _puzzle;

  final List<Tile> tiles;

  bool isEmptyTile(Tile tile) {
    return puzzle.emptyTileCorrectIndex == tile.correctIndex;
  }

  bool isTileMovable(Tile tile) {
    return _puzzle.isTileMovable(tile.currentIndex);
  }

  double columnOf(Tile tile) {
    return _puzzle.columnOf(tile.currentIndex).toDouble();
  }

  double rowOf(Tile tile) {
    return _puzzle.rowOf(tile.currentIndex).toDouble();
  }

  void moveTiles(Tile tile) {
    _puzzle = _puzzle.moveTiles(tile.currentIndex);
    _updateTiles(tiles, _puzzle.tiles);
  }
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
