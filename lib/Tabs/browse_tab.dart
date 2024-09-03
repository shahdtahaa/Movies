import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../category_movies_screen.dart';
import '../Models/MoviesCategoriesList_Model.dart';

class BrowseTab extends StatefulWidget {
  @override
  _BrowseTabState createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  late Future<MoviesCategoriesListModel> futureCategories;


  final List<String> categoryImages = [
    'assets/images/actionImage.jfif',
    'assets/images/AdventurePoster.jpg',
    'assets/images/AnimationPoster.jpg',
    'assets/images/ComedPoster.jfif',
    'assets/images/CrimePoster.jfif',
    'assets/images/DocumentryPoster.jfif',
    'assets/images/DramaPoster.jfif',
    'assets/images/FamilyPoster.jfif',
    'assets/images/FantasyPoster.jfif',
    'assets/images/HistoryPoster.jfif',
    'assets/images/horrorPoster.jfif',
    'assets/images/MusicPoster.jfif',
    'assets/images/MysteryPoster.jfif',
    'assets/images/RomancePoster.jfif',
    'assets/images/ScienceMoviesPoster.jfif',
    'assets/images/TVPoster.jfif',
    'assets/images/ThrillerPoster.jfif',
    'assets/images/WarPoster.jfif',
    'assets/images/WesternPoster.jfif',
  ];

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  Future<MoviesCategoriesListModel> fetchCategories() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=785dd30491a7a0087c720824731840ff'));

    if (response.statusCode == 200) {
      return MoviesCategoriesListModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff121312),
      appBar: AppBar(
        toolbarHeight:height*0.1 ,
        backgroundColor: Color(0xff121312),
        title: Text("Browse Category",style: GoogleFonts.inter(
          fontSize:22 ,
          fontWeight: FontWeight.w400,
          color: Colors.white,),


    ),
      ),
      body: FutureBuilder<MoviesCategoriesListModel>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.genres == null || snapshot.data!.genres!.isEmpty) {
            return Center(child: Text('No categories found'));
          } else {
            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3/2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: snapshot.data!.genres!.length,
              itemBuilder: (context, index) {
                final genre = snapshot.data!.genres![index];
                // Select an image path based on the index
                final imagePath = categoryImages[index % categoryImages.length];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesInCategoryScreen(
                          genre.id ?? 0,  // Provide a default value, or handle null appropriately
                          genre.name ?? 'Unknown', // Ensure name is not null
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imagePath), // Use the selected image path
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          genre.name ?? 'Unknown', // Handle null value
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          )
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
