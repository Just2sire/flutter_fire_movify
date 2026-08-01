import "movie_rating.dart";

enum MovieSortBy {
  title,
  year,
  imdbRating,
  runtime,
  boxOffice,
  releasedDate,
}

enum SortOrder {
  ascending,
  descending,
}

class MovieFilter {
  const MovieFilter({
    this.searchQuery,
    this.genre,
    this.genres,
    this.minYear,
    this.maxYear,
    this.minRating,
    this.maxRating,
    this.rated,
    this.sortBy,
    this.sortOrder = SortOrder.ascending,
  });

  final String? searchQuery;
  final String? genre;
  final List<String>? genres;
  final int? minYear;
  final int? maxYear;
  final double? minRating;
  final double? maxRating;
  final MovieRating? rated;
  final MovieSortBy? sortBy;
  final SortOrder sortOrder;

  MovieFilter copyWith({
    String? searchQuery,
    String? genre,
    List<String>? genres,
    int? minYear,
    int? maxYear,
    double? minRating,
    double? maxRating,
    MovieRating? rated,
    MovieSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return MovieFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      genre: genre ?? this.genre,
      genres: genres ?? this.genres,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      rated: rated ?? this.rated,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
