import "package:flutter/material.dart";
import "package:movify/data/repositories/index.dart";
import "package:movify/presentation/providers/app_dependencies.dart";

import "core/routing/router.dart";
import "core/theme/app_theme.dart";

/// Point d'entrée principal de l'application Movify.
/// Initialise la persistance locale du thème (Thème Clair / Thème Sombre),
/// configure l'injection de dépendances (`AppDependencies`) et lance `MyApp`.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chargement du thème sauvegardé localement via SharedPreferences
  const themeRepo = ThemeRepositoryImpl();
  final initialThemeMode = await themeRepo.getThemeMode();
  final themeModeNotifier = ValueNotifier<ThemeMode>(initialThemeMode);

  runApp(
    AppDependencies(
      favouriteMovieRepository: FavouriteMovieRepositoryImpl(),
      movieRepository: MovieRepositoryImpl(),
      watchlistMovieRepository: const WatchlistMovieRepositoryImpl(),
      userRepository: const UserRepositoryImpl(),
      themeRepository: themeRepo,
      themeModeNotifier: themeModeNotifier,
      child: MyApp(themeModeNotifier: themeModeNotifier),
    ),
  );
}

/// Widget racine de l'application gérant la réactivité du thème (Clair / Sombre)
/// et la navigation déclarative basée sur `go_router`.
class MyApp extends StatelessWidget {
  const MyApp({required this.themeModeNotifier, super.key});

  final ValueNotifier<ThemeMode> themeModeNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp.router(
          title: "Movify - Catalogue de Films",
          debugShowCheckedModeBanner: false,

          // Configuration obligatoire du thème Clair et Sombre
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,

          // Navigation déclarative via GoRouter
          routerConfig: appRouter,
        );
      },
    );
  }
}
