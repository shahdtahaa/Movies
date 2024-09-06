import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/FireBase/Firebase_Functions.dart';
import 'package:movies/Models/moviesdetailsModel.dart';
import 'package:movies/Search%20Screen/MovieService.dart';

class WishlistScreen extends StatelessWidget {
   WishlistScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121312),
      appBar: AppBar(
        backgroundColor: const Color(0xff121312),
        title: const Text('Watchlist', style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        )),
      ),
      body: StreamBuilder<QuerySnapshot<MoviesdetailsModel>>(
        stream: FirebaseFunctions.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Movies Found",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            );
          } else {
            final wishlistMovies = snapshot.data!.docs
                .map((doc) => doc.data())
                .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: wishlistMovies.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey.withOpacity(0.5)),
                itemBuilder: (context, index) {
                  final movie = wishlistMovies[index];
                  final releaseYear = movie.releaseDate?.split('-').first ?? 'Unknown';
                  return Card(
                    color: const Color(0xff121312),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 150,
                          height: 200,
                          child: Stack(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                fit: BoxFit.fill,
                                height: 190,
                                width: 170,
                              ),
                               InkWell(
                                 onTap: () {
                                   FirebaseFunctions.deleteMovieFromWishlist(movie.id.toString());
                                 },
                                 child: Opacity(
                                   opacity: 0.8,
                                   child: Image.asset(
                                     'assets/images/checkmark.png',
                                     width: 37,
                                     height: 50,
                                     fit: BoxFit.fill,
                                   ),
                                 ),
                               ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title ?? 'No Title Available',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                releaseYear,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.67),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Roza Salazar, Christoph waltz",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.67),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}