import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';
import 'screens/welcome_screen.dart';
import 'data/bikes_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDOW8...your_api_key...",
      authDomain: "activeloaninfo.firebaseapp.com",
      databaseURL: "https://activeloaninfo-default-rtdb.firebaseio.com",
      projectId: "activeloaninfo",
      storageBucket: "activeloaninfo.firebasestorage.app",
      messagingSenderId: "689636555223",
      appId: "1:689636555223:web:ce9883375a92238b443392",
      measurementId: "G-H9XPKJHWT0",
    ),
  );
  bikesRepository.startListening();

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

