import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies/FireBase/firebase_options.dart';
import 'package:movies/splashscreen.dart';
import 'HomeScreen.dart';
import 'MovieDetailsScreen/MovieDetails_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
