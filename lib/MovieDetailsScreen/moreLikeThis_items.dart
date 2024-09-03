import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/more_like_this_Model.dart';

class MoreLikeThisSection extends StatelessWidget {
  final MoreLikeThisModel? moreLikeThisModel;
  final Function(int) onMovieTap;

  const MoreLikeThisSection({
    Key? key,
    this.moreLikeThisModel,
    required this.onMovieTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return moreLikeThisModel == null
        ? Center(child: CircularProgressIndicator())
        : Container(
      width: width,
      height: height * 0.30, // Adjust height to be less
      color: Color(0xff282A28),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'More Like This',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 2.0, top:4.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: moreLikeThisModel!.results!.map((movie) {
                    return GestureDetector(
                      onTap: () => onMovieTap(movie.id!),
                      child: Container(
                        width: width * 0.25,
                        height: 240,// Adjust width as needed
                        margin: EdgeInsets.symmetric(horizontal: 4.0), // Adjust margin
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff343534),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.26, // Adjust width as needed
                                height: height * 0.13, // Adjust height to be less
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  children: [Image.asset(
                                    'assets/images/bookmark.png',
                                  ),
                            ]
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0, left: 2.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Color(0xffFFBB3B),
                                      size: 12, // Adjust size as needed
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      movie.voteAverage != null
                                          ? movie.voteAverage!.toStringAsFixed(1)
                                          : 'No rating',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10, // Adjust font size as needed
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  movie.title ?? 'Unknown Title',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 9, // Adjust font size as needed
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  movie.releaseDate ?? 'Unknown release date',
                                  style: TextStyle(
                                      color: Color(0xffB5B4B4),
                                      fontSize: 8, // Adjust font size as needed
                                      fontWeight: FontWeight.w400),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}