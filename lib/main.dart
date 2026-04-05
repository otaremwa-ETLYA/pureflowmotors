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
      builder: (context, child) {
        // ✅ Apply max width globally to all screens
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: child,
          ),
        );
      },
      // Start with WelcomeScreen
      home: const WelcomeScreen(),
      // Named routes
        routes: {
    '/main': (context) => MainNavigation(),
  },
  onGenerateRoute: (settings) {
    if (settings.name == '/main') {
      final screen = settings.arguments as Widget?;
      return MaterialPageRoute(
        builder: (_) => MainNavigation(initialScreen: screen),
      );
    }
    return null;
  },
    );
  }
}

