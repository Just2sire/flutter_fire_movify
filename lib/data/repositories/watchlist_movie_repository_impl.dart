import "package:movify/data/models/watchlist_movie_model.dart";
import "package:movify/data/services/local_storage_service.dart";
import "package:movify/domain/entities/watchlist_movie.dart";
import "package:movify/domain/repositories/watchlist_movie_repository.dart";

class WatchlistMovieRepositoryImpl implements WatchlistMovieRepository {
  const WatchlistMovieRepositoryImpl();

  @override
  Future<List<WatchlistMovie>> getWatchlist() async {
    final models = await SharedPrefsService.getWatchlist;
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> saveWatchlist(List<WatchlistMovie> watchlist) {
    final models = watchlist.map(WatchlistMovieModel.fromEntity).toList();
    return SharedPrefsService.saveWatchlist(models);
  }

  @override
  Future<bool> addToWatchlist(WatchlistMovie movie) {
    final model = WatchlistMovieModel.fromEntity(movie);
    return SharedPrefsService.addToWatchlist(model);
  }

  @override
  Future<bool> removeFromWatchlist(String movieId) {
    return SharedPrefsService.removeFromWatchlist(movieId);
  }

  @override
  Future<bool> toggleWatchlistStatus(String movieId) {
    return SharedPrefsService.toggleWatchlistStatus(movieId);
  }

  @override
  Future<bool> isInWatchlist(String movieId) {
    return SharedPrefsService.isInWatchlist(movieId);
  }
}
