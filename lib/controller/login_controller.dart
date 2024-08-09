import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../view/home_view.dart';
import '../view/login_view.dart';

/// Controller untuk manajemen login dan logout pengguna.
class LoginController {
  String baseUrl = 'https://api.themoviedb.org/3';
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzNTExYWYzZDgyMmFkYzcxZTE3N2Y2M2ZjMDdhY2Y5YiIsIm5iZiI6MTcyMjk0ODMyNi45MzgwNTMsInN1YiI6IjY2ODNhMDJmMTJmNjdkYjRhZjcwMTQ2YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.AUdVfgEZd9wBBps-QPNpYBZV30PczN315hEcrgWP4fI',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
  String? session;

  /// Melakukan login sebagai guest untuk mendapatkan guest session ID.
  ///
  /// Throw exception jika gagal mendapatkan data.
  Future<String> guestLogin() async {
    var url = Uri.parse('$baseUrl/authentication/guest_session/new');
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['guest_session_id'];
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }

  /// Proses login pengguna dengan menggunakan guest session ID.
  ///
  /// Menggunakan GetX untuk navigasi ke halaman HomeView setelah login berhasil.
  Future<void> login() async {
    String id = await guestLogin();
    session = id;
    if (session != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('session', id);
      Get.offAll(() => const HomeView(), transition: Transition.cupertino);
      Get.snackbar('Login', 'Berhasil Login');
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Gagal login');
    }
  }

  /// Mengambil session ID dari shared preferences.
  ///
  /// Return session ID jika tersimpan, null jika tidak.
  Future<String?> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? session = pref.getString('session');
    return session;
  }

  /// Proses logout pengguna dengan menghapus session dari shared preferences.
  ///
  /// Menggunakan GetX untuk navigasi ke halaman LoginView setelah logout berhasil.
  Future<void> logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('session');
      Get.snackbar('Logout', 'Berhasil Logout');
      Get.offAll(() => const LoginView(), transition: Transition.cupertino);
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', 'Gagal logout');
    }
  }
}
