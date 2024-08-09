import 'package:flutter/material.dart';

import 'controller/login_controller.dart';
import 'view/home_view.dart';
import 'view/login_view.dart';

/// class AutoLogin digunakan untuk menentukan tampilan awal aplikasi
/// berdasarkan status login pengguna.
class AutoLogin extends StatelessWidget {
  const AutoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller untuk mengelola proses login.
    LoginController controller = LoginController();

    return FutureBuilder(
      // Menunggu selama 1 detik untuk menampilkan logo aplikasi.
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        // Jika proses menampilkan logo selesai, cek status pengguna.
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            // Memanggil metode untuk mendapatkan status login pengguna.
            future: controller.getUser(),
            builder: (context, snapshot) {
              // Jika pengambilan data selesai, tentukan tampilan berdasarkan hasilnya.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return const HomeView();
                } else {
                  return const LoginView();
                }
              }
              // Menampilkan indikator loading jika sedang dalam proses pengambilan data.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
              return const Scaffold(
                body: Center(
                  child: Text('Terjadi Kesalahan'),
                ),
              );
            },
          );
        }
        // Menampilkan logo aplikasi saat proses penundaan masih berjalan.
        return Scaffold(
          body: Center(
            child: Image.asset(
              'asset/logo.png',
              width: 100,
            ),
          ),
        );
      },
    );
  }
}
