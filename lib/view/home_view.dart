import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
import 'movie_view.dart';
import 'profil_view.dart';

/// Tampilan utama yang menampilkan beranda film dan profil pengguna.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List homeWidget = [const MovieView(), const ProfilView()];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieApp'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Peringatan'),
                      content: const Text('Apakah anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                            onPressed: () => controller.logout(),
                            child: const Text('Ya')),
                        TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Tidak',
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ),
                  ),
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: homeWidget.elementAt(index),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Profile'),
        ],
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
