import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:movify/data/repositories/theme_repository_impl.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("ThemeRepositoryImpl tests", () {
    test("saves and loads ThemeMode correctly", () async {
      SharedPreferences.setMockInitialValues({});
      const repo = ThemeRepositoryImpl();

      // Default should be system or light
      final initialMode = await repo.getThemeMode();
      expect(initialMode, isA<ThemeMode>());

      // Save dark mode
      await repo.saveThemeMode(ThemeMode.dark);
      final darkSaved = await repo.getThemeMode();
      expect(darkSaved, equals(ThemeMode.dark));

      // Save light mode
      await repo.saveThemeMode(ThemeMode.light);
      final lightSaved = await repo.getThemeMode();
      expect(lightSaved, equals(ThemeMode.light));
    });
  });
}
