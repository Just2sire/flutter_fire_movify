import "../entities/movie.dart";
import "../entities/movie_filter.dart";

abstract class MovieRepository {
  Future<List<Movie>> getAllMovies({MovieFilter? filter});
  Future<List<Movie>> getMovieRecommandation({int length = 8});
  Future<List<Movie>> getMoviesById(List<String> ids);
  Future<Movie> getMovieById(String id);
}
