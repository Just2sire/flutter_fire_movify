import "../entities/watchlist_movie.dart";

abstract class WatchlistMovieRepository {
  Future<List<WatchlistMovie>> getWatchlist();
  Future<bool> saveWatchlist(List<WatchlistMovie> watchlist);
  Future<bool> addToWatchlist(WatchlistMovie movie);
  Future<bool> removeFromWatchlist(String movieId);
  Future<bool> toggleWatchlistStatus(String movieId);
  Future<bool> isInWatchlist(String movieId);
}
