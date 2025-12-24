import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anime_hub/business_logic/theme/theme_event.dart';
import 'package:anime_hub/business_logic/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'isDarkMode';

  ThemeBloc() : super(const ThemeDark()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(
    LoadTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    emit(isDark ? const ThemeDark() : const ThemeLight());
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state is ThemeDark;
    await prefs.setBool(_themeKey, !isDark);
    emit(isDark ? const ThemeLight() : const ThemeDark());
  }
}
