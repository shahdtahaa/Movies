import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/more_like_this_Model.dart';
import '../Models/moviesdetailsModel.dart';
import 'moreLikeThis_items.dart';// Ensure the correct import path
import 'Details_items.dart'; // Import the MovieHeader widget

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
          moviesdetailsModel?.title??'',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: moviesdetailsModel == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height * 0.25, // Adjusted height for backdrop image
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500${moviesdetailsModel!.backdropPath}'),
              ),
            ),
          ),
          Container(
            height: height * 0.32, // Adjusted height for MovieHeader
            width: width,
            child: MovieHeader(movieDetails: moviesdetailsModel!),
          ),
          SizedBox(height: 5),
          Expanded(
            child: MoreLikeThisSection(
              moreLikeThisModel: moreLikeThisModel,
              onMovieTap: (movieId) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviedetailsScreen(movieId: movieId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
