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
    MovieController controller = MovieController();
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
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
            if (snapshot.connectionState == ConnectionState.done) {
              var listNow = snapshot.data!;
              var nowPlay = listNow.take(6);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: nowPlay
                      .map((movie) => GestureDetector(
                            onTap: () => Get.to(() => const MovieDetail(),
                                transition: Transition.cupertino,
                                arguments: movie),
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
            }
            // Menampilkan indikator loading jika masih dalam proses pengambilan data.
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
          height: 30,
        ),
        const Text('Popular',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 7,
        ),
        // FutureBuilder untuk menampilkan film populer.
        FutureBuilder(
          future: controller.popularMovie(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var listPopular = snapshot.data!;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: listPopular.take(20).length,
                itemBuilder: (context, index) {
                  var popular = listPopular[index];
                  return GestureDetector(
                    onTap: () => Get.to(() => const MovieDetail(),
                        transition: Transition.cupertino, arguments: popular),
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
            }
            // Menampilkan indikator loading jika masih dalam proses pengambilan data.
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
        )
      ],
    );
  }
}
