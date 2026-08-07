import "package:flutter_test/flutter_test.dart";
import "package:movify/data/models/movie_model.dart";
import "package:movify/domain/entities/movie_rating.dart";

void main() {
  group("MovieModel tests", () {
    final sampleMap = <String, dynamic>{
      "id": "movie_1",
      "title": "Inception",
      "year": "2010",
      "rated": "PG-13",
      "released": "16 Jul 2010",
      "runtime": "148 min",
      "genre": "Action, Sci-Fi",
      "director": "Christopher Nolan",
      "writer": "Christopher Nolan",
      "actors": "Leonardo DiCaprio, Joseph Gordon-Levitt",
      "plot": "A thief who steals corporate secrets...",
      "language": "English, Japanese",
      "country": "USA, UK",
      "awards": "Won 4 Oscars",
      "poster": "https://example.com/poster.jpg",
      "imdbRating": "8.8",
      "imdbId": "tt1375666",
      "boxOffice": r"$836,836,967",
    };

    test("fromMap parses data correctly", () {
      final model = MovieModel.fromMap(sampleMap);

      expect(model.id, equals("movie_1"));
      expect(model.title, equals("Inception"));
      expect(model.year, equals(2010));
      expect(model.rated, equals(MovieRating.pg13));
      expect(model.runtime, equals(148));
      expect(model.genre, equals(["Action", "Sci-Fi"]));
      expect(model.director, equals("Christopher Nolan"));
      expect(model.actors, equals(["Leonardo DiCaprio", "Joseph Gordon-Levitt"]));
      expect(model.imdbRating, equals(8.8));
      expect(model.boxOffice, equals(836836967));
    });

    test("toEntity converts MovieModel to Movie domain entity", () {
      final model = MovieModel.fromMap(sampleMap);
      final entity = model.toEntity();

      expect(entity.id, equals(model.id));
      expect(entity.title, equals(model.title));
      expect(entity.year, equals(model.year));
      expect(entity.imdbRating, equals(model.imdbRating));
      expect(entity.genre, equals(model.genre));
    });

    test("toMap serializes MovieModel correctly", () {
      final model = MovieModel.fromMap(sampleMap);
      final map = model.toMap();

      expect(map["id"], equals("movie_1"));
      expect(map["title"], equals("Inception"));
      expect(map["year"], equals(2010));
      expect(map["rated"], equals("PG-13"));
      expect(map["runtime"], equals("148 min"));
      expect(map["imdbRating"], equals(8.8));
    });
  });
}
