import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../model/movie_model.dart';

/// Controller untuk manajemen data film dari API The Movie Database (TMDb).
class MovieController {
  var baseUrl = 'https://api.themoviedb.org/3';
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNTExYWYzZDgyMmFkYzcxZTE3N2Y2M2ZjMDdhY2Y5YiIsIm5iZiI6MTcyMjk0ODMyNi45MzgwNTMsInN1YiI6IjY2ODNhMDJmMTJmNjdkYjRhZjcwMTQ2YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AUdVfgEZd9wBBps-QPNpYBZV30PczN315hEcrgWP4fI',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// Mendapatkan daftar film yang sedang diputar.
  ///
  /// Return List<Movie> berisi data film dari response API.
  Future<List<Movie>> playMovie() async {
    var url = Uri.parse('$baseUrl/movie/now_playing?language=en-US');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List movies = data['results'];
      return movies.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Mendapatkan daftar film populer.
  ///
  /// Return List<Movie> berisi data film dari response API.
  Future<List<Movie>> popularMovie() async {
    var url = Uri.parse('$baseUrl/movie/popular?language=en-US');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List movies = data['results'];
      return movies.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Mendapatkan informasi detail film
  ///
  /// Return Movie berisi data detail film dari response API
  Future<Movie> detailMovie(int id) async {
    var url = Uri.parse('$baseUrl/movie/$id?language=en-US');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Mendapatkan daftar film yang mirip berdasarkan id film.
  ///
  /// Parameter id digunakan untuk pencarian film yang mirip.
  /// Return List<Movie> berisi data film dari response API.
  Future<List<Movie>> similarMovie(int id) async {
    var url = Uri.parse('$baseUrl/movie/$id/similar?language=en-US');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List movies = data['results'];
      return movies.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Mendapatkan daftar film favorit dari akun pengguna.
  ///
  /// Return List<Movie> berisi data film favorit dari response API.
  Future<List<Movie>> favoriteMovie() async {
    var url = Uri.parse(
        '$baseUrl/account/21360692/favorite/movies?language=en-US&page=1&sort_by=created_at.asc');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List movies = data['results'];
      return movies.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Mendapatkan daftar film yang ditandai sebagai watchlist dari akun pengguna.
  ///
  /// Return List<Movie> berisi data film watchlist dari response API.
  Future<List<Movie>> watchlistMovie() async {
    var url = Uri.parse(
        '$baseUrl/account/21360692/watchlist/movies?language=en-US&page=1&sort_by=created_at.asc');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List movies = data['results'];
      return movies.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Menambahkan film ke watchlist pengguna berdasarkan id film.
  ///
  /// Parameter id digunakan untuk Menambahkan film ke watchlist.
  Future<void> addWatchlist(int id) async {
    var url = Uri.parse('$baseUrl/account/21360692/watchlist');
    var body = jsonEncode({
      'media_type': 'movie',
      'media_id': id,
      'watchlist': true,
    });
    try {
      await http.post(
        url,
        headers: headers,
        body: body,
      );
      Get.snackbar('Watchlist', 'Berhasil menambahkan Watchlist');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Gagal menambahkan Watchlist');
    }
  }

  /// Menambahkan film ke daftar favorit pengguna berdasarkan id film.
  ///
  /// Parameter id digunakan untuk Menambahkan film ke favorit.
  Future<void> addFavorite(int id) async {
    var url = Uri.parse('$baseUrl/account/21360692/favorite');
    var body = jsonEncode({
      'media_type': 'movie',
      'media_id': id,
      'favorite': true,
    });
    try {
      await http.post(
        url,
        headers: headers,
        body: body,
      );
      Get.snackbar('Favorite', 'Berhasil menambahkan Favorite');
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Gagal menambahkan Favorite');
    }
  }

  /// Menyimpan gambar dari URL ke galeri perangkat pengguna.
  ///
  /// Parameter imageUrl digunakan untuk menyimpan gambar dari URL.
  Future<void> saveImage(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        await ImageGallerySaver.saveImage(bytes);
        Get.snackbar('Simpan', 'Berhasil menyimpan gambar');
      } else {
        Get.snackbar('Terjadi Kesalahan', 'Gagal menyimpan gambar');
      }
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', '$e');
    }
  }
}
