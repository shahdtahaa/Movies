import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesInCategoryScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  MoviesInCategoryScreen(this.genreId, this.genreName);

  @override
  _MoviesInCategoryScreenState createState() => _MoviesInCategoryScreenState();
}

class _MoviesInCategoryScreenState extends State<MoviesInCategoryScreen> {
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = displayMoviesByGenre(widget.genreId);
  }

  Future<List<Movie>> displayMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=785dd30491a7a0087c720824731840ff&with_genres=$genreId'));

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['results'];
      return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121312),
      appBar: AppBar(
        backgroundColor: Color(0xff1D1E1D),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.genreName,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.poppins(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies found', style: GoogleFonts.poppins(color: Colors.white)));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Release date: ${movie.releaseDate}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),

                              ],
                            ),
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

class Movie {
  final String title;
  final String releaseDate;
  final String posterPath;

  Movie({required this.title, required this.releaseDate, required this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      releaseDate: json['release_date'],
      posterPath: json['poster_path'],
    );
  }
}
