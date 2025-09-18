import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/repositories/local_storage_service.dart';

class ThemeState {
  final ThemeMode mode;
  final bool isLoading;
  final Object? error;
  const ThemeState(this.mode, {this.isLoading = false, this.error});

  ThemeState copyWith({ThemeMode? mode, bool? isLoading, Object? error}) =>
      ThemeState(mode ?? this.mode, isLoading: isLoading ?? this.isLoading, error: error);
}

class ThemeCubit extends Cubit<ThemeState> {
  final LocalStorageService _storage;
  ThemeCubit(this._storage)
      : super(ThemeState(
          // Use synchronous accessor if storage already initialized to avoid flash.
          _storage.isReady ? _storage.getInitialThemeMode() : ThemeMode.system,
          isLoading: false,
        ));

  Future<void> load() async {
    // Retained for backwards compatibility; asynchronous refresh not strictly needed now.
    try {
      if (!_storage.isReady) await _storage.init();
      final stored = await _storage.getStoredThemeMode();
      if (stored == 'light') emit(const ThemeState(ThemeMode.light));
      else if (stored == 'dark') emit(const ThemeState(ThemeMode.dark));
      else emit(const ThemeState(ThemeMode.system));
    } catch (e) {
      emit(ThemeState(state.mode, error: e));
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(ThemeState(mode));
    try {
      if (!_storage.isReady) {
        await _storage.init();
      }
      await _storage.setStoredThemeMode(mode);
    } catch (_) {
      // Swallow persistence errors; UI already reflects optimistic change.
    }
  }
}
