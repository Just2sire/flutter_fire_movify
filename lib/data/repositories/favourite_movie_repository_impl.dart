import "dart:async";

import "package:movify/data/models/favourite_movie_model.dart";
import "package:movify/data/services/local_storage_service.dart";
import "package:movify/domain/entities/favourite_movie.dart";
import "package:movify/domain/repositories/favourite_movie_repository.dart";

class FavouriteMovieRepositoryImpl implements FavouriteMovieRepository {
  FavouriteMovieRepositoryImpl() {
    // Initialiser le stream avec les données actuelles
    _emitFavourites();
  }

  final _controller = StreamController<List<FavouriteMovie>>.broadcast();

  @override
  Future<List<FavouriteMovie>> getFavourites() async {
    final models = await SharedPrefsService.getFavourites;
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Stream<List<FavouriteMovie>> watchFavourites() async* {
    yield await getFavourites();
    yield* _controller.stream;
  }

  Future<void> _emitFavourites() async {
    final favourites = await getFavourites();
    _controller.add(favourites);
  }

  @override
  Future<bool> saveFavourites(List<FavouriteMovie> favourites) async {
    final models = favourites.map(FavouriteMovieModel.fromEntity).toList();
    final result = await SharedPrefsService.saveFavourites(models);
    if (result) await _emitFavourites();
    return result;
  }

  @override
  Future<bool> addFavourite(FavouriteMovie movie) async {
    final model = FavouriteMovieModel.fromEntity(movie);
    final result = await SharedPrefsService.addFavourite(model);
    if (result) await _emitFavourites();
    return result;
  }

  @override
  Future<bool> removeFavourite(String movieId) async {
    final result = await SharedPrefsService.removeFavourite(movieId);
    if (result) await _emitFavourites();
    return result;
  }

  @override
  Future<bool> isFavourite(String movieId) {
    return SharedPrefsService.isFavourite(movieId);
  }

  @override
  Future<bool> toggleFavourite(FavouriteMovie movie) async {
    final model = FavouriteMovieModel.fromEntity(movie);
    final result = await SharedPrefsService.toggleFavourite(model);
    if (result) await _emitFavourites();
    return result;
  }
}
