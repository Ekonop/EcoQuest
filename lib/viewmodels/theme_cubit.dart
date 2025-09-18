import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_quest/repositories/local_storage_service.dart';

class ThemeState {
  final ThemeMode mode;
  const ThemeState(this.mode);
}

class ThemeCubit extends Cubit<ThemeState> {
  final LocalStorageService _storage;
  ThemeCubit(this._storage) : super(const ThemeState(ThemeMode.system));

  Future<void> load() async {
    final stored = await _storage.getStoredThemeMode();
    if (stored == 'light') {
      emit(const ThemeState(ThemeMode.light));
    } else if (stored == 'dark') {
      emit(const ThemeState(ThemeMode.dark));
    } else {
      emit(const ThemeState(ThemeMode.system));
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    emit(ThemeState(mode));
    await _storage.setStoredThemeMode(mode);
  }
}
