import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeModeState { light, dark, system }

class ThemeModeNotifier extends StateNotifier<ThemeModeState> {
  ThemeModeNotifier() : super(ThemeModeState.system);

  void toggleTheme() {
    if (state == ThemeModeState.light) {
      state = ThemeModeState.dark;
    } else {
      state = ThemeModeState.light;
    }
  }

  void setTheme(ThemeModeState mode) {
    state = mode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeModeState>((ref) {
  return ThemeModeNotifier();
});
