import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';
import 'package:flutter_puzzle_hack/models/tile.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/image_sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/sliding_puzzle.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/widget_puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/widgets/widget_tile/widget_tile.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyWidgetApp());
}

class MyWidgetApp extends StatefulWidget {
  const MyWidgetApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyWidgetApp> createState() => _MyWidgetAppState();
}

class _MyWidgetAppState extends State<MyWidgetApp> {
  final link = WidgetPuzzleBoardLink();

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: Scaffold(
    //       body: Center(
    //     child: SizedBox(
    //         height: 500, width: 200, child: const MyTemplateHomePage()),
    //   )),
    // );

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ColoredBox(
            color: Colors.red,
            child: WidgetPuzzleBoard(
              rows: 2,
              columns: 2,
              columnSpacing: 0,
              link: link,
              // source: RepaintBoundary(
              //   child: const MyTemplateHomePage(),
              // ),
              // source: RepaintBoundary(
              //   child: Image.asset('assets/dash_avatars.png'),
              // ),

              source: Image.asset('assets/dash_avatars.png'),
              // source: Image.asset('assets/dash_fainting.gif'),
              // source: VideoApp(),
              children: [
                WidgetPuzzleTilePosition(
                  column: 0,
                  row: 0,
                  child: WidgetTile(index: 2, link: link),
                ),
                WidgetPuzzleTilePosition(
                  column: 1,
                  row: 0,
                  child: WidgetTile(index: 1, link: link),
                ),
                WidgetPuzzleTilePosition(
                  column: 0,
                  row: 1,
                  child: WidgetTile(index: 3, link: link),
                ),
                WidgetPuzzleTilePosition(
                  column: 1,
                  row: 1,
                  child: WidgetTile(index: 0, link: link),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

// class ImageApp extends StatelessWidget {
//   const ImageApp({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         body: Center(
//           child: ImageMaker(
//             isAnimated: true,
//             size: const Size(300, 300),
//             source: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//             // source: Directionality(
//             //   textDirection: TextDirection.ltr,
//             //   child: Text(
//             //     'hello',
//             //     style: TextStyle(fontSize: 20).copyWith(color: Colors.black),
//             //   ),
//             // ),
//             builder: (context, image, child) {
//               return RawImageSlidingPuzzle(
//                 image: image,
//                 configuration: configuration,
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ImagePainter extends CustomPainter {
//   const ImagePainter({
//     required this.image,
//   });

//   final ui.Image image;

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawImage(
//       image,
//       Offset.zero,
//       Paint()
//         ..filterQuality = FilterQuality.high
//         ..isAntiAlias = true,
//     );
//   }

//   @override
//   bool shouldRepaint(ImagePainter oldDelegate) {
//     return oldDelegate.image != image;
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PuzzleController controller = PuzzleController(
    columns: 3,
    rows: 3,
  )..shuffle();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ValueProvider(
        value: controller,
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Hack Challenge'),
      ),
      body: Center(
        child: Column(
          children: [
            const NumberOfMoves(),
            const TilesLeft(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      final puzzle = controller.puzzle;

                      return SlidingPuzzle(
                        configuration: SlidingPuzzleConfiguration(
                          columns: puzzle.columns,
                          rows: puzzle.rows,
                          columnSpacing: 2,
                          tiles: controller.tiles,
                          tileBuilder: (context, tile, child) {
                            return AnimatedTile(
                              tile: tile,
                              child: child,
                            );
                          },
                        ),
                        delegate: const ImageSlidingPuzzleDelegate(
                          imagePath: 'assets/dash_fainting.gif',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SuffleButton(),
          ],
        ),
      ),
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

class SuffleButton extends StatelessWidget {
  const SuffleButton({
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

class AnimatedTile extends StatelessWidget {
  const AnimatedTile({
    Key? key,
    required this.tile,
    required this.child,
  }) : super(key: key);

  final Tile tile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    final effectiveChild = controller.isEmptyTile(tile)
        ? PuzzleEmptyTile(
            tile: tile,
            child: child,
          )
        : child;

    return AnimatedBuilder(
      animation: tile,
      builder: (context, child) {
        return PuzzleTile(
          tile: tile,
          child: child!,
        );
      },
      child: effectiveChild,
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

class PuzzleEmptyTile extends StatelessWidget {
  const PuzzleEmptyTile({
    Key? key,
    required this.tile,
    required this.child,
  }) : super(key: key);

  final Tile tile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();

    return ValueListenableBuilder<bool>(
      valueListenable: controller.isSolved,
      builder: (context, isSolved, child) {
        return AnimatedOpacity(
          opacity: isSolved ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: child,
        );
      },
      child: child,
    );
  }
}

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.child,
  }) : super(key: key);

  final Tile tile;
  final Widget child;

  @override
  State<PuzzleTile> createState() => _PuzzleTileState();
}

class _PuzzleTileState extends State<PuzzleTile> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();

    final column = controller.columnOf(widget.tile);
    final row = controller.rowOf(widget.tile);
    return AnimatedPuzzleTilePosition(
      column: column,
      row: row,
      duration: const Duration(milliseconds: 300),
      curve: const ElasticOutCurve(1),
      onEnd: handleAnimationEnded,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.isTileMovable(widget.tile)) {
              tapped = true;
              controller.moveTiles(widget.tile);
            }
          },
          child: widget.child,
        ),
      ),
    );
  }

  void handleAnimationEnded() {
    if (tapped) {
      tapped = false;
      // context.readValue<PuzzleController>().updateState();
    }
  }
}

class NotifierProvider<T extends Listenable> extends InheritedNotifier<T> {
  const NotifierProvider({
    Key? key,
    required Widget child,
    required T notifier,
  }) : super(
          key: key,
          notifier: notifier,
          child: child,
        );
}

class ValueProvider<T> extends InheritedWidget {
  const ValueProvider({
    Key? key,
    required this.value,
    required Widget child,
  }) : super(key: key, child: child);

  final T value;

  @override
  bool updateShouldNotify(ValueProvider oldWidget) => value != oldWidget.value;
}

extension on BuildContext {
  T watchValue<T>() {
    return watchExactType<ValueProvider<T>>().value!;
  }

  T readValue<T>() {
    return readExactType<ValueProvider<T>>().value!;
  }

  T watchNotifier<T extends Listenable>() {
    return watchExactType<NotifierProvider<T>>().notifier!;
  }

  T readNotifier<T extends Listenable>() {
    return readExactType<NotifierProvider<T>>().notifier!;
  }

  T watchExactType<T extends InheritedWidget>() {
    return dependOnInheritedWidgetOfExactType<T>()!;
  }

  T readExactType<T extends InheritedWidget>() {
    return getElementForInheritedWidgetOfExactType<T>()!.widget as T;
  }
}

class MyTemplateHomePage extends StatefulWidget {
  const MyTemplateHomePage({Key? key}) : super(key: key);

  @override
  State<MyTemplateHomePage> createState() => _MyTemplateHomePageState();
}

class _MyTemplateHomePageState extends State<MyTemplateHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
