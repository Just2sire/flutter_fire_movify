import "../entities/favourite_movie.dart";

abstract class FavouriteMovieRepository {
  Future<List<FavouriteMovie>> getFavourites();
  Stream<List<FavouriteMovie>> watchFavourites();
  Future<bool> saveFavourites(List<FavouriteMovie> favourites);
  Future<bool> addFavourite(FavouriteMovie movie);
  Future<bool> removeFavourite(String movieId);
  Future<bool> isFavourite(String movieId);
  Future<bool> toggleFavourite(FavouriteMovie movie);
}
