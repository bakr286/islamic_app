import 'package:flutter/material.dart';
import 'package:islamic_app/screens/azkar.dart';
import 'prayer_times.dart';
import 'quran.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _screens = <Widget>[
    PrayerTimes(),
    QuranPage(),
    AzkarScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.timelapse), label: 'Prayer times'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_rounded), label: 'Quran'),
          
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book), label: 'Azkar'),
          
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}