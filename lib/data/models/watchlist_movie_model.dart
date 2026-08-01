import "dart:convert";

import "package:flutter/foundation.dart";
import "package:movify/domain/entities/movie.dart";
import "package:movify/domain/entities/movie_rating.dart";
import "package:movify/domain/entities/watchlist_movie.dart";

class WatchlistMovieModel {
  WatchlistMovieModel({
    required this.id,
    required this.title,
    required this.poster,
    required this.year,
    required this.rated,
    required this.runtime,
    required this.genre,
    required this.plot,
    required this.imdbRating,
    this.isWatched = false,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory WatchlistMovieModel.fromEntity(WatchlistMovie movie) {
    return WatchlistMovieModel(
      id: movie.id,
      title: movie.title,
      poster: movie.poster,
      year: movie.year,
      rated: movie.rated,
      runtime: movie.runtime,
      genre: movie.genre,
      plot: movie.plot,
      imdbRating: movie.imdbRating,
      isWatched: movie.isWatched,
      addedAt: movie.addedAt,
    );
  }

  factory WatchlistMovieModel.fromMovie(
    Movie movie, {
    bool isWatched = false,
    DateTime? addedAt,
  }) {
    return WatchlistMovieModel(
      id: movie.id,
      title: movie.title,
      poster: movie.poster,
      year: movie.year,
      rated: movie.rated,
      runtime: movie.runtime,
      genre: movie.genre,
      plot: movie.plot,
      imdbRating: movie.imdbRating,
      isWatched: isWatched,
      addedAt: addedAt,
    );
  }

  factory WatchlistMovieModel.fromJson(String source) =>
      WatchlistMovieModel.fromMap(
        jsonDecode(source) as Map<String, dynamic>,
      );

  factory WatchlistMovieModel.fromMap(Map<String, dynamic> map) {
    return WatchlistMovieModel(
      id: map["id"] as String? ?? "",
      title: map["title"] as String? ?? "",
      poster: map["poster"] as String? ?? "",
      year: _parseYear(map["year"]),
      rated: MovieRating.fromString(map["rated"] as String?),
      runtime: _parseRuntime(map["runtime"]),
      genre: _parseList(map["genre"]),
      plot: map["plot"] as String? ?? "",
      imdbRating: _parseImdbRating(map["imdbRating"]),
      isWatched: map["isWatched"] as bool? ?? false,
      addedAt: _parseDate(map["addedAt"]),
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
  final bool isWatched;
  final DateTime addedAt;

  WatchlistMovie toEntity() {
    return WatchlistMovie(
      id: id,
      title: title,
      poster: poster,
      year: year,
      rated: rated,
      runtime: runtime,
      genre: genre,
      plot: plot,
      imdbRating: imdbRating,
      isWatched: isWatched,
      addedAt: addedAt,
    );
  }

  WatchlistMovieModel copyWith({
    String? id,
    String? title,
    String? poster,
    int? year,
    MovieRating? rated,
    int? runtime,
    List<String>? genre,
    String? plot,
    double? imdbRating,
    bool? isWatched,
    DateTime? addedAt,
  }) {
    return WatchlistMovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      poster: poster ?? this.poster,
      year: year ?? this.year,
      rated: rated ?? this.rated,
      runtime: runtime ?? this.runtime,
      genre: genre ?? this.genre,
      plot: plot ?? this.plot,
      imdbRating: imdbRating ?? this.imdbRating,
      isWatched: isWatched ?? this.isWatched,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "poster": poster,
      "year": year,
      "rated": rated.code,
      "runtime": runtime,
      "genre": genre,
      "plot": plot,
      "imdbRating": imdbRating,
      "isWatched": isWatched,
      "addedAt": addedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return "WatchlistMovieModel(id: $id, title: $title, poster: $poster, "
        "year: $year, rated: ${rated.code}, runtime: ${runtime}min, "
        "genre: $genre, plot: $plot, imdbRating: $imdbRating, "
        "isWatched: $isWatched, addedAt: $addedAt)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WatchlistMovieModel &&
        other.id == id &&
        other.title == title &&
        other.poster == poster &&
        other.year == year &&
        other.rated == rated &&
        other.runtime == runtime &&
        listEquals(other.genre, genre) &&
        other.plot == plot &&
        other.imdbRating == imdbRating &&
        other.isWatched == isWatched &&
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
      isWatched,
      addedAt,
    ]);
  }

  static int _parseYear(Object? raw) {
    if (raw is int) return raw;
    if (raw is String) {
      final match = RegExp(r"\d{4}").firstMatch(raw);
      if (match != null) {
        return int.tryParse(match.group(0)!) ?? 0;
      }
    }
    return 0;
  }

  static int _parseRuntime(Object? raw) {
    if (raw is int) return raw;
    if (raw is String) {
      final match = RegExp(r"\d+").firstMatch(raw);
      if (match != null) {
        return int.tryParse(match.group(0)!) ?? 0;
      }
    }
    return 0;
  }

  static List<String> _parseList(Object? raw) {
    if (raw is List) {
      return raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (raw is String && raw.isNotEmpty && raw != "N/A") {
      return raw
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  static double _parseImdbRating(Object? raw) {
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is String) {
      return double.tryParse(raw) ?? 0.0;
    }
    return 0.0;
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty) {
      return DateTime.tryParse(raw);
    }
    return null;
  }
}
