import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// A lazily-initialized singleton wrapper around [SharedPreferences].
/// Call `await LocalStorageService.instance.init()` before runApp so that
/// subsequent synchronous getters are safe. Methods still return Futures
/// for flexibility but internally reuse the cached instance to avoid
/// repeated async factory calls and potential race conditions during
/// early provider/cubit creation.
class LocalStorageService {
  LocalStorageService._internal();
  static final LocalStorageService instance = LocalStorageService._internal();

  /// Factory constructor so calling `LocalStorageService()` anywhere returns
  /// the same lazily-initialized singleton instance. This keeps prior code
  /// that instantiated the class directly working without needing a refactor.
  factory LocalStorageService() => instance;

  SharedPreferences? _prefs;
  bool get isReady => _prefs != null;

  static const _onboardingKey = 'has_seen_onboarding';
  static const _lastTabKey = 'last_selected_tab';
  static const _themeModeKey = 'theme_mode'; // system|light|dark

  Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  SharedPreferences get _ensurePrefs {
    final p = _prefs;
    if (p == null) {
      throw StateError('LocalStorageService used before init()');
    }
    return p;
  }

  // Onboarding
  Future<bool> hasSeenOnboarding() async {
    return _ensurePrefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding() async {
    await _ensurePrefs.setBool(_onboardingKey, true);
  }

  // Last selected tab
  Future<int> getLastSelectedTab() async {
    return _ensurePrefs.getInt(_lastTabKey) ?? 0;
  }

  Future<void> setLastSelectedTab(int index) async {
    await _ensurePrefs.setInt(_lastTabKey, index);
  }

  // Theme mode
  Future<String?> getStoredThemeMode() async {
    return _ensurePrefs.getString(_themeModeKey);
  }

  Future<void> setStoredThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system'
    };
    await _ensurePrefs.setString(_themeModeKey, value);
  }

  /// Synchronous accessor used after an ensured init() call to get the
  /// stored theme mode without an additional Future, enabling the app
  /// to derive initial ThemeMode without a loading flash.
  ThemeMode getInitialThemeMode() {
    final raw = _ensurePrefs.getString(_themeModeKey);
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Test utility: clear stored theme to reset state between widget tests.
  Future<void> clearThemeModeForTest() async {
    await _ensurePrefs.remove(_themeModeKey);
  }
}
