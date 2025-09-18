import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LocalStorageService {
  static const _onboardingKey = 'has_seen_onboarding';
  static const _lastTabKey = 'last_selected_tab';
  static const _themeModeKey = 'theme_mode'; // system|light|dark

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  Future<int> getLastSelectedTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastTabKey) ?? 0;
  }

  Future<void> setLastSelectedTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastTabKey, index);
  }

  Future<String?> getStoredThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  Future<void> setStoredThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system'
    };
    await prefs.setString(_themeModeKey, value);
  }
}
