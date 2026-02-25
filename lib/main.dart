import 'package:flutter/material.dart';
import '../screens/main_navigation.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motorcycle Loans',
      theme: ThemeData(

    // OFF WHITE BACKGROUND
    scaffoldBackgroundColor: const Color.fromARGB(255, 217, 217, 217),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(

      backgroundColor: Color.fromARGB(255, 16, 92, 177),

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,

      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
