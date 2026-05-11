import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage_service.dart';

enum ThemeOption {
  light('light'),
  dark('dark'),
  system('system');

  final String value;
  const ThemeOption(this.value);

  static ThemeOption fromString(String str) {
    return ThemeOption.values.firstWhere(
      (e) => e.value == str,
      orElse: () => ThemeOption.system,
    );
  }
}

final themeOptionProvider =
    StateNotifierProvider<ThemeOptionController, ThemeOption>((ref) {
  return ThemeOptionController()..restore();
});

class ThemeOptionController extends StateNotifier<ThemeOption> {
  ThemeOptionController() : super(ThemeOption.system);

  final SecureStorageService _storage = SecureStorageService();
  static const String _themeOptionKey = 'theme_option';

  Future<void> restore() async {
    final saved = await _storage.readValue(_themeOptionKey);
    if (saved != null) {
      state = ThemeOption.fromString(saved);
    }
  }

  Future<void> setThemeOption(ThemeOption option) async {
    state = option;
    await _storage.saveValue(_themeOptionKey, option.value);
  }

  ThemeMode getThemeMode(Brightness deviceBrightness) {
    switch (state) {
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
      case ThemeOption.system:
        return deviceBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light;
    }
  }
}
