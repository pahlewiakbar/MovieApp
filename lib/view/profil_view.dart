import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/movie_controller.dart';
import '../controller/login_controller.dart';
import '../controller/profil_controller.dart';
import 'movie_detail.dart';

/// Tampilan untuk menampilkan informasi pengguna, daftar watchlist
/// dan daftar film favorit pengguna.
class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller yang digunakan.
    LoginController loginC = LoginController();
    MovieController movieC = MovieController();
    ProfilController profilC = ProfilController();
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        // FutureBuilder untuk menampilkan Guest Session ID.
        FutureBuilder(
          future: loginC.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var guest = snapshot.data;
              return Column(
                children: [
                  const Text(
                    'Guest Session ID',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '$guest',
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              );
            }
            // Menampilkan indikator loading jika data sedang diambil.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
            return const Center(
              child: Text('Terjadi Kesalahan'),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Watchlist Movie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        // FutureBuilder untuk menampilkan daftar watchlist pengguna.
        FutureBuilder(
          future: movieC.watchlistMovie(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var watchlist = snapshot.data!;
              // Jika watchlist kosong, menampilkan pesan bahwa belum ada data.
              if (watchlist.isEmpty) {
                return const Center(
                  child: Text('Belum ada data'),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: watchlist
                        .map((movie) => GestureDetector(
                              onTap: () => Get.to(() => const MovieDetail(),
                                  transition: Transition.cupertino,
                                  arguments: movie),
                              child: Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 15),
                                child: Column(
                                  children: [
                                    // Gambar poster film dalam watchlist.
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Text('Image not found'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // Judul film dalam watchlist.
                                    Text(
                                      '${movie.originalTitle}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Tombol untuk menghapus film dari watchlist.
                                    TextButton(
                                        onPressed: () => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Peringatan'),
                                                content: const Text(
                                                    'Apakah anda yakin ingin menghapus ini?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () => profilC
                                                          .removeWatchlist(
                                                              movie.id!),
                                                      child: const Text('Ya')),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child: const Text('Tidak',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)))
                                                ],
                                              ),
                                            ),
                                        child: const Text(
                                          'Hapus',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              }
            }
            // Menampilkan indikator loading jika data sedang diambil.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
            return const Center(
              child: Text('Terjadi Kesalahan'),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Favorite Movie',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        // FutureBuilder untuk menampilkan daftar film favorit pengguna.
        FutureBuilder(
          future: movieC.favoriteMovie(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var favorite = snapshot.data!;
              // Jika daftar favorit kosong, menampilkan pesan bahwa belum ada data.
              if (favorite.isEmpty) {
                return const Center(
                  child: Text('Belum ada data'),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: favorite
                        .map((movie) => GestureDetector(
                              onTap: () => Get.to(() => const MovieDetail(),
                                  transition: Transition.cupertino,
                                  arguments: movie),
                              child: Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 15),
                                child: Column(
                                  children: [
                                    // Gambar poster film favorit.
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Text('Image not found'),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // Judul film favorit.
                                    Text(
                                      '${movie.originalTitle}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Tombol untuk menghapus film dari favorit.
                                    TextButton(
                                        onPressed: () => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Peringatan'),
                                                content: const Text(
                                                    'Apakah anda yakin ingin menghapus ini?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () => profilC
                                                          .removeFavorite(
                                                              movie.id!),
                                                      child: const Text('Ya')),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Get.back(),
                                                      child: const Text('Tidak',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red)))
                                                ],
                                              ),
                                            ),
                                        child: const Text(
                                          'Hapus',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              }
            }
            // Menampilkan indikator loading jika data sedang diambil.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
            return const Center(
              child: Text('Terjadi Kesalahan'),
            );
          },
        ),
      ],
    );
  }
}
