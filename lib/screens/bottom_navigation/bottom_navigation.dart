import 'package:country_tracker/screens/geolocator/geolocator_page.dart';
import 'package:country_tracker/screens/history/history_page.dart';
import 'package:country_tracker/strings/index.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const GeolocatorPage(),
    const HistoryPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amberAccent.withOpacity(0.5),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        selectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: Strings.location,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_history),
            label: Strings.history,
          ),
        ],
        onTap: onTabTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
