import 'package:flutter/material.dart';
import 'bike_loan_screen.dart';
import '../screens/active_loan_screen.dart';
import '../screens/payments_screen.dart'; // ✅ ADD THIS

// ======================
// CHAT SCREEN (KEEP)
// ======================
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Chat"),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() =>
      _MainNavigationState();
}

class _MainNavigationState
    extends State<MainNavigation> {

  int selectedIndex = 0;

  // REMOVE const because PaymentsScreen loads prefs
  final List<Widget> screens = [

    // TAB 1
    const BikeLoanScreen(),

    // TAB 2
    const ActiveLoanScreen(),

    // TAB 3 ✅ REAL PAYMENTS SCREEN
    const PaymentsScreen(),

    // TAB 4
    const ChatScreen(),
  ];

  void onTabTapped(int index) {

    setState(() {

      selectedIndex = index;

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[selectedIndex],

      bottomNavigationBar:
          BottomNavigationBar(

        currentIndex: selectedIndex,

        onTap: onTabTapped,

        type:
            BottomNavigationBarType
                .fixed,

        showUnselectedLabels: true,

        items: const [

          BottomNavigationBarItem(

            icon:
                Icon(Icons.account_balance),

            label: "Loans",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(Icons.motorcycle),

            label: "Active",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(Icons.payments),

            label: "Payments",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(Icons.chat),

            label: "Chat",

          ),
        ],
      ),
    );
  }
}