import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bike_loan_screen.dart';
import 'active_loan_screen.dart';
import 'payments_screen.dart';
import 'sign_in_screen.dart';

// ======================
// CHAT SCREEN
// ======================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Chats"));
  }
}

// ======================
// MAIN NAVIGATION
// ======================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString("name");
    final bike = prefs.getString("bike");
    return name != null && bike != null;
  }

  // Handle tab taps
  void onTabTapped(int index) async {
    // Loans tab is public
    if (index == 0) {
      setState(() => selectedIndex = 0);
      return;
    }

    bool logged = await isLoggedIn();

    if (!logged) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SignInScreen(
            onLoginSuccess: () {
              setState(() => selectedIndex = index);
            },
          ),
        ),
      );
      return;
    }

    setState(() => selectedIndex = index);
  }

  // Build the screen for the selected tab
  Widget buildScreen() {
    switch (selectedIndex) {
      case 0:
        return const BikeLoanScreen();
      case 1:
        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final prefs = snapshot.data!;
            final name = prefs.getString("name") ?? "";
            final bike = prefs.getString("bike") ?? "";
            return ActiveLoanScreen(bikeNumber: bike);
          },
        );
      case 2:
        return const PaymentsScreen();
      case 3:
        return const ChatScreen();
      default:
        return const BikeLoanScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: "Loans",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.motorcycle),
            label: "Active",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: "Payments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
        ],
      ),
    );
  }
}