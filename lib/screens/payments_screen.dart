import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String userName = "";
  String bikeNumber = "";
  bool loading = false;

  // Payment history list
  List<Map<String, dynamic>> paymentList = [];

  final firebaseBase =
      "https://activeloaninfo-default-rtdb.firebaseio.com/paymentHistory.json";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("name") ?? "";
      bikeNumber = prefs.getString("bike") ?? "";
    });
    await fetchPaymentHistory();
  }

  Future fetchPaymentHistory() async {
    if (bikeNumber.isEmpty) return;

    setState(() => loading = true);

    try {
      final response = await http.get(Uri.parse(firebaseBase));

      if (response.statusCode == 200) {
        Map<String, dynamic> allPayments = {};

        if (response.body.isNotEmpty && response.body != "null") {
          final decoded = jsonDecode(response.body);
          if (decoded != null && decoded is Map) {
            allPayments = Map<String, dynamic>.from(decoded);
          }
        }

        // Ensure bike number matches exactly (including leading zeros)
        final bikeKey = bikeNumber.toString();
        final bikePaymentsRaw = allPayments[bikeKey];

        if (bikePaymentsRaw == null || bikePaymentsRaw is! Map) {
          setState(() => paymentList = []);
          return;
        }

        // Convert map to list and sort newest first
          final List<Map<String, dynamic>> payments = bikePaymentsRaw.entries
              .map((entry) {
                final dateStr = entry.value['date'].toString();
                final amount = entry.value['amount'].toString();
                return {
                  'id': entry.key?.toString() ?? '', // <-- ensure id is never null
                  'date': dateStr,
                  'amount': amount,
                };
              })
              .toList()
            ..sort((a, b) => b['id']!.compareTo(a['id']!)); // <-- safely unwrap

        setState(() {
          paymentList = payments;
        });
      } else {
        debugPrint("Failed to fetch payments: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => loading = false);
  }

  String formatPayment(Map<String, dynamic> payment) {
    try {
      final dt = DateTime.parse(payment['date']);
      final dateStr = DateFormat("dd/MM/yyyy").format(dt);
      final timeStr = DateFormat("hh:mm a").format(dt);
      final amountStr = payment['amount'];
      return "Paid UGX $amountStr on $dateStr at $timeStr";
    } catch (_) {
      return "Paid UGX ${payment['amount']} on ${payment['date']}";
    }
  }

  Future refreshPayments() async {
    await fetchPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 92, 177),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $userName",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              "Bike $bikeNumber",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment History",
              style: TextStyle(
                fontFamily: 'Poppins-Bold',
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const Center(child: CircularProgressIndicator())
                : paymentList.isEmpty
                    ? const Center(
                        child: Text(
                          "No payments yet",
                          style: TextStyle(
                              fontFamily: 'Poppins-Regular', color: Colors.black54),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: paymentList.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, color: Colors.grey),
                          itemBuilder: (context, index) {
                            final payment = paymentList[index];
                            return ListTile(
                              title: Text(formatPayment(payment)),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 16, 92, 177),
        onPressed: loading ? null : refreshPayments,
        child: loading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
            : const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}