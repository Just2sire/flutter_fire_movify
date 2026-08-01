import "dart:async";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/extensions/int_extensions.dart";
import "package:movify/core/extensions/navigation_extensions.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/index.dart" show FavouriteMovie;
import "package:movify/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;

import "../providers/app_dependencies.dart";

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppDependencies.of(context).favouriteMovieRepository;

    return AppScaffold(
      body: Column(
        children: [
          const AppTopbar(title: "Mes favoris", showLeading: false),
          AppSpacing.gapVLg,
          Expanded(
            child: StreamBuilder<List<FavouriteMovie>>(
              stream: repo.watchFavourites(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Erreur: ${snapshot.error}"));
                }

                final favoriteMovies = snapshot.data ?? [];

                if (favoriteMovies.isEmpty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSpacing.giga,
                    children: [
                      Icon(
                        LucideIcons.packageOpen,
                        size: AppSpacing.yotta * 1.5,
                      ),
                      Center(child: Text("Aucun favoris")),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return MovieItem(
                      id: movie.id,
                      poster: movie.poster,
                      title: movie.title,
                      imdbRating: movie.imdbRating,
                      genre: movie.genre,
                      runtime: movie.runtime,
                      onUnselected: () async {
                        unawaited(repo.removeFavourite(movie.id));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  const MovieItem({
    super.key,
    required this.id,
    required this.poster,
    required this.title,
    required this.genre,
    required this.runtime,
    required this.imdbRating,
    this.onUnselected,
  });

  final String id;
  final String poster;
  final String title;
  final double imdbRating;
  final List<String> genre;
  final int runtime;
  final VoidCallback? onUnselected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isMobile = context.isMobile;
    return InkWell(
      onTap: () => context.goToMovieDetail(id),
      borderRadius: AppSpacing.roundedSm,
      child: Padding(
        padding: AppSpacing.insetSm,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Container(
                width: AppSpacing.tera * (isMobile ? 1.25 : 1.5),
                height: AppSpacing.yotta * (isMobile ? 1 : 1.125),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.6),
                  ),
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Image.network(
                  poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ColoredBox(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        LucideIcons.film,
                        size: AppSpacing.iconXxl,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .spaceBetween,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Icon(
                          LucideIcons.star,
                          color: colorScheme.tertiary,
                          size: AppSpacing.iconSm,
                        ),
                        Text(
                          "$imdbRating/10 IMDB",
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: genre
                          .take(2)
                          .map(
                            (item) => Chip(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: AppSpacing.insetXs,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppSpacing.roundedXxl,
                              ),
                              label: Text(item, style: textTheme.labelMedium),
                            ),
                          )
                          .toList(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        const Icon(
                          LucideIcons.history,
                          size: AppSpacing.iconSm,
                        ),
                        Text(
                          runtime.toFormattedDuration(),
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onUnselected,
                icon: const Icon(LucideIcons.x, size: AppSpacing.iconXl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
