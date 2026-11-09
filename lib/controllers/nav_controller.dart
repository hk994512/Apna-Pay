import 'package:flutter/material.dart';

class NavController {
  NavController._();
  static final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  static void switchTab(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }
}
