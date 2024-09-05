import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/moviesdetailsModel.dart';
import '../FireBase/Firebase_Functions.dart'; // Adjust the import if necessary

class MovieHeader extends StatefulWidget {
  final MoviesdetailsModel movieDetails;

  MovieHeader({required this.movieDetails});

  @override
  _MovieHeaderState createState() => _MovieHeaderState();
}

class _MovieHeaderState extends State<MovieHeader> {
  late MoviesdetailsModel movieDetails;
  bool isAdded = false;

  @override
  void initState() {
    super.initState();
    movieDetails = widget.movieDetails;
    checkIfMovieIsAdded();
  }

  Future<void> checkIfMovieIsAdded() async {
    final result = await FirebaseFunctions.isMovieInWishlist(movieDetails.id.toString());
    setState(() {
      isAdded = result;
    });
  }

  void _toggleWishlistStatus() async {
    setState(() {
      isAdded = !isAdded;
    });

    if (isAdded) {
      await FirebaseFunctions.addMovieToWishlist(movieDetails);
    } else {
      await FirebaseFunctions.deleteMovieFromWishlist(movieDetails.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieDetails.title ?? 'Unknown Title',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 2),
          Text(
            movieDetails.releaseDate ?? 'Unknown Release Date',
            style: GoogleFonts.inter(
              color: Color(0xffB5B4B4),
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster
                Container(
                  width: width * 0.35,
                  height: height * 0.21,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${movieDetails.posterPath}',
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: _toggleWishlistStatus,
                          child: Image.asset(
                            isAdded
                                ? 'assets/images/checkmark.png'
                                : 'assets/images/bookmark.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genres
                      movieDetails.genres != null && movieDetails.genres!.isNotEmpty
                          ? Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: movieDetails.genres!.map((genre) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              genre.name ?? 'Unknown',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                          : Text(
                        'Unknown',
                        style: GoogleFonts.inter(
                          color: Color(0xffB5B4B4),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),

                      Container(
                        height: 105,
                        child: SingleChildScrollView(
                          child: Text(
                            movieDetails.overview ?? 'No Overview Available',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      // Rating
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Color(0xffFFBB3B),
                            size: 17,
                          ),
                          Text(
                            movieDetails.voteAverage != null
                                ? movieDetails.voteAverage!.toStringAsFixed(1)
                                : 'No rating',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
