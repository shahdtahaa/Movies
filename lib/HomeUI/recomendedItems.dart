import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movies/FireBase/Firebase_Functions.dart';
import 'package:movies/Models/moviesdetailsModel.dart';
import '../Models/topRatedModel.dart';
import '../MovieDetailsScreen/MovieDetails_screen.dart';

class Recomendeditems extends StatefulWidget {
  const Recomendeditems({super.key});

  @override
  State<Recomendeditems> createState() => _RecomendeditemsState();
}

class _RecomendeditemsState extends State<Recomendeditems> {
  TopRatedModel? topRatedModel;
  Map<int, bool> wishlistStatus = {};

  @override
  void initState() {
    super.initState();
    fetchTopRatedMovies();
  }

  Future<void> fetchTopRatedMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=785dd30491a7a0087c720824731840ff'),
    );

    if (response.statusCode == 200) {
      final model = TopRatedModel.fromJson(json.decode(response.body));
      final movies = model.results ?? [];

      final statuses = await Future.wait(
        movies.map((movie) async {
          final isInWishlist = await FirebaseFunctions.isMovieInWishlist(movie.id.toString());
          return MapEntry(movie.id!, isInWishlist);
        }),
      );

      setState(() {
        topRatedModel = model;
        wishlistStatus = Map.fromEntries(statuses);
      });
    } else {
      throw Exception('Failed to load top-rated movies');
    }
  }
  void _toggleWishlistStatus(int movieId, bool isAdded) async {
    //final isAdded = wishlistStatus[movieId] ?? false;
    setState(() {
      wishlistStatus[movieId] = !isAdded;
    });
    if (isAdded) {
      await FirebaseFunctions.deleteMovieFromWishlist(movieId.toString());
    } else {
      final movie = topRatedModel?.results?.firstWhere((m) => m.id == movieId);
      if (movie != null) {
        final movieDetails = MoviesdetailsModel(
          id: movie.id!,
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
        height: 238,
        color: Color(0xff282A28),
        child: topRatedModel == null
            ? Center(child: CircularProgressIndicator())
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5),
                  child: Text(
                    "Recommended",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.white,
                    )
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: topRatedModel!.results!.map((movie) {
                      final isAdded = wishlistStatus[movie.id!] ?? false;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviedetailsScreen(
                                  movieId: movie.id!),
                            ),
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 8.0,),
                          child:Container(
                            height: 200,
                            width: 120,
                           decoration: BoxDecoration(
                             color: Color(0xff343534),
                             borderRadius: BorderRadius.circular(8)
                           ),
                           child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 123,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _toggleWishlistStatus(movie.id!, isAdded);
                                          },
                                          child: Image.asset(
                                            isAdded
                                                ? 'assets/images/checkmark.png'
                                                : 'assets/images/bookmark.png',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star_rounded,
                                      color:Color(0xffFFBB3B),
                                      size: 13,),
                                      Text(
                                        movie.voteAverage.toString() ?? 'No rating',
                                        style: TextStyle(
                                          color: Colors.white,
                                            fontSize: 10, fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    movie.title ?? 'Unknown Title',

                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10, fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                    movie.releaseDate ?? 'Unknown release date',
                                    style: TextStyle(
                                      color:Color(0xffB5B4B4),
                                        fontSize: 8, fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),


                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ]));
  }
}
