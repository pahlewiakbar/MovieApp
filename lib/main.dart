import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auto_login.dart';

void main() {
  runApp(const MainApp());
}

/// class MainApp berfungsi sebagai root dari aplikasi MovieApp.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'MovieApp',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      // Menentukan halaman awal aplikasi menggunakan AutoLogin.
      home: AutoLogin(),
    );
  }
}
