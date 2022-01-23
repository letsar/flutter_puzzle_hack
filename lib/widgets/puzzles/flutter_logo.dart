import 'package:flutter/material.dart';

class FlutterLogoPuzzle extends StatefulWidget {
  const FlutterLogoPuzzle({
    Key? key,
  }) : super(key: key);

  @override
  State<FlutterLogoPuzzle> createState() => _FlutterLogoPuzzleState();
}

class _FlutterLogoPuzzleState extends State<FlutterLogoPuzzle>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(vsync: this)
    ..repeat(reverse: false, period: const Duration(seconds: 4));

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.amber,
      child: SizedBox.expand(
        child: RotationTransition(
          turns: controller,
          child: const Padding(
            padding: EdgeInsets.all(32.0),
            child: FlutterLogo(),
          ),
        ),
      ),
    );
  }
}
