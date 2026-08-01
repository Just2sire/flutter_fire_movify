import "package:movify/core/helpers/utils.dart";
import "package:movify/data/datasources/local_json_datasource.dart";
import "package:movify/data/models/movie_model.dart";
import "package:movify/domain/entities/movie.dart";
import "package:movify/domain/entities/movie_filter.dart";
import "package:movify/domain/repositories/movie_repository.dart";

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({LocalJsonDataSource? dataSource})
    : _dataSource = dataSource ?? LocalJsonDataSource.instance;

  final LocalJsonDataSource _dataSource;

  @override
  Future<List<Movie>> getAllMovies({MovieFilter? filter}) async {
    final listMap = await _dataSource.loadList("movies.json");
    var movies = listMap
        .map((map) => MovieModel.fromMap(map).toEntity())
        .toList();

    if (filter == null) return movies;

    // 1. Filtrage par recherche textuelle (titre, réalisateur, acteurs)
    final query = filter.searchQuery?.trim().toLowerCase();
    if (query != null && query.isNotEmpty) {
      movies = movies.where((m) {
        final titleMatch = m.title.toLowerCase().contains(query);
        final directorMatch = m.director.toLowerCase().contains(query);
        final actorMatch =
            m.actors.any((a) => a.toLowerCase().contains(query));
        return titleMatch || directorMatch || actorMatch;
      }).toList();
    }

    // 2. Filtrage par genre unique
    final genre = filter.genre?.trim().toLowerCase();
    if (genre != null && genre.isNotEmpty) {
      movies = movies.where((m) {
        return m.genre.any((g) => g.toLowerCase() == genre);
      }).toList();
    }

    // 3. Filtrage par genres multiples
    final genres = filter.genres;
    if (genres != null && genres.isNotEmpty) {
      final normalizedGenres = genres.map((g) => g.toLowerCase()).toSet();
      movies = movies.where((m) {
        return m.genre.any((g) => normalizedGenres.contains(g.toLowerCase()));
      }).toList();
    }

    // 4. Filtrage par année
    if (filter.minYear != null) {
      movies = movies.where((m) => m.year >= filter.minYear!).toList();
    }
    if (filter.maxYear != null) {
      movies = movies.where((m) => m.year <= filter.maxYear!).toList();
    }

    // 5. Filtrage par note IMDb
    if (filter.minRating != null) {
      movies = movies.where((m) => m.imdbRating >= filter.minRating!).toList();
    }
    if (filter.maxRating != null) {
      movies = movies.where((m) => m.imdbRating <= filter.maxRating!).toList();
    }

    // 6. Filtrage par classification (MovieRating)
    if (filter.rated != null) {
      movies = movies.where((m) => m.rated == filter.rated).toList();
    }

    // 7. Tri
    final sortBy = filter.sortBy;
    if (sortBy != null) {
      final isAsc = filter.sortOrder == SortOrder.ascending;
      movies.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case MovieSortBy.title:
            comparison =
                a.title.toLowerCase().compareTo(b.title.toLowerCase());
          case MovieSortBy.year:
            comparison = a.year.compareTo(b.year);
          case MovieSortBy.imdbRating:
            comparison = a.imdbRating.compareTo(b.imdbRating);
          case MovieSortBy.runtime:
            comparison = a.runtime.compareTo(b.runtime);
          case MovieSortBy.boxOffice:
            comparison = a.boxOffice.compareTo(b.boxOffice);
          case MovieSortBy.releasedDate:
            final aRel = a.released ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bRel = b.released ?? DateTime.fromMillisecondsSinceEpoch(0);
            comparison = aRel.compareTo(bRel);
        }
        return isAsc ? comparison : -comparison;
      });
    }

    return movies;
  }

  @override
  Future<List<Movie>> getMoviesById(List<String> ids) async {
    final allMovies = await getAllMovies();
    return allMovies.where((movie) => ids.contains(movie.id)).toList();
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final allMovies = await getAllMovies();
    return allMovies.firstWhere(
      (movie) => movie.id == id,
      orElse: () => throw Exception("Movie with id $id not found"),
    );
  }

  @override
  Future<List<Movie>> getMovieRecommandation({int length = 8}) async {
    final allMovies = await getAllMovies();
    return Utils.getRandomElements(allMovies, length);
  }
}
