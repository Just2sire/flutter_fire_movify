import "package:flutter/material.dart";

abstract class ThemeRepository {
  Future<ThemeMode> getThemeMode();
  Future<bool> saveThemeMode(ThemeMode themeMode);
}
