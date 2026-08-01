import "package:flutter/material.dart";
import "package:movify/domain/repositories/index.dart";

class AppDependencies extends InheritedWidget {
  const AppDependencies({
    required this.favouriteMovieRepository,
    required this.movieRepository,
    required this.watchlistMovieRepository,
    required this.userRepository,
    required this.themeRepository,
    required this.themeModeNotifier,
    super.key,
    required super.child,
  });

  final FavouriteMovieRepository favouriteMovieRepository;
  final MovieRepository movieRepository;
  final WatchlistMovieRepository watchlistMovieRepository;
  final UserRepository userRepository;
  final ThemeRepository themeRepository;
  final ValueNotifier<ThemeMode> themeModeNotifier;

  static AppDependencies of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(result != null, "Aucun AppDependencies trouvé dans le contexte");
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
