import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';

class NumberOfMovesPuzzle extends StatelessWidget {
  const NumberOfMovesPuzzle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watchValue<PuzzleController>();
    final ColorTween colorTween = ColorTween(
      begin: Colors.green,
      end: Colors.red,
    );
    return ValueListenableBuilder<int>(
      valueListenable: controller.moveCount,
      builder: (context, numberOfMoves, child) {
        final color = colorTween.lerp(numberOfMoves.clamp(0, 50) / 50)!;
        return SizedBox.expand(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: ElasticOutCurve(1),
            color: color,
            child: FittedBox(
              child: TweenAnimationBuilder<double>(
                key: UniqueKey(),
                tween: Tween<double>(begin: 4, end: 1),
                duration: Duration(milliseconds: 300),
                curve: ElasticOutCurve(1),
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Text(
                  '$numberOfMoves',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
