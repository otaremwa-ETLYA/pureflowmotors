import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bike_loan_screen.dart';
import 'active_loan_screen.dart';
import 'payments_screen.dart';
import 'sign_in_screen.dart';
import 'more_screen.dart';

// ======================
// MAIN NAVIGATION
// ======================
class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  // Global key to allow external widgets to control tab selection
  static final GlobalKey<_MainNavigationState> globalKey =
      GlobalKey<_MainNavigationState>();

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  /// External method to switch tabs
  void setTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name") != null && prefs.getString("bike") != null;
  }

  void onTabTapped(int index) async {
    if (index == 1 || index == 2) { // Active & Payments require login
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
    }
    setState(() => selectedIndex = index);
  }

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
            final bike = snapshot.data!.getString("bike") ?? "";
            return ActiveLoanScreen(bikeNumber: bike);
          },
        );

      case 2:
        return const PaymentsScreen();

      case 3:
        return const MoreScreen();

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
            label: "More",
          ),
        ],
      ),
    );
  }
}