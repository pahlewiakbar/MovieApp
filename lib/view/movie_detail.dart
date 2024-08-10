import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/movie_controller.dart';
import '../model/movie_model.dart';

/// Tampilan detail film yang menampilkan informasi tentang film dan film serupa.
class MovieDetail extends StatelessWidget {
  const MovieDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data film dari arguments yang diterima dari Navigator.
    Movie data = Get.arguments;
    // Menginisialisasi controller yang digunakan.
    MovieController controller = MovieController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Detail'),
      ),
      body: ListView(
        children: [
          // FutureBuilder untuk menampilkan informasi detail film
          FutureBuilder(
            future: controller.detailMovie(data.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var detail = snapshot.data!;
                return Column(
                  children: [
                    // Menampilkan gambar latar belakang film dari URL.
                    CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${detail.backdropPath}',
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Text('Image not found'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul film
                          Text(
                            '${detail.originalTitle}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          // Genre film
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Text(
                                  'Genre :',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Row(
                                  children: detail.genres!
                                      .map((e) => Container(
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Center(
                                              child: Text(
                                                '${e.name}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ), // Sinopsis film
                          Text('${detail.overview}',
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    )
                  ],
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
          Container(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Similar Movie',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                // FutureBuilder untuk menampilkan daftar film serupa.
                FutureBuilder(
                  future: controller.similarMovie(data.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var similar = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: similar
                              .map((movie) => Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      children: [
                                        // Gambar poster film serupa.
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Text('Image not found'),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // Judul film serupa.
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
