import 'package:flutter/material.dart';

class UnreadCountProvider with ChangeNotifier {
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void decrement() {
    _unreadCount--;
    notifyListeners();
  }

  void reset() {
    _unreadCount = 0;
    notifyListeners();
  }

  void setCount(int count) {
    _unreadCount = count;
    notifyListeners();
  }
}

class AppBarState with ChangeNotifier {
  bool _isScrolled = false;

  bool get isScrolled => _isScrolled;

  void setScrolled(bool scrolled) {
    if (_isScrolled != scrolled) {
      _isScrolled = scrolled;
      notifyListeners();
    }
  }
}
