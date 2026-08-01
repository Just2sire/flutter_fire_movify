import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/constants/app_keys.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/extensions/int_extensions.dart";
import "package:movify/core/theme/app_colors.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/movie.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppScaffold, AppElevatedButton;
import "package:url_launcher/url_launcher.dart";

import "../providers/app_dependencies.dart";

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({required this.movieId, super.key});

  final String movieId;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Movie movie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _ = await Future.wait([_loadMovie()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final repo = AppDependencies.of(context).watchlistMovieRepository;
    final isDarkMode = context.isDarkMode;
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: .expand,
                    children: [
                      Hero(
                        tag: AppKeys.movieImageHero,
                        child: _DetailHeaderImage(
                          image: Image.network(
                            movie.poster,
                            fit: .fitWidth,
                            alignment: .topCenter,
                            colorBlendMode: .darken,
                            color: AppColors.black.withValues(alpha: 0.01),
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
                      ),
                      Positioned(
                        top: AppSpacing.md,
                        left: AppSpacing.sm,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppSpacing.roundedLg,
                            ),
                            backgroundColor: AppColors.black.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            LucideIcons.arrowLeft400,
                            size: AppSpacing.iconXl,
                            color: AppColors.white,
                          ),
                          tooltip: "Retour",
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: AppSpacing.insetHMd,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Center(
                          child: Text(
                            movie.title,
                            textAlign: .center,
                            style: textTheme.headlineLarge!.copyWith(
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: AppSpacing.mega,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: .horizontal,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = movie.genre[index];
                                return Text(item);
                              },
                              separatorBuilder: (context, index) => Text(
                                " • ",
                                style: textTheme.titleLarge!.copyWith(
                                  color: colorScheme.tertiary,
                                ),
                              ),
                              itemCount: movie.genre.length,
                            ),
                          ),
                        ),
                        Row(
                          spacing: AppSpacing.sm,
                          children: [
                            Expanded(
                              child: ListTile(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppSpacing.roundedLg,
                                ),
                                tileColor: colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                                leading: Icon(
                                  LucideIcons.star,
                                  color: colorScheme.primary,
                                  size: AppSpacing.iconXl,
                                ),
                                title: Text(
                                  "Rang IMDB",
                                  style: textTheme.bodySmall,
                                ),
                                subtitle: Text(
                                  "${movie.imdbRating}/10",
                                  style: textTheme.titleSmall!.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: AppSpacing.roundedLg,
                                ),
                                tileColor: colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                                leading: Icon(
                                  LucideIcons.timer,
                                  color: colorScheme.primary,
                                  size: AppSpacing.iconXl,
                                ),
                                title: Text(
                                  "Durée",
                                  style: textTheme.bodySmall,
                                ),
                                subtitle: Text(
                                  movie.runtime.toFormattedDuration(),
                                  style: textTheme.titleSmall!.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapVSm,
                        Text("Synopsis", style: context.textTheme.titleMedium),
                        AppSpacing.gapVXs,
                        Text(
                          movie.plot,
                          style: textTheme.labelLarge!.copyWith(
                            color:
                                (isDarkMode ? AppColors.white : AppColors.black)
                                    .withValues(alpha: 0.7),
                          ),
                          maxLines: 4,
                          overflow: .ellipsis,
                        ),
                        AppSpacing.gapVSm,
                        Text("Acteurs:", style: context.textTheme.titleMedium),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: List.generate(movie.actors.length, (index) {
                            final item = movie.actors[index];
                            return Chip(
                              padding: EdgeInsets.zero,
                              label: Text(item, style: textTheme.labelMedium),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Row(
                    spacing: AppSpacing.md,
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          onPressed: () async {
                            final hasSucceed = await repo.addToWatchlist(
                              movie.toWatchlistMovie(),
                            );
                            if (!context.mounted) return;
                            context.showSnackBar(
                              hasSucceed
                                  ? "Film ajouté à votre Watchlist"
                                  : "Film retiré de votre Watchlist",
                            );
                          },
                          iconAlignment: .end,
                          icon: const Icon(
                            LucideIcons.history,
                            size: AppSpacing.iconLg,
                          ),
                          child: Text(
                            "Ajouter à la watchlist",
                            style: textTheme.titleMedium!.copyWith(
                              fontWeight: .w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: AppSpacing.insetMd,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSpacing.roundedLg,
                            side: BorderSide(
                              width: AppSpacing.borderWidthMedium,
                              color: colorScheme.primary,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          foregroundColor: isDarkMode
                              ? colorScheme.onSurface
                              : colorScheme.primary,
                        ),
                        onPressed: () async {
                          final url = Uri.parse(
                            "https://imdb.com/title/${movie.imdbId}",
                          );
                          await launchUrl(url);
                        },
                        icon: const Icon(
                          LucideIcons.externalLink,
                          size: AppSpacing.iconXl,
                        ),
                        tooltip: "Voir sur IMDB",
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _loadMovie() async {
    setState(() => isLoading = true);
    try {
      final singleMovie = await AppDependencies.of(context).movieRepository
          .getMovieById(widget.movieId);
      if (!mounted) return;
      setState(() {
        movie = singleMovie;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur chargement films filtrés: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }
}

class _DetailHeaderImage extends StatelessWidget {
  const _DetailHeaderImage({required this.image});

  final Widget image;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.black,
            Colors.transparent, // Devient progressivement transparent en bas
          ],
          // Ajuste 0.5 pour commencer le fondu plus ou moins haut
          stops: [0.0, 0.5, 1.0],
        ).createShader(rect);
      },
      // Conserve l'image uniquement là où le gradient est opaque
      blendMode: BlendMode.dstIn,
      child: image,
    );
  }
}
