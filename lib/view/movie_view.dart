import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/movie_controller.dart';
import 'movie_detail.dart';

/// Tampilan untuk menampilkan daftar film yang sedang tayang dan film populer.
class MovieView extends StatelessWidget {
  const MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller untuk mengakses data film.
    var controller = MovieController();
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        // Bagian untuk menampilkan film yang sedang tayang.
        const Text(
          'Now Playing',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 7,
        ),
        // FutureBuilder untuk menampilkan film yang sedang tayang.
        FutureBuilder(
          future: controller.playMovie(),
          builder: (context, snapshot) {
            // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
            if (snapshot.hasError) {
              return const Center(
                child: Text('Terjadi Kesalahan'),
              );
            }
            // Menampilkan indikator loading jika masih dalam proses pengambilan data.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Menampilkan data jika proses pengambilan data telah selesai.
            var listNow = snapshot.data!;
            var nowPlay = listNow.take(6);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: nowPlay
                    .map((movie) => GestureDetector(
                          onTap: () => Get.to(() => const MovieDetail(),
                              arguments: movie.id),
                          child: Container(
                            width: 170,
                            margin: const EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                // Gambar poster film yang sedang tayang.
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
                                // Judul film yang sedang tayang.
                                Text(
                                  '${movie.originalTitle}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
        // Bagian untuk menampilkan film populer.
        const Text('Popular',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 7,
        ),
        // FutureBuilder untuk menampilkan film populer.
        FutureBuilder(
          future: controller.popularMovie(),
          builder: (context, snapshot) {
            // Menampilkan pesan kesalahan jika terjadi masalah dalam pengambilan data.
            if (snapshot.hasError) {
              return const Center(
                child: Text('Terjadi Kesalahan'),
              );
            }
            // Menampilkan indikator loading jika masih dalam proses pengambilan data.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // Menampilkan data jika proses pengambilan data telah selesai.
            var listPopular = snapshot.data!;
            var limit = listPopular.take(20).length;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: limit,
              itemBuilder: (context, index) {
                var popular = listPopular[index];
                return GestureDetector(
                  onTap: () =>
                      Get.to(() => const MovieDetail(), arguments: popular.id),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        // Gambar poster film populer.
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${popular.posterPath}',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Text('Image not found'),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Judul film populer.
                        Text(
                          '${popular.originalTitle}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        // Tombol aksi untuk menambahkan ke watchlist, favorit, dan menyimpan gambar.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  controller.addWatchlist(popular.id!);
                                },
                                icon: const Icon(Icons.bookmark)),
                            IconButton(
                                onPressed: () {
                                  controller.addFavorite(popular.id!);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  controller.saveImage(
                                      'https://image.tmdb.org/t/p/w500${popular.posterPath}');
                                },
                                icon: const Icon(
                                  Icons.save,
                                  color: Colors.blue,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }
}
