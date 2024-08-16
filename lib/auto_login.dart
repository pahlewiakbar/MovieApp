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
        // Menampilkan logo aplikasi saat proses penundaan masih berjalan.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Image.asset(
                'asset/logo.png',
                width: 100,
              ),
            ),
          );
        }
        // Jika proses penundaan selesai, dapatkan status login pengguna.
        return FutureBuilder(
          future: controller.getUser(),
          builder: (context, snapshot) {
            // Menampilkan indikator loading jika sedang dalam proses pengambilan data.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Terjadi Kesalahan'),
                ),
              );
            }
            // Jika pengambilan data selesai, tentukan tampilan berdasarkan hasilnya.
            if (snapshot.hasData) {
              return const HomeView();
            }
            return const LoginView();
          },
        );
      },
    );
  }
}
