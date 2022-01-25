import 'package:flutter/material.dart';

class Tile with ChangeNotifier {
  Tile({
    required this.correctIndex,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final int correctIndex;

  int get currentIndex => _currentIndex;
  int _currentIndex;
  set currentIndex(int value) {
    if (_currentIndex != value) {
      _currentIndex = value;
      notifyListeners();
    }
  }

  bool get isCorrect => _currentIndex == correctIndex;

  @override
  String toString() {
    return 'value ($correctIndex) is at $currentIndex';
  }
}
