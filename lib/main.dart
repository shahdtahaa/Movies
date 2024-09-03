import 'package:flutter/material.dart';
import 'package:movies/splashscreen.dart';
import 'HomeScreen.dart';
import 'MovieDetailsScreen/MovieDetails_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: Splashscreen.routeName,
        debugShowCheckedModeBanner: false,
        routes: {
          Splashscreen.routeName:(context)=>Splashscreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          MoviedetailsScreen.routeName: (context) {
            final movieId = ModalRoute.of(context)!.settings.arguments as int;
            return MoviedetailsScreen(movieId: movieId);
          },
        },

    );
  }
}
