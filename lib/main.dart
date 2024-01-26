import 'package:country_tracker/screens/bottom_navigation/bottom_navigation.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigation(),
    );
  }
}
