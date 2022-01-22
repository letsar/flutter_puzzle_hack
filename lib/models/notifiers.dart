import 'package:flutter/widgets.dart';

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
