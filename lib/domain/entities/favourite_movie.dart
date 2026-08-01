import "package:flutter/foundation.dart";
import "package:movify/domain/entities/movie.dart";
import "package:movify/domain/entities/movie_rating.dart";

class FavouriteMovie {
  FavouriteMovie({
    required this.id,
    required this.title,
    required this.poster,
    required this.year,
    required this.rated,
    required this.runtime,
    required this.genre,
    required this.plot,
    required this.imdbRating,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory FavouriteMovie.fromMovie(Movie movie, {DateTime? addedAt}) {
    return FavouriteMovie(
      id: movie.id,
      title: movie.title,
      poster: movie.poster,
      year: movie.year,
      rated: movie.rated,
      runtime: movie.runtime,
      genre: movie.genre,
      plot: movie.plot,
      imdbRating: movie.imdbRating,
      addedAt: addedAt,
    );
  }

  final String id;
  final String title;
  final String poster;
  final int year;
  final MovieRating rated;
  final int runtime;
  final List<String> genre;
  final String plot;
  final double imdbRating;
  final DateTime addedAt;

  FavouriteMovie copyWith({
    String? id,
    String? title,
    String? poster,
    int? year,
    MovieRating? rated,
    int? runtime,
    List<String>? genre,
    String? plot,
    double? imdbRating,
    DateTime? addedAt,
  }) {
    return FavouriteMovie(
      id: id ?? this.id,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      year: year ?? this.year,
      rated: rated ?? this.rated,
      runtime: runtime ?? this.runtime,
      genre: genre ?? this.genre,
      plot: plot ?? this.plot,
      imdbRating: imdbRating ?? this.imdbRating,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  String toString() {
    return "FavouriteMovie(id: $id, title: $title, poster: $poster, "
        "year: $year, rated: ${rated.code}, runtime: ${runtime}min, "
        "genre: $genre, plot: $plot, imdbRating: $imdbRating, "
        "addedAt: $addedAt)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavouriteMovie &&
        other.id == id &&
        other.title == title &&
        other.poster == poster &&
        other.year == year &&
        other.rated == rated &&
        other.runtime == runtime &&
        listEquals(other.genre, genre) &&
        other.plot == plot &&
        other.imdbRating == imdbRating &&
        other.addedAt == addedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      title,
      poster,
      year,
      rated,
      runtime,
      Object.hashAll(genre),
      plot,
      imdbRating,
      addedAt,
    ]);
  }
}
