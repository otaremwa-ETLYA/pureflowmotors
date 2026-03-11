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

  /// Convert bike number into Firebase-safe key
  String _firebaseSafeBike(String bike) {
    return bike.replaceAll(RegExp(r'[.#$\[\]]'), '_');
  }

  Future fetchPaymentHistory() async {
    if (bikeNumber.isEmpty) return;

    setState(() => loading = true);

    try {
      final response = await http.get(Uri.parse(firebaseBase));
      if (response.statusCode == 200) {
        final Map<String, dynamic> allPayments =
            jsonDecode(response.body) ?? {};

        final bikeKey = _firebaseSafeBike(bikeNumber);

        final bikePaymentsRaw = allPayments[bikeKey];
        if (bikePaymentsRaw == null || bikePaymentsRaw is! Map) {
          setState(() => paymentList = []);
          return;
        }

        final List<Map<String, dynamic>> payments = bikePaymentsRaw.entries
            .map((entry) {
              return {
                'id': entry.key.toString(),
                'date': entry.value['date'] ?? '',
                'amount': entry.value['amount'] ?? '',
              };
            })
            .toList()
          ..sort((a, b) => b['id'].compareTo(a['id'])); // newest first

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

  String formatDateTime(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final date = DateFormat("dd/MM/yyyy").format(dt);
      final time = DateFormat("hh:mm a").format(dt);
      return "$date, $time";
    } catch (_) {
      return dateStr;
    }
  }

  Future refreshPayments() async {
    await fetchPaymentHistory();
  }

  Widget paymentItem(Map<String, dynamic> payment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "UGX ${payment['amount']}",
            style: const TextStyle(
              fontFamily: 'Poppins-Bold',
              fontSize: 16,
            ),
          ),
          Text(
            formatDateTime(payment['date']),
            style: const TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: 12,
              color: Colors.black54,
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
                              fontFamily: 'Poppins-Regular',
                              color: Colors.black54),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: paymentList.length,
                          itemBuilder: (context, index) {
                            return paymentItem(paymentList[index]);
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