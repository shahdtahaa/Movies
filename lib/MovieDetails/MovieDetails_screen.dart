import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../Models/more_like_this_Model.dart';
import '../Models/moviesdetailsModel.dart';

class MoviedetailsScreen extends StatefulWidget {
  static const String routeName = "Movie details";
  final int movieId;

  const MoviedetailsScreen({required this.movieId, super.key});

  @override
  State<MoviedetailsScreen> createState() => _MoviedetailsScreenState();
}

class _MoviedetailsScreenState extends State<MoviedetailsScreen> {
  MoviesdetailsModel? moviesdetailsModel;
  MoreLikeThisModel? moreLikeThisModel;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails(widget.movieId);
    fetchSimilarMovies(widget.movieId);
  }

  Future<void> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId?api_key=785dd30491a7a0087c720824731840ff'),
    );

    if (response.statusCode == 200) {
      setState(() {
        moviesdetailsModel = MoviesdetailsModel.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<void> fetchSimilarMovies(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=785dd30491a7a0087c720824731840ff'),
    );

    if (response.statusCode == 200) {
      setState(() {
        moreLikeThisModel = MoreLikeThisModel.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load similar movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff121312),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xff1D1E1D),
        title: Text(
          moviesdetailsModel?.title ?? 'Unknown Title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: moviesdetailsModel == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height * 0.23,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${moviesdetailsModel!.backdropPath}'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( left: 16, top: 5.0),
              child: Text(
                moviesdetailsModel!.title ?? 'Unknown Title',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 5),
              child: Text(
                moviesdetailsModel!.releaseDate ?? 'Unknown',
                style: TextStyle(
                    color: Color(0xffB5B4B4),
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.22,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500${moviesdetailsModel!.posterPath}'),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/bookmark.png',
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8, right: 3),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Country: ${moviesdetailsModel!.originCountry?.join(", ") ?? 'Unknown'}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8, right: 3),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Lang: ${moviesdetailsModel!.originalLanguage ?? 'Unknown'}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8, right: 3),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                moviesdetailsModel != null &&
                                    moviesdetailsModel!.adult != null
                                    ? (moviesdetailsModel!.adult!
                                    ? 'Adult'
                                    : 'All Ages')
                                    : 'Unknown',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 150, // Adjust the height according to your design needs
                          child: SingleChildScrollView(
                            child: Text(
                              'Overview: ${moviesdetailsModel?.overview ?? 'N/A'}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.visible,
                              maxLines: null, // Limits the text to 10 lines
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star_rounded,
                              color:Color(0xffFFBB3B),
                              size: 15,),
              Text(
                moviesdetailsModel?.voteAverage != null
                    ? moviesdetailsModel!.voteAverage!.toStringAsFixed(1)
                    : 'No rating',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),

            //More like this Part
            moreLikeThisModel == null
                ? Center(child: CircularProgressIndicator())
                :
            Container(
                width: MediaQuery.of(context).size.width,
                height: height*0.33,
                color: Color(0xff282A28),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'More Like This',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: moreLikeThisModel!.results!.map((movie) {
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
                                height: height*0.27,
                                width: width*0.28,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  height: 180,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Color(0xff343534),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                       width: width*0.28,
                                        height: height*0.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/images/bookmark.png',
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            color: Color(0xffFFBB3B),
                                            size: 13,
                                          ),
                                          Text(
                                            moviesdetailsModel?.voteAverage != null
                                                ? moviesdetailsModel!.voteAverage!.toStringAsFixed(1)
                                                : 'No rating',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        movie.title ?? 'Unknown Title',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        movie.releaseDate ??
                                            'Unknown release date',
                                        style: TextStyle(
                                            color: Color(0xffB5B4B4),
                                            fontSize: 8,
                                            fontWeight: FontWeight.w400),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
  }
}
