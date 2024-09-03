// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:movies/Search%20Screen/MovieService.dart';
// import 'package:movies/category_movies_screen.dart';
// import 'package:http/http.dart' as http;
//
// class SearchScreen extends SearchDelegate {
//   final List<String> movieTitles;
//   final MovieService movieService = MovieService();
//
//
//   SearchScreen({required this.movieTitles});
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//
//     return [
//       IconButton(
//         onPressed: () {
//           showResults(context);
//         },
//         icon: Icon(Icons.search),
//       ),
//     IconButton(
//     onPressed: () {
//     query='';
//     },
//       icon: Icon(Icons.clear),
//     )
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//
//     return  buildMovieSearch();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//
//     return buildMovieSearch();
//   }
//
//   Widget buildMovieSearch(){
// return
//   Scaffold(
//     backgroundColor: Color(0xff121312),
//     body: FutureBuilder<List<Movie>>(
//     future: movieService.searchMovies(query),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         return Center(child: Text('Error: ${snapshot.error}', style: GoogleFonts.poppins(color: Colors.white)));
//       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//         return Center(child: Text('No movies found', style: GoogleFonts.poppins(color: Colors.white)));
//       } else {
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView.separated(
//             // itemCount:snapshot.data!.length,
//             // itemBuilder:(context, index) {
//             //
//             //
//             // },
//             // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //   crossAxisCount: 2,
//             //   crossAxisSpacing: 8.0,
//             //   mainAxisSpacing: 8.0,
//             //   childAspectRatio: 0.7,
//             // ),
//             itemCount: snapshot.data!.length,
//             separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.5)),
//             itemBuilder: (context, index) {
//               final movie = snapshot.data![index];
//               final releaseYear = movie.releaseDate.split('-').first;
//               return Card(
//                 color: Color(0xff121312),
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SizedBox(
//                         width: 150,
//                         height: 200,
//                         child: Image.network(
//                           'https://image.tmdb.org/t/p/w500${movie.posterPath}',
//                           fit: BoxFit.fill,
//                           //BoxFit.cover,
//                           height: 190,
//                           width: 170,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10,),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             movie.title,
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4.0),
//                           Text(
//                             releaseYear,
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.white.withOpacity(0.67),
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Roza Salazar, Christoph waltz",
//                             style: GoogleFonts.poppins(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.white.withOpacity(0.67),
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       }
//     },
//     ),
//   );
//   }
//
// }
