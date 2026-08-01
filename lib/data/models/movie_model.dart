import "dart:convert";

import "package:flutter/foundation.dart";
import "package:movify/domain/entities/movie.dart";
import "package:movify/domain/entities/movie_rating.dart";

class MovieModel {
  MovieModel({
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

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      year: movie.year,
      rated: movie.rated,
      released: movie.released,
      runtime: movie.runtime,
      genre: movie.genre,
      director: movie.director,
      writer: movie.writer,
      actors: movie.actors,
      plot: movie.plot,
      language: movie.language,
      country: movie.country,
      awards: movie.awards,
      poster: movie.poster,
      imdbRating: movie.imdbRating,
      imdbId: movie.imdbId,
      boxOffice: movie.boxOffice,
    );
  }

  factory MovieModel.fromJson(String source) =>
      MovieModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map["id"] as String? ?? "",
      title: map["title"] as String? ?? "",
      year: _parseYear(map["year"]),
      rated: MovieRating.fromString(map["rated"] as String?),
      released: _parseReleased(map["released"]),
      runtime: _parseRuntime(map["runtime"]),
      genre: _parseList(map["genre"]),
      director: map["director"] as String? ?? "",
      writer: _parseList(map["writer"]),
      actors: _parseList(map["actors"]),
      plot: map["plot"] as String? ?? "",
      language: _parseList(map["language"]),
      country: _parseList(map["country"]),
      awards: map["awards"] as String? ?? "",
      poster: map["poster"] as String? ?? "",
      imdbRating: _parseImdbRating(map["imdbRating"]),
      imdbId: map["imdbId"] as String? ?? "",
      boxOffice: _parseBoxOffice(map["boxOffice"]),
    );
  }

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

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      year: year,
      rated: rated,
      released: released,
      runtime: runtime,
      genre: genre,
      director: director,
      writer: writer,
      actors: actors,
      plot: plot,
      language: language,
      country: country,
      awards: awards,
      poster: poster,
      imdbRating: imdbRating,
      imdbId: imdbId,
      boxOffice: boxOffice,
    );
  }

  MovieModel copyWith({
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
    return MovieModel(
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

  Map<String, dynamic> toMap() {
    final rel = released;
    final formattedReleased = rel != null
        ? "${rel.day.toString().padLeft(2, '0')}-"
              "${rel.month.toString().padLeft(2, '0')}-${rel.year}"
        : "";

    return {
      "id": id,
      "title": title,
      "year": year,
      "rated": rated.code,
      "released": formattedReleased,
      "runtime": "$runtime min",
      "genre": genre.join(", "),
      "director": director,
      "writer": writer.join(", "),
      "actors": actors.join(", "),
      "plot": plot,
      "language": language.join(", "),
      "country": country.join(", "),
      "awards": awards,
      "poster": poster,
      "imdbRating": imdbRating,
      "imdbId": imdbId,
      "boxOffice": boxOffice,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return "MovieModel(id: $id, title: $title, year: $year, "
        "rated: ${rated.code}, released: $released, runtime: ${runtime}min, "
        "genre: $genre, director: $director, writer: $writer, "
        "actors: $actors, plot: $plot, language: $language, "
        "country: $country, awards: $awards, poster: $poster, "
        "imdbRating: $imdbRating, imdbId: $imdbId, boxOffice: $boxOffice)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieModel &&
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

  static DateTime? _parseReleased(Object? raw) {
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty && raw != "N/A") {
      final iso = DateTime.tryParse(raw);
      if (iso != null) return iso;

      final parts = raw.trim().split(RegExp(r"[-/\.]"));
      if (parts.length == 3) {
        final d1 = int.tryParse(parts[0]);
        final d2 = int.tryParse(parts[1]);
        final d3 = int.tryParse(parts[2]);
        if (d1 != null && d2 != null && d3 != null) {
          if (parts[0].length == 4) {
            return DateTime(d1, d2, d3);
          }
          return DateTime(d3, d2, d1);
        }
      }
    }
    return null;
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

  static int _parseBoxOffice(Object? raw) {
    if (raw is int) return raw;
    if (raw is String) {
      final digits = raw.replaceAll(RegExp("[^0-9]"), "");
      return int.tryParse(digits) ?? 0;
    }
    return 0;
  }
}
