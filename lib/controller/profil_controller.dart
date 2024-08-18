import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../view/home_view.dart';

/// Controller untuk manajemen profil pengguna terkait watchlist dan favorite.
class ProfilController {
  var baseUrl = 'https://api.themoviedb.org/3';
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNTExYWYzZDgyMmFkYzcxZTE3N2Y2M2ZjMDdhY2Y5YiIsIm5iZiI6MTcyMjk0ODMyNi45MzgwNTMsInN1YiI6IjY2ODNhMDJmMTJmNjdkYjRhZjcwMTQ2YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AUdVfgEZd9wBBps-QPNpYBZV30PczN315hEcrgWP4fI',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// Menghapus film dari watchlist pengguna berdasarkan ID film.
  ///
  /// Parameter id adalah ID film yang akan dihapus dari watchlist.
  Future<void> removeWatchlist(int id) async {
    var url = Uri.parse('$baseUrl/account/21360692/watchlist');
    var body = jsonEncode({
      'media_type': 'movie',
      'media_id': id,
      'watchlist': false,
    });
    try {
      await http.post(
        url,
        headers: headers,
        body: body,
      );
      Get.offAll(() => const HomeView());
      Get.snackbar('Watchlist', 'Berhasil menghapus Watchlist');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Gagal menghapus Watchlist');
    }
  }

  /// Menghapus film dari daftar favorit pengguna berdasarkan ID film.
  ///
  /// Parameter id adalah ID film yang akan dihapus dari favorit.
  Future<void> removeFavorite(int id) async {
    var url = Uri.parse('$baseUrl/account/21360692/favorite');
    var body = jsonEncode({
      'media_type': 'movie',
      'media_id': id,
      'favorite': false,
    });
    try {
      await http.post(
        url,
        headers: headers,
        body: body,
      );
      Get.offAll(() => const HomeView());
      Get.snackbar('Favorite', 'Berhasil menghapus Favorite');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Gagal menghapus Favorite');
    }
  }
}
