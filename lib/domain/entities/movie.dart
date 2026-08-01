import "package:flutter/foundation.dart";
import "package:movify/domain/entities/favourite_movie.dart";
import "package:movify/domain/entities/movie_rating.dart";
import "package:movify/domain/entities/watchlist_movie.dart";

class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rated,
    required this.released,
    required this.runtime,
    required this.genre,
    required this.director,
    required this.writer,
    required this.actors,
    required this.plot,
    required this.language,
    required this.country,
    required this.awards,
    required this.poster,
    required this.imdbRating,
    required this.imdbId,
    required this.boxOffice,
  });

  final String id;
  final String title;
  final int year;
  final MovieRating rated;
  final DateTime? released;
  final int runtime;
  final List<String> genre;
  final String director;
  final List<String> writer;
  final List<String> actors;
  final String plot;
  final List<String> language;
  final List<String> country;
  final String awards;
  final String poster;
  final double imdbRating;
  final String imdbId;
  final int boxOffice;

  FavouriteMovie toFavouriteMovie() => FavouriteMovie.fromMovie(this);
  WatchlistMovie toWatchlistMovie() => WatchlistMovie.fromMovie(this);

  Movie copyWith({
    String? id,
    String? title,
    int? year,
    MovieRating? rated,
    DateTime? released,
    int? runtime,
    List<String>? genre,
    String? director,
    List<String>? writer,
    List<String>? actors,
    String? plot,
    List<String>? language,
    List<String>? country,
    String? awards,
    String? poster,
    double? imdbRating,
    String? imdbId,
    int? boxOffice,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      rated: rated ?? this.rated,
      released: released ?? this.released,
      runtime: runtime ?? this.runtime,
      genre: genre ?? this.genre,
      director: director ?? this.director,
      writer: writer ?? this.writer,
      actors: actors ?? this.actors,
      plot: plot ?? this.plot,
      language: language ?? this.language,
      country: country ?? this.country,
      awards: awards ?? this.awards,
      poster: poster ?? this.poster,
      imdbRating: imdbRating ?? this.imdbRating,
      imdbId: imdbId ?? this.imdbId,
      boxOffice: boxOffice ?? this.boxOffice,
    );
  }

  @override
  String toString() {
    return "Movie(id: $id, title: $title, year: $year, rated: ${rated.code}, "
        "released: $released, runtime: ${runtime}min, genre: $genre, "
        "director: $director, writer: $writer, actors: $actors, "
        "plot: $plot, language: $language, country: $country, "
        "awards: $awards, poster: $poster, imdbRating: $imdbRating, "
        "imdbId: $imdbId, boxOffice: $boxOffice)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movie &&
        other.id == id &&
        other.title == title &&
        other.year == year &&
        other.rated == rated &&
        other.released == released &&
        other.runtime == runtime &&
        listEquals(other.genre, genre) &&
        other.director == director &&
        listEquals(other.writer, writer) &&
        listEquals(other.actors, actors) &&
        other.plot == plot &&
        listEquals(other.language, language) &&
        listEquals(other.country, country) &&
        other.awards == awards &&
        other.poster == poster &&
        other.imdbRating == imdbRating &&
        other.imdbId == imdbId &&
        other.boxOffice == boxOffice;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      title,
      year,
      rated,
      released,
      runtime,
      Object.hashAll(genre),
      director,
      Object.hashAll(writer),
      Object.hashAll(actors),
      plot,
      Object.hashAll(language),
      Object.hashAll(country),
      awards,
      poster,
      imdbRating,
      imdbId,
      boxOffice,
    ]);
  }
}
