import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/extensions/build_context.dart';
import 'package:flutter_puzzle_hack/models/puzzle_controller.dart';

class PuzzleControllerBuilder<T> extends StatelessWidget {
  const PuzzleControllerBuilder({
    Key? key,
    required this.selector,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<T> Function(PuzzleController) selector;
  final ValueWidgetBuilder<T> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final puzzleController = context.watchValue<PuzzleController>();

    return ValueListenableBuilder<T>(
      valueListenable: selector(puzzleController),
      builder: builder,
      child: child,
    );
  }
}
