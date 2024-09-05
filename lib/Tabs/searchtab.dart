import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/Search%20Screen/MovieService.dart';
import 'package:movies/category_movies_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  final MovieService _movieService = MovieService();
  late Future<List<Movie>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]);
  }

  void _performSearch(String query) {
    if (query == null) {
      query = '';
    }
    print("Search query: '$query'");
    setState(() {
      _searchResults = _movieService.searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121312),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xff121312),
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 16),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              _performSearch(query);
            },
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
            fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xff514F4F),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}\n\nAPI Response: ${snapshot.data}', style: GoogleFonts.poppins(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_movies,
                    size: 150,
                    color: Color(0xffB5B4B4),
                  ),
                  Text(
                    "No Movies Found",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.5)),
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  final releaseYear = movie.releaseDate.split('-').first;
                  return Card(
                    color: Color(0xff121312),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 150,
                            height: 200,
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              fit: BoxFit.fill,
                              height: 190,
                              width: 170,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
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
                                releaseYear,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.67),
                                ),
                              ),
                              SizedBox(height: 5),
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
