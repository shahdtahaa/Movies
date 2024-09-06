import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movies/FireBase/Firebase_Functions.dart';
import 'package:movies/Models/moviesdetailsModel.dart';
import '../Models/upComingModel.dart';
import '../MovieDetailsScreen/MovieDetails_screen.dart';

class Newreleasesitems extends StatefulWidget {
  const Newreleasesitems({super.key});

  @override
  State<Newreleasesitems> createState() => _NewreleasesitemsState();
}

class _NewreleasesitemsState extends State<Newreleasesitems> {
  UpComingModel? upComingModel;
  Map<int, bool> wishlistStatus = {};

  @override
  void initState() {
    super.initState();
    fetchNewReleases();
  }

  Future<void> fetchNewReleases() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/upcoming?api_key=785dd30491a7a0087c720824731840ff'),
    );

    if (response.statusCode == 200) {
      final newReleasesModel = UpComingModel.fromJson(json.decode(response.body));
      final movies = newReleasesModel.results ?? [];


      final statuses = await Future.wait(
        movies.map((movie) async {
          final isInWishlist = await FirebaseFunctions.isMovieInWishlist(movie.id.toString());
          return MapEntry(movie.id!, isInWishlist);
        }),
      );

      setState(() {
        upComingModel = newReleasesModel;
        wishlistStatus = Map.fromEntries(statuses);
      });
    } else {
      throw Exception('Failed to load new releases');
    }
  }

  void _toggleWishlist(int movieId) async {
    final isAdded = wishlistStatus[movieId] ?? false;
    setState(() {
      wishlistStatus[movieId] = !isAdded;
    });
    if (isAdded) {
      await FirebaseFunctions.deleteMovieFromWishlist(movieId.toString());
    } else {
      final movie = upComingModel?.results?.firstWhere((movie) => movie.id == movieId);
      if (movie != null) {
        final movieDetails = MoviesdetailsModel(
          id: movie.id,
          title: movie.title!,
          releaseDate: movie.releaseDate!,
          posterPath: movie.posterPath!,
        );
        await FirebaseFunctions.addMovieToWishlist(movieDetails);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 187,
      color: Color(0xff282A28),
      child: upComingModel == null
          ? Center(
        child: CircularProgressIndicator(),
        heightFactor: double.maxFinite,
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7.0, left: 5),
            child: Text(
              "New Releases",
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: upComingModel!.results!.map((movie) {
                  final isAdded = wishlistStatus[movie.id!] ?? false;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MoviedetailsScreen(movieId: movie.id!),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 152,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => _toggleWishlist(movie.id!),
                                  child: Image.asset(
                                    isAdded
                                        ? 'assets/images/checkmark.png'
                                        : 'assets/images/bookmark.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
