import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile.dart';
import 'package:flutter_puzzle_hack/widgets/puzzles/dash_fainting.dart';
import 'package:flutter_puzzle_hack/widgets/puzzles/flutter_logo.dart';
import 'package:flutter_puzzle_hack/widgets/puzzles/number_of_moves.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/widget_sliding_puzzle.dart';

class GameTypeController extends ChangeNotifier {
  GameTypeController({
    required this.puzzles,
  });

  final List<Widget> puzzles;

  int get gameType => _gameType;
  int _gameType = 0;
  set gameType(int value) {
    if (value != _gameType) {
      _gameType = value;
      notifyListeners();
    }
  }

  Widget get puzzle => puzzles[_gameType];
}

class PermutedWidgetPuzzle extends StatefulWidget {
  const PermutedWidgetPuzzle({
    Key? key,
  }) : super(key: key);

  @override
  State<PermutedWidgetPuzzle> createState() => _PermutedWidgetPuzzleState();
}

class _PermutedWidgetPuzzleState extends State<PermutedWidgetPuzzle> {
  final controller = PuzzleController(
    columns: 4,
    rows: 4,
  )..shuffle();

  final gameTypeController = GameTypeController(puzzles: const [
    FlutterLogoPuzzle(),
    NumberOfMovesPuzzle(),
    DashFaintingPuzzle(),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueProvider(
        value: controller,
        child: NotifierProvider(
          notifier: gameTypeController,
          child: const _Game(),
        ),
      ),
    );
  }
}

class _Game extends StatelessWidget {
  const _Game({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameTypeController = context.readNotifier<GameTypeController>();
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0,
                ),
                child: AnimatedBuilder(
                  animation: gameTypeController,
                  builder: (context, child) {
                    return _PuzzleBoard(
                      source: gameTypeController.puzzle,
                    );
                  },
                )),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: ElapsedTime(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ShuffleButton(),
                  ),
                  RowsSlider(),
                  ColumnsSlider(),
                  Expanded(child: PuzzleCarousel()),
                  const Expanded(
                    child: Center(
                      child: NumberOfMoves(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PuzzleBoard extends StatelessWidget {
  const _PuzzleBoard({
    Key? key,
    required this.source,
  }) : super(key: key);

  final Widget source;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final puzzle = controller.puzzle;

        return SlidingPuzzle(
          configuration: SlidingPuzzleConfiguration(
            columns: puzzle.columns,
            rows: puzzle.rows,
            columnSpacing: 4,
            tiles: controller.tiles,
            tileBuilder: (context, tile, child) {
              return AnimatedTile(
                tile: tile,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
              );
            },
          ),
          delegate: WidgetSlidingPuzzleDelegate(source: source),
        );
      },
    );
  }
}

class ChangingGame extends StatelessWidget {
  const ChangingGame({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return ValueListenableBuilder<int>(
      valueListenable: controller.moveCount,
      builder: (context, numberOfMoves, child) {
        return numberOfMoves.isEven
            ? const FlutterLogoPuzzle()
            : const NumberOfMovesPuzzle();
      },
    );
  }
}

class DimensionButton extends StatelessWidget {
  const DimensionButton({
    Key? key,
    this.min = 2,
    this.max = 8,
    required this.valueNotifier,
    required this.direction,
  })  : assert(min < max),
        super(key: key);

  final int min;
  final int max;
  final ValueNotifier<int> valueNotifier;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Flex(
          direction: direction,
          children: [
            TextButton(
              onPressed: value > min ? () => valueNotifier.value-- : null,
              child: Text('-'),
            ),
            Expanded(
              child: Center(child: Text('$value')),
            ),
            TextButton(
              onPressed: value < max ? () => valueNotifier.value++ : null,
              child: Text('+'),
            ),
          ],
        );
      },
    );
  }
}

class DimensionSlider extends StatelessWidget {
  const DimensionSlider({
    Key? key,
    this.min = 2,
    this.max = 8,
    required this.valueNotifier,
  }) : super(key: key);

  final int min;
  final int max;
  final ValueNotifier<int> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Slider(
          min: min.toDouble(),
          max: max.toDouble(),
          value: value.toDouble(),
          label: '$value',
          onChanged: (value) {
            valueNotifier.value = value.toInt();
          },
          divisions: max - min,
        );
      },
    );
  }
}

class RowsSlider extends StatelessWidget {
  const RowsSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleController = context.watchValue<PuzzleController>();

    return Column(
      children: [
        const Text('Rows'),
        DimensionSlider(valueNotifier: puzzleController.rows),
      ],
    );
  }
}

class ColumnsSlider extends StatelessWidget {
  const ColumnsSlider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final puzzleController = context.watchValue<PuzzleController>();

    return Column(
      children: [
        const Text('Columns'),
        DimensionSlider(valueNotifier: puzzleController.columns),
      ],
    );
  }
}

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: const Text('Shuffle'),
      onPressed: () {
        context.readValue<PuzzleController>().shuffle();
      },
    );
  }
}

class NumberOfMoves extends StatelessWidget {
  const NumberOfMoves({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return ValueListenableBuilder<int>(
      valueListenable: controller.moveCount,
      builder: (context, numberOfMoves, child) {
        return Text(
          'Number of moves: $numberOfMoves',
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}

class ElapsedTime extends StatelessWidget {
  const ElapsedTime({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    final timer = controller.timer;
    return AnimatedBuilder(
      animation: timer,
      builder: (context, child) {
        return Text(
          'Elapsed seconds: ${timer.seconds}',
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}

class TilesLeft extends StatelessWidget {
  const TilesLeft({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return ValueListenableBuilder<int>(
      valueListenable: controller.tilesLeft,
      builder: (context, tilesLeft, child) {
        return Text(
          'Tiles left: $tilesLeft',
          style: Theme.of(context).textTheme.headline6,
        );
      },
    );
  }
}

class PuzzleCarousel extends StatefulWidget {
  const PuzzleCarousel({
    Key? key,
  }) : super(key: key);

  @override
  State<PuzzleCarousel> createState() => _PuzzleCarouselState();
}

class _PuzzleCarouselState extends State<PuzzleCarousel> {
  final pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.5,
  );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameTypeController = context.watchNotifier<GameTypeController>();
    print('GameType: ${gameTypeController.gameType}');
    return PageView(
      controller: pageController,
      children: [
        ...gameTypeController.puzzles.map(
          (child) {
            return Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedPadding(
                  padding: child == gameTypeController.puzzle
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(8.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: IgnorePointer(
                    child: Center(
                      child: _PuzzleBoard(source: child),
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
      onPageChanged: (value) {
        gameTypeController.gameType = value;
      },
    );
  }
}
