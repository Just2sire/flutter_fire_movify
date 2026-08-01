import "package:flutter/material.dart";
import "package:movify/data/repositories/index.dart";
import "package:movify/presentation/providers/app_dependencies.dart";

import "core/routing/router.dart";
import "core/theme/app_theme.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class MyApp extends StatelessWidget {
  const MyApp({required this.themeModeNotifier, super.key});

  final ValueNotifier<ThemeMode> themeModeNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          routerConfig: appRouter,
        );
      },
    );
  }
}
