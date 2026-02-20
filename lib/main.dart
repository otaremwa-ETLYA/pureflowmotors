import 'package:flutter/material.dart';
import 'screens/bike_loan_screen.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const BikeLoanScreen(),
    );
  }
}
