import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/widgets/puzzle_board/puzzle_tile_position.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/render_widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_puzzle_board/widget_puzzle_board.dart';
import 'package:flutter_puzzle_hack/widgets/widget_tile/widget_tile.dart';
import 'package:video_player/video_player.dart';

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
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ColoredBox(
            color: Colors.red,
            child: WidgetPuzzleBoard(
              rows: 2,
              columns: 2,
              columnSpacing: 4,
              link: link,
              source: const MyTemplateHomePage(),
              // source: const FlutterLogo(size: 300),
              // source: RepaintBoundary(
              //   child: Image.asset('assets/dash_avatars.png'),
              // ),

              // source: Image.asset('assets/dash_avatars.png'),
              // source: Image.asset('assets/dash_fainting.gif'),
              // source: VideoApp(),
              children: [
                PuzzleTilePosition(
                  column: 0,
                  row: 0,
                  child: WidgetTile(index: 2, link: link),
                ),
                PuzzleTilePosition(
                  column: 1,
                  row: 0,
                  child: WidgetTile(index: 1, link: link),
                ),
                PuzzleTilePosition(
                  column: 0,
                  row: 1,
                  child: WidgetTile(index: 3, link: link),
                ),
                PuzzleTilePosition(
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
      backgroundColor: Colors.transparent,
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
