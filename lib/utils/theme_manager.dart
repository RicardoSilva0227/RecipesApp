import 'package:flutter/material.dart';

class ThemeManager {
  // Initial theme is set to system mode.
  final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

  void toggleTheme() {
    if (themeNotifier.value == ThemeMode.light) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }
}

final themeManager = ThemeManager(); // Create a global instance of ThemeManager