import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/models/notifiers.dart';

extension BuildContextExtensions on BuildContext {
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
