import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/FireBase/Firebase_Functions.dart';
import 'package:movies/Models/moviesdetailsModel.dart';
import '../Models/more_like_this_Model.dart';

class MoreLikeThisSection extends StatefulWidget {
  final MoreLikeThisModel? moreLikeThisModel;
  final Function(int) onMovieTap;

  const MoreLikeThisSection({
    Key? key,
    this.moreLikeThisModel,
    required this.onMovieTap,
  }) : super(key: key);

  @override
  State<MoreLikeThisSection> createState() => _MoreLikeThisSectionState();

}

class _MoreLikeThisSectionState extends State<MoreLikeThisSection> {
  Map<int, bool> wishlistStatus = {};

  @override
  void initState() {
    super.initState();
    _initializeWishlistStatus();
  }

  Future<void> _initializeWishlistStatus() async {
    if (widget.moreLikeThisModel != null) {
      final statuses = await Future.wait(
        widget.moreLikeThisModel!.results!.map((movie) async {
          final isInWishlist = await FirebaseFunctions.isMovieInWishlist(movie.id.toString());
          return MapEntry(movie.id!, isInWishlist);
        }),
      );
      setState(() {
        wishlistStatus = Map.fromEntries(statuses);
      });
    }
  }

  void _toggleWishlist(int movieId) async {
    final isAdded = wishlistStatus[movieId] ?? false;
    setState(() {
      wishlistStatus[movieId] = !isAdded;
    });

    if (isAdded) {
      await FirebaseFunctions.deleteMovieFromWishlist(movieId.toString());
    } else {
      final movie = widget.moreLikeThisModel?.results?.firstWhere((movie) => movie.id == movieId);
      if (movie != null) {
        final movieDetails = MoviesdetailsModel(
          id: movie.id,
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return widget.moreLikeThisModel == null
        ? Center(child: CircularProgressIndicator())
        : Container(
      width: width,
      height: height * 0.30,
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
                  children: widget.moreLikeThisModel!.results!.map((movie) {
                    final isAdded = wishlistStatus[movie.id!] ?? false;
                    return GestureDetector(
                      onTap: () => widget.onMovieTap(movie.id!),
                      child: Container(
                        width: width * 0.25,
                        height: 240,
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff343534),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.26,
                                height: height * 0.13,
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
                                  children: [
                                    InkWell(
                                      onTap: () => _toggleWishlist(movie.id!),
                                      child: Image.asset(
                                        isAdded
                                            ? 'assets/images/checkmark.png'
                                            : 'assets/images/bookmark.png',
                                      ),
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
                                      size: 12,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      movie.voteAverage != null
                                          ? movie.voteAverage!.toStringAsFixed(1)
                                          : 'No rating',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 10,
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
                                    fontSize: 9,
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
                                      fontSize: 8,
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