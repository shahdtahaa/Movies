import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movies/FireBase/Firebase_Functions.dart';
import 'package:movies/Models/moviesdetailsModel.dart';
import '../Models/PopularModel.dart';
import '../MovieDetailsScreen/MovieDetails_screen.dart';

class Popularitems extends StatefulWidget {
  Popularitems({super.key});

  @override
  State<Popularitems> createState() => _PopularitemsState();
}

class _PopularitemsState extends State<Popularitems> {
  PopularModel? popularModel;
  List<Results> resultList = [];
  Map<Results, bool> wishlistStatus = {};

  @override
  void initState() {
    super.initState();
    fetchPopularMovies();
  }

  Future<void> fetchPopularMovies() async {
    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=785dd30491a7a0087c720824731840ff'));
    if (response.statusCode == 200) {
      final popularModel = PopularModel.fromJson(json.decode(response.body));
      final movies = popularModel.results ?? [];


      final statuses = await Future.wait(
        movies.map((movie) async {
          final isInWishlist = await FirebaseFunctions.isMovieInWishlist(movie.id.toString());
          return MapEntry(movie, isInWishlist);
        }),
      );

      setState(() {
        resultList = movies;
        wishlistStatus = Map.fromEntries(statuses);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return resultList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : CarouselSlider.builder(
      itemCount: resultList.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final movie = resultList[itemIndex];
        final isAdded = wishlistStatus[movie] ?? false;

        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              MoviedetailsScreen.routeName,
              arguments: movie.id,
            );
          },
          child: Container(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.28,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w500${movie.backdropPath}"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, left: 175),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            movie.title!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            movie.releaseDate!,
                            style: TextStyle(
                              color: Color(0xffB5B4B4),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: height * 0.12,
                  left: 20,
                  child: Container(
                    width: width * 0.35,
                    height: height * 0.24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                          ),
                          fit: BoxFit.cover,
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              wishlistStatus[movie] = !isAdded;
                            });
                            if (isAdded) {
                              _removeFromWishlist(movie);
                            } else {
                              _addToWishlist(movie);
                            }
                          },
                          child: Image.asset(
                            isAdded
                                ? 'assets/images/checkmark.png'
                                : 'assets/images/bookmark.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: height * 0.38,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.linear,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        enlargeCenterPage: true,
        enlargeFactor: 0.20,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  void _addToWishlist(Results movie) async {
    final movieDetails = MoviesdetailsModel(
      id: movie.id,
      title: movie.title!,
      releaseDate: movie.releaseDate!,
      posterPath: movie.posterPath!,
    );

    await FirebaseFunctions.addMovieToWishlist(movieDetails);
  }

  void _removeFromWishlist(Results movie) async {
    await FirebaseFunctions.deleteMovieFromWishlist(movie.id.toString());
  }
}
