import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'sign_in_screen.dart';

class ActiveLoanScreen extends StatefulWidget {
  final String bikeNumber;

  const ActiveLoanScreen({
    super.key,
    required this.bikeNumber,
  });

  @override
  State<ActiveLoanScreen> createState() => _ActiveLoanScreenState();
}

class _ActiveLoanScreenState extends State<ActiveLoanScreen> {
  String userName = "";

  double paid = 0;
  double balance = 0;
  double overdue = 0;
  String nextDue = "";
  bool loading = false;

  final firebaseUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/sheetData.json";

  @override
  void initState() {
    super.initState();
    fetchLatestLoanData();
  }

  String formatUGX(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return "UGX ${formatter.format(amount)}";
  }

  Future fetchLatestLoanData() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      final List data = jsonDecode(response.body);

      for (int i = 1; i < data.length; i++) {
        final row = data[i];
        final rowBike = row[2].toString().trim().toUpperCase();

        if (rowBike == widget.bikeNumber.toUpperCase()) {
          setState(() {
            // ✅ Column B = Name
            userName = row[1].toString();

            paid = double.tryParse(row[5].toString()) ?? 0;
            balance = double.tryParse(row[6].toString()) ?? 0;
            overdue = double.tryParse(row[8].toString()) ?? 0;

            final rawDate = row[10].toString();

            try {
              final parsed = DateTime.parse(rawDate).toLocal();
              nextDue =
                  DateFormat("dd/MM/yyyy").format(parsed);
            } catch (_) {
              nextDue = rawDate;
            }
          });

          // Save name locally for PaymentsScreen
          final prefs =
              await SharedPreferences.getInstance();
          await prefs.setString("name", userName);

          break;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future logout() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SignInScreen(onLoginSuccess: () {}),
      ),
      (route) => false,
    );
  }

  Widget infoBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily:
                  'Poppins-Regular',
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily:
                  'Poppins-SemiBold',
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(
                255, 16, 92, 177),
        iconTheme:
            const IconThemeData(
                color: Colors.white), // makes icons white
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $userName",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              "Bike ${widget.bikeNumber}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white, // ✅ white logout icon
            ),
            onPressed: logout,
          )
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
                height: 20),
            Row(
              children: [
                Expanded(
                    child: infoBox(
                        "Paid",
                        formatUGX(paid))),
                const SizedBox(
                    width: 10),
                Expanded(
                    child: infoBox(
                        "Balance",
                        formatUGX(balance))),
              ],
            ),
            const SizedBox(
                height: 15),
            infoBox("Overdue",
                formatUGX(overdue)),
            const SizedBox(
                height: 15),
            infoBox("Due Next",
                nextDue),
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color.fromARGB(
                255, 16, 92, 177),
        onPressed: loading
            ? null
            : () async {
                setState(() =>
                    loading = true);
                await fetchLatestLoanData();
                setState(() =>
                    loading = false);
              },
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child:
                    CircularProgressIndicator(
                  color:
                      Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Icon(
                Icons.refresh,
                color: Colors.white, // ✅ white refresh icon
              ),
      ),
    );
  }
}