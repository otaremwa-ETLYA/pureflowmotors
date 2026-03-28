import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pureflow Boda',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 242, 241, 241),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 16, 92, 177),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 👇 THIS is the important part
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const WelcomeScreen(),
          ),
        ),
      ),
      routes: {
        '/main': (context) => Scaffold(
          backgroundColor: const Color.fromARGB(255, 242, 241, 241),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const MainNavigation(),
            ),
          ),
        ),
      },
    );
  }
}
