import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/category_movies_screen.dart';


class MovieService {
  final String apiKey = '785dd30491a7a0087c720824731840ff';

  Future<List<Movie>> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId'),
    );
    //print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['results'];
      return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body)['results'];
      return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
    } else   if (query.isEmpty) {
      return [];
    }
      else {
      throw Exception('Failed to search movies');
    }
  }
}
