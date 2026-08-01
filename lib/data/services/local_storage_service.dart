import "package:flutter/foundation.dart" show debugPrint;
import "package:movify/core/constants/app_keys.dart";
import "package:movify/data/models/favourite_movie_model.dart";
import "package:movify/data/models/user_model.dart";
import "package:movify/data/models/watchlist_movie_model.dart";
import "package:shared_preferences/shared_preferences.dart";

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  static Future<bool> get hasName async {
    try {
      final prefs = await _instance;
      final name = prefs.getString(AppKeys.user) ?? "";
      return name.isNotEmpty;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<UserModel> get getUser async {
    try {
      final prefs = await _instance;
      final userString = prefs.getString(AppKeys.user);
      if (userString == null || userString.isEmpty) {
        return UserModel(
          username: "Logbodjoe",
          email: "unknown@gmail.com",
          phone: "",
        );
      }
      return UserModel.fromJson(userString);
    } catch (e) {
      debugPrint(e.toString());
      return UserModel(
        username: "Logbodjoe",
        email: "unknown@gmail.com",
        phone: "",
      );
    }
  }

  static Future<bool> saveUser(UserModel user) async {
    try {
      final prefs = await _instance;
      return await prefs.setString(AppKeys.user, user.toJson());
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> updateUser({
    String? username,
    String? email,
    String? phone,
  }) async {
    try {
      final currentUser = await getUser;
      final updatedUser = currentUser.copyWith(
        username: username,
        email: email,
        phone: phone,
      );
      return await saveUser(updatedUser);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> removeUser() async {
    try {
      final prefs = await _instance;
      return await prefs.remove(AppKeys.user);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // ==================== FAVORITES ====================

  /// Récupère la liste des films favoris
  static Future<List<FavouriteMovieModel>> get getFavourites async {
    try {
      final prefs = await _instance;
      final list = prefs.getStringList(AppKeys.favorites);
      if (list == null || list.isEmpty) return [];
      return list.map(FavouriteMovieModel.fromJson).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  /// Sauvegarde la liste complète des films favoris
  static Future<bool> saveFavourites(
    List<FavouriteMovieModel> favourites,
  ) async {
    try {
      final prefs = await _instance;
      final stringList = favourites.map((e) => e.toJson()).toList();
      return await prefs.setStringList(AppKeys.favorites, stringList);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Ajoute un film aux favoris s'il n'y est pas déjà
  static Future<bool> addFavourite(FavouriteMovieModel movie) async {
    try {
      final list = await getFavourites;
      final exists = list.any((item) => item.id == movie.id);
      if (exists) return true;
      final updatedList = [...list, movie];
      return await saveFavourites(updatedList);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Supprime un film des favoris par son ID
  static Future<bool> removeFavourite(String movieId) async {
    try {
      final list = await getFavourites;
      final updatedList = list.where((item) => item.id != movieId).toList();
      return await saveFavourites(updatedList);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Vérifie si un film est dans les favoris
  static Future<bool> isFavourite(String movieId) async {
    try {
      final list = await getFavourites;
      return list.any((item) => item.id == movieId);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Alterne l'état favori d'un film (ajoute s'il n'existe pas,
  /// supprime s'il existe)
  static Future<bool> toggleFavourite(FavouriteMovieModel movie) async {
    try {
      final list = await getFavourites;
      final index = list.indexWhere((item) => item.id == movie.id);
      if (index != -1) {
        list.removeAt(index);
      } else {
        list.add(movie);
      }
      return await saveFavourites(list);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // ==================== WATCHLIST ====================

  /// Récupère la liste de la watchlist
  static Future<List<WatchlistMovieModel>> get getWatchlist async {
    try {
      final prefs = await _instance;
      final list = prefs.getStringList(AppKeys.watchlist);
      if (list == null || list.isEmpty) return [];
      return list.map(WatchlistMovieModel.fromJson).toList();
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  /// Sauvegarde la liste complète de la watchlist
  static Future<bool> saveWatchlist(List<WatchlistMovieModel> watchlist) async {
    try {
      final prefs = await _instance;
      final stringList = watchlist.map((e) => e.toJson()).toList();
      return await prefs.setStringList(AppKeys.watchlist, stringList);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Ajoute un film à la watchlist s'il n'y est pas déjà
  static Future<bool> addToWatchlist(WatchlistMovieModel movie) async {
    try {
      final list = await getWatchlist;
      final exists = list.any((item) => item.id == movie.id);
      if (exists) return true;
      final updatedList = [...list, movie];
      return await saveWatchlist(updatedList);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Supprime un film de la watchlist par son ID
  static Future<bool> removeFromWatchlist(String movieId) async {
    try {
      final list = await getWatchlist;
      final updatedList = list.where((item) => item.id != movieId).toList();
      return await saveWatchlist(updatedList);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Alterne le statut "déjà vu" (`isWatched`) d'un film de la watchlist
  static Future<bool> toggleWatchlistStatus(String movieId) async {
    try {
      final list = await getWatchlist;
      final index = list.indexWhere((item) => item.id == movieId);
      if (index == -1) return false;
      final updatedMovie = list[index].copyWith(
        isWatched: !list[index].isWatched,
      );
      list[index] = updatedMovie;
      return await saveWatchlist(list);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Vérifie si un film est dans la watchlist
  static Future<bool> isInWatchlist(String movieId) async {
    try {
      final list = await getWatchlist;
      return list.any((item) => item.id == movieId);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // ==================== THEME ====================

  /// Récupère le mode de thème enregistré
  static Future<String?> get getThemeMode async {
    try {
      final prefs = await _instance;
      return prefs.getString(AppKeys.themeMode);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// Sauvegarde le mode de thème
  static Future<bool> saveThemeMode(String themeMode) async {
    try {
      final prefs = await _instance;
      return await prefs.setString(AppKeys.themeMode, themeMode);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
