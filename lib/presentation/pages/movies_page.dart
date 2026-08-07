import "dart:async";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/constants/app_keys.dart";
import "package:movify/core/extensions/index.dart";
import "package:movify/core/extensions/int_extensions.dart";
import "package:movify/core/theme/app_colors.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/index.dart"
    show Movie, MovieFilter, MovieSortBy, FavouriteMovie;
import "package:movify/presentation/widgets/app_icon_switcher.dart";
import "package:movify/presentation/widgets/index.dart"
    show
        AppOutlinedButton,
        AppScaffold,
        AppTextFormField,
        AppTopbar,
        FiltersBottomSheet;

import "../providers/app_dependencies.dart";

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late TextEditingController searchController;
  final List<FavouriteMovie> favoriteMovies = [];
  final List<Movie> filteredMovies = [];
  List<String> availableGenres = [];
  MovieFilter movieFilter = const MovieFilter();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initGenresAndMovies());
    });
  }

  Future<void> _initGenresAndMovies() async {
    try {
      final repo = AppDependencies.of(context).movieRepository;
      final allMovies = await repo.getAllMovies();
      final genresSet = <String>{};
      for (final m in allMovies) {
        genresSet.addAll(m.genre);
      }
      availableGenres = (genresSet.toList())..sort();
      await _loadMovies();
      await _loadFavoriteMovies();
    } catch (e) {
      debugPrint("Erreur initialisation films: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadMovies() async {
    setState(() => isLoading = true);
    try {
      final movies = await AppDependencies.of(context).movieRepository
          .getAllMovies(filter: movieFilter);
      if (!mounted) return;
      setState(() {
        filteredMovies
          ..clear()
          ..addAll(movies);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur chargement films filtrés: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadFavoriteMovies() async {
    try {
      final moviesInFavoris = await AppDependencies.of(context)
          .favouriteMovieRepository
          .getFavourites();
      favoriteMovies
        ..clear()
        ..addAll(moviesInFavoris);
    } catch (e) {
      debugPrint("Erreur chargement recommandations: $e");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters {
    return (movieFilter.genres != null && movieFilter.genres!.isNotEmpty) ||
        movieFilter.genre != null ||
        movieFilter.minYear != null ||
        movieFilter.maxYear != null ||
        movieFilter.minRating != null ||
        movieFilter.maxRating != null ||
        movieFilter.rated != null ||
        movieFilter.sortBy != null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isMobile = context.isMobile;

    final hasQuery =
        movieFilter.searchQuery != null && movieFilter.searchQuery!.isNotEmpty;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          const AppTopbar(showLeading: false, title: "Films"),
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: AppTextFormField(
                  contentPadding: AppSpacing.inputPaddingSm,
                  controller: searchController,
                  hintText: "Recherche par titre, réalisateur...",
                  textInputAction: TextInputAction.search,
                  onChanged: (query) {
                    final q = query?.trim();
                    setState(() {
                      movieFilter = MovieFilter(
                        searchQuery: q == null || q.isEmpty ? null : q,
                        genres: movieFilter.genres,
                        genre: movieFilter.genre,
                        minYear: movieFilter.minYear,
                        maxYear: movieFilter.maxYear,
                        minRating: movieFilter.minRating,
                        maxRating: movieFilter.maxRating,
                        rated: movieFilter.rated,
                        sortBy: movieFilter.sortBy,
                        sortOrder: movieFilter.sortOrder,
                      );
                    });
                    unawaited(_loadMovies());
                  },
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: IconButton(
                      onPressed: () => unawaited(_loadMovies()),
                      icon: const Icon(
                        LucideIcons.search,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ),
              ),
              Badge(
                textColor: colorScheme.tertiary,
                child: IconButton(
                  style: IconButton.styleFrom(
                    padding: AppSpacing.insetLg,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppSpacing.roundedLg,
                    ),
                    backgroundColor: _hasActiveFilters
                        ? colorScheme.primary
                        : colorScheme.primaryContainer,
                  ),
                  onPressed: () => unawaited(_openFilters()),
                  icon: Icon(
                    LucideIcons.filter,
                    color: _hasActiveFilters
                        ? colorScheme.onPrimary
                        : colorScheme.onPrimaryContainer,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ),
            ],
          ),
          if (_hasActiveFilters || hasQuery) ...[
            _ActiveFiltersRow(
              filter: movieFilter,
              onRemoveGenre: _removeGenreFilter,
              onRemoveRating: _removeRatingFilter,
              onRemoveYear: _removeYearFilter,
              onRemoveRated: _removeRatedFilter,
              onRemoveSort: _removeSortFilter,
              onClearAll: _clearAllFilters,
            ),
          ],
          AppSpacing.gapVXs,
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredMovies.isEmpty
                ? _EmptyMoviesState(onReset: _clearAllFilters)
                : GridView.builder(
                    itemCount: filteredMovies.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 2 : 3,
                      childAspectRatio: isMobile ? 0.65 : 0.85,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    itemBuilder: (context, index) {
                      final repo = AppDependencies.of(context)
                          .favouriteMovieRepository;
                      final movie = filteredMovies[index];
                      final isFavorite = favoriteMovies.any(
                        (fav) => fav.id == movie.id,
                      );
                      return MovieGridCard(
                        movie: movie,
                        onFavoriteToggle: () async {
                          await repo.toggleFavourite(movie.toFavouriteMovie());
                          await _loadFavoriteMovies();
                          if (mounted) setState(() {});
                        },
                        isFavorite: isFavorite,
                        // isFavorite: repo.isFavourite(movie.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilters() async {
    final updatedFilter = await showModalBottomSheet<MovieFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FiltersBottomSheet(
        initialFilter: movieFilter,
        availableGenres: availableGenres,
      ),
    );

    if (updatedFilter != null) {
      setState(() {
        movieFilter = updatedFilter;
      });
      await _loadMovies();
    }
  }

  void _clearAllFilters() {
    searchController.clear();
    setState(() {
      movieFilter = const MovieFilter();
    });
    unawaited(_loadMovies());
  }

  void _removeGenreFilter(String g) {
    final currentGenres = List<String>.from(movieFilter.genres ?? [])
      ..remove(g);
    setState(() {
      movieFilter = MovieFilter(
        searchQuery: movieFilter.searchQuery,
        genres: currentGenres.isEmpty ? null : currentGenres,
        minYear: movieFilter.minYear,
        maxYear: movieFilter.maxYear,
        minRating: movieFilter.minRating,
        maxRating: movieFilter.maxRating,
        rated: movieFilter.rated,
        sortBy: movieFilter.sortBy,
        sortOrder: movieFilter.sortOrder,
      );
    });
    unawaited(_loadMovies());
  }

  void _removeRatingFilter() {
    setState(() {
      movieFilter = MovieFilter(
        searchQuery: movieFilter.searchQuery,
        genres: movieFilter.genres,
        genre: movieFilter.genre,
        minYear: movieFilter.minYear,
        maxYear: movieFilter.maxYear,
        rated: movieFilter.rated,
        sortBy: movieFilter.sortBy,
        sortOrder: movieFilter.sortOrder,
      );
    });
    unawaited(_loadMovies());
  }

  void _removeYearFilter() {
    setState(() {
      movieFilter = MovieFilter(
        searchQuery: movieFilter.searchQuery,
        genres: movieFilter.genres,
        genre: movieFilter.genre,
        minRating: movieFilter.minRating,
        maxRating: movieFilter.maxRating,
        rated: movieFilter.rated,
        sortBy: movieFilter.sortBy,
        sortOrder: movieFilter.sortOrder,
      );
    });
    unawaited(_loadMovies());
  }

  void _removeRatedFilter() {
    setState(() {
      movieFilter = MovieFilter(
        searchQuery: movieFilter.searchQuery,
        genres: movieFilter.genres,
        genre: movieFilter.genre,
        minYear: movieFilter.minYear,
        maxYear: movieFilter.maxYear,
        minRating: movieFilter.minRating,
        maxRating: movieFilter.maxRating,
        sortBy: movieFilter.sortBy,
        sortOrder: movieFilter.sortOrder,
      );
    });
    unawaited(_loadMovies());
  }

  void _removeSortFilter() {
    setState(() {
      movieFilter = MovieFilter(
        searchQuery: movieFilter.searchQuery,
        genres: movieFilter.genres,
        genre: movieFilter.genre,
        minYear: movieFilter.minYear,
        maxYear: movieFilter.maxYear,
        minRating: movieFilter.minRating,
        maxRating: movieFilter.maxRating,
        rated: movieFilter.rated,
      );
    });
    unawaited(_loadMovies());
  }
}

class _ActiveFiltersRow extends StatelessWidget {
  const _ActiveFiltersRow({
    required this.filter,
    required this.onRemoveGenre,
    required this.onRemoveRating,
    required this.onRemoveYear,
    required this.onRemoveRated,
    required this.onRemoveSort,
    required this.onClearAll,
  });

  final MovieFilter filter;
  final ValueChanged<String> onRemoveGenre;
  final VoidCallback onRemoveRating;
  final VoidCallback onRemoveYear;
  final VoidCallback onRemoveRated;
  final VoidCallback onRemoveSort;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final chips = <Widget>[];

    if (filter.genres != null) {
      for (final g in filter.genres!) {
        chips.add(
          InputChip(
            label: Text("Genre: $g", style: textTheme.labelMedium),
            onDeleted: () => onRemoveGenre(g),
            deleteIconColor: colorScheme.onSurfaceVariant,
          ),
        );
      }
    }

    if (filter.minRating != null || filter.maxRating != null) {
      final minR = filter.minRating ?? 0.0;
      final maxR = filter.maxRating ?? 10.0;
      chips.add(
        InputChip(
          label: Text(
            "Note: ${minR.toStringAsFixed(1)}-${maxR.toStringAsFixed(1)}",
            style: textTheme.labelMedium,
          ),
          onDeleted: onRemoveRating,
        ),
      );
    }

    if (filter.minYear != null || filter.maxYear != null) {
      final minY = filter.minYear ?? 1920;
      final maxY = filter.maxYear ?? 2026;
      chips.add(
        InputChip(
          label: Text("Années: $minY-$maxY", style: textTheme.labelMedium),
          onDeleted: onRemoveYear,
        ),
      );
    }

    if (filter.rated != null) {
      chips.add(
        InputChip(
          label: Text(
            "Public: ${filter.rated!.code}",
            style: textTheme.labelMedium,
          ),
          onDeleted: onRemoveRated,
        ),
      );
    }

    if (filter.sortBy != null) {
      chips.add(
        InputChip(
          label: Text(
            "Tri: ${_getSortLabel(filter.sortBy!)}",
            style: textTheme.labelMedium,
          ),
          onDeleted: onRemoveSort,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          ...chips,
          TextButton(
            onPressed: onClearAll,
            child: Text("Réinitialiser", style: textTheme.labelMedium),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(MovieSortBy sortBy) {
    switch (sortBy) {
      case MovieSortBy.title:
        return "Titre";
      case MovieSortBy.year:
        return "Année";
      case MovieSortBy.imdbRating:
        return "Note IMDb";
      case MovieSortBy.runtime:
        return "Durée";
      case MovieSortBy.boxOffice:
        return "Box Office";
      case MovieSortBy.releasedDate:
        return "Date de sortie";
    }
  }
}

class MovieGridCard extends StatelessWidget {
  const MovieGridCard({
    required this.isFavorite,
    super.key,
    required this.movie,
    this.onFavoriteToggle,
  });

  final Movie movie;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.goToMovieDetail(movie.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: AppKeys.movieImageHero,
                    child: Image.network(
                      movie.poster,
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
                  Positioned(
                    top: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.75),
                        borderRadius: AppSpacing.roundedSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.star,
                            color: colorScheme.tertiary,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.xs / 2),
                          Text(
                            "${movie.imdbRating}",
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xs,
                    right: AppSpacing.xs,
                    child: AppIconSwitcher(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onFavoriteToggle,
                        icon: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                          size: AppSpacing.iconXl,
                          color: isFavorite ? colorScheme.tertiary : null,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.xs,
                    left: AppSpacing.xs,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.85,
                        ),
                        borderRadius: AppSpacing.roundedXs,
                      ),
                      child: Text(
                        movie.rated.code,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: AppSpacing.insetSm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${movie.year} • "
                          "${movie.runtime.toFormattedDuration()}",
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (movie.genre.isNotEmpty)
                      Text(
                        movie.genre.take(2).join(", "),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMoviesState extends StatelessWidget {
  const _EmptyMoviesState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: AppSpacing.insetLg,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.film,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            AppSpacing.gapVMd,
            Text(
              "Aucun film trouvé",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapVXs,
            Text(
              "Essayez de modifier ou de réinitialiser "
              "vos filtres de recherche.",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapVMd,
            AppOutlinedButton(
              onPressed: onReset,
              text: "Réinitialiser les filtres",
            ),
          ],
        ),
      ),
    );
  }
}
