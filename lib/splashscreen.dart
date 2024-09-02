import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class Splashscreen extends StatefulWidget {
  static const String routeName ='splashScreen';
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  void initState(){
    Future.delayed(Duration(seconds: 3),
            (){
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
            children: [
              Spacer(),
              Center(child: Image.asset(
                 "assets/images/movies.png"
              )),
              Spacer(),
              Center(child: Image.asset(
                "assets/images/Route_logo.png"
              )
              )
            ]
        )
    );
  }
}
