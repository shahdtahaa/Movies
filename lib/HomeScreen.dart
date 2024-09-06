import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Tabs/browse_tab.dart';
import 'Tabs/home_tab.dart';
import 'Tabs/searchtab.dart';
import 'Tabs/wishlist_tab.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = "Home screen";
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121312),
      extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        onTap: (index) {
          setState(() {
            selectedindex = index;
          });
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white,

        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xff1A1A1A),
              icon: ImageIcon(AssetImage('assets/images/Home icon.png'),
                  size: 30),

              label: 'Home'),

          BottomNavigationBarItem(
              backgroundColor: Color(0xff1A1A1A),
              icon: ImageIcon(AssetImage('assets/images/search-2.png'),
                  size: 35),

              label: 'Search'),

          BottomNavigationBarItem(
              backgroundColor: Color(0xff1A1A1A),
              icon: ImageIcon(
                AssetImage('assets/images/browse.png'),
                size: 35,
              ),

              label: 'Browse'),

          BottomNavigationBarItem(
              backgroundColor: Color(0xff1A1A1A),
              icon: ImageIcon(
                AssetImage('assets/images/wishList.png',),
                size: 35,
              ),
              label: 'Watchlist'),
        ]
    ),
      body:tabs[selectedindex],
    );

  }

  List<Widget> tabs = [
   HomeTab(),
    SearchTab(),
    BrowseTab(),
    WishlistScreen()
  ];
}
