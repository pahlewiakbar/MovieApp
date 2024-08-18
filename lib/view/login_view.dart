import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

/// Tampilan halaman login untuk aplikasi MovieApp.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = LoginController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'asset/logo.png',
              width: 100,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Center(
            child: Text(
              'MovieApp',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => controller.login(),
              icon: const Icon(Icons.person),
              label: const Text('Guest Login'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)))),
            ),
          ),
        ],
      ),
    );
  }
}
