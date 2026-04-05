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
  final Widget? initialScreen;
  const MainNavigation({super.key, this.initialScreen});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late Widget selectedScreen;

  @override
  void initState() {
    super.initState();
    selectedScreen = widget.initialScreen ?? const BikeLoanScreen();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name") != null &&
        prefs.getString("bike") != null;
  }

void onTabTapped(int index) async {
  Widget screenToShow;

  switch (index) {
    case 0:
      // Loans tab → always accessible
      screenToShow = const BikeLoanScreen();
      break;

    case 1:
      // Active tab → requires login
      bool logged = await isLoggedIn();
      if (!logged) {
        // Redirect to SignInScreen; after login → MainNavigation root
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignInScreen(
              onLoginSuccess: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                  (route) => false,
                );
              },
            ),
          ),
        );
        return;
      }

      // Logged in → show ActiveLoanScreen
      final prefs = await SharedPreferences.getInstance();
      final bike = prefs.getString("bike") ?? "";
      screenToShow = ActiveLoanScreen(bikeNumber: bike);
      break;

    case 2:
      // Payments tab → requires login
      bool loggedPayments = await isLoggedIn();
      if (!loggedPayments) {
        // Redirect to SignInScreen; after login → MainNavigation root
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignInScreen(
              onLoginSuccess: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigation()),
                  (route) => false,
                );
              },
            ),
          ),
        );
        return;
      }

      // Logged in → show PaymentsScreen
      screenToShow = const PaymentsScreen();
      break;

    case 3:
      // More tab → always accessible
      screenToShow = const MoreScreen();
      break;

    default:
      screenToShow = const BikeLoanScreen();
  }

  setState(() => selectedScreen = screenToShow);
}

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.account_balance,
      Icons.motorcycle,
      Icons.payments,
      Icons.chat,
    ];
    const labels = ["Loans", "Active", "Payments", "More"];

    // Map the current screen to the type for highlighting
    final screenTypes = [
      BikeLoanScreen,
      ActiveLoanScreen,
      PaymentsScreen,
      MoreScreen,
    ];

    return Scaffold(
      body: selectedScreen,
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 16, 92, 177),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            // Navigation items
            Row(
              children: List.generate(4, (index) {
                final screenType = screenTypes[index];
                final isSelected = selectedScreen.runtimeType == screenType;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabTapped(index),
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[index],
                          size: 20,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[index],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              }),
            ),

            // Bottom indicator lines
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: List.generate(4, (index) {
                  final screenType = screenTypes[index];
                  final isSelected = selectedScreen.runtimeType == screenType;

                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 16, 92, 177),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}