import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:movify/data/repositories/favourite_movie_repository_impl.dart";
import "package:movify/data/repositories/movie_repository_impl.dart";
import "package:movify/data/repositories/theme_repository_impl.dart";
import "package:movify/data/repositories/user_repository_impl.dart";
import "package:movify/data/repositories/watchlist_movie_repository_impl.dart";
import "package:movify/presentation/pages/edit_profile_page.dart";
import "package:movify/presentation/providers/app_dependencies.dart";
import "package:movify/presentation/widgets/app_text_form_field.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("EditProfilePage renders 3 form fields and performs validation",
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

    await tester.pumpWidget(
      AppDependencies(
        favouriteMovieRepository: FavouriteMovieRepositoryImpl(),
        movieRepository: MovieRepositoryImpl(),
        watchlistMovieRepository: const WatchlistMovieRepositoryImpl(),
        userRepository: const UserRepositoryImpl(),
        themeRepository: const ThemeRepositoryImpl(),
        themeModeNotifier: themeModeNotifier,
        child: const MaterialApp(
          home: EditProfilePage(),
        ),
      ),
    );

    // Allow async load to complete
    await tester.pumpAndSettle();

    // Verify 3 distinct AppTextFormField widgets are present
    expect(find.byType(AppTextFormField), findsNWidgets(3));

    // Verify submit button is present
    expect(find.text("ENREGISTRER LES MODIFICATIONS"), findsOneWidget);
  });
}
