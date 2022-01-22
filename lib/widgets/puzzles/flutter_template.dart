import 'package:flutter/material.dart';

class FlutterTemplatePuzzle extends StatefulWidget {
  const FlutterTemplatePuzzle({
    Key? key,
  }) : super(key: key);

  @override
  _FlutterTemplatePuzzleState createState() => _FlutterTemplatePuzzleState();
}

class _FlutterTemplatePuzzleState extends State<FlutterTemplatePuzzle> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
        Positioned(
          left: 24,
          bottom: 24,
          // child: FloatingActionButton(
          //   onPressed: _incrementCounter,
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ),
          child: GestureDetector(
            onLongPress: _incrementCounter,
            child: Container(
              color: Colors.amber,
              height: 40,
              width: 40,
            ),
          ),
          // child: TextButton(
          //   child: Text('Click Me'),
          //   onPressed: _incrementCounter,
          // ),
        ),
      ],
    );
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
