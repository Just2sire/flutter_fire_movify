import "package:flutter/material.dart";
import "package:movify/data/services/local_storage_service.dart";
import "package:movify/domain/repositories/theme_repository.dart";

class ThemeRepositoryImpl implements ThemeRepository {
  const ThemeRepositoryImpl();

  @override
  Future<ThemeMode> getThemeMode() async {
    final modeString = await SharedPrefsService.getThemeMode;
    if (modeString == ThemeMode.light.name) return ThemeMode.light;
    if (modeString == ThemeMode.dark.name) return ThemeMode.dark;
    return ThemeMode.system;
  }

  @override
  Future<bool> saveThemeMode(ThemeMode themeMode) {
    return SharedPrefsService.saveThemeMode(themeMode.name);
  }
}
