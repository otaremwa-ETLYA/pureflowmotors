import 'package:flutter/material.dart';
import 'bike_loan_screen.dart';

// Temporary placeholder screens
class ActiveLoanScreen extends StatelessWidget {
  const ActiveLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Active Loans"));
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Payments"));
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Chat"));
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    // TAB 1
    BikeLoanScreen(),

    // TAB 2
    ActiveLoanScreen(),

    // TAB 3
    PaymentScreen(),

    // TAB 4
    ChatScreen(),
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
