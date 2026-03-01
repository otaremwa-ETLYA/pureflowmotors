import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsScreen extends StatefulWidget {

  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() =>
      _PaymentsScreenState();
}

class _PaymentsScreenState
    extends State<PaymentsScreen> {

  String userName = "";
  String bikeNumber = "";

  bool loading = false;

  // ======================
  // LOAD USER DATA
  // ======================

  @override
  void initState() {

    super.initState();

    loadUser();

  }

  Future loadUser() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    setState(() {

      userName =
          prefs.getString("name") ?? "";

      bikeNumber =
          prefs.getString("bike") ?? "";

    });

  }

  // ======================
  // REFRESH BUTTON
  // ======================

  Future refreshPayments() async {

    setState(() {

      loading = true;

    });

    await Future.delayed(
        const Duration(seconds: 1));

    setState(() {

      loading = false;

    });

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(

    //   const SnackBar(

    //     content:
    //         Text("Payments Updated"),

    //   ),

    // );

  }

  // ======================
  // UI
  // ======================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // ======================
      // APP BAR
      // ======================

      appBar: AppBar(

        backgroundColor:
            const Color.fromARGB(
                255, 16, 92, 177),

        title: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          mainAxisSize:
              MainAxisSize.min,

          children: [

            Text(

              "Welcome, $userName",

              style:
                  const TextStyle(

                fontFamily:
                    'Poppins-Regular',

                fontSize: 14,

                color:
                    Colors.white70,

              ),
            ),

            const SizedBox(
                height: 1),

            Text(

              "Bike $bikeNumber",

              style:
                  const TextStyle(

                fontFamily:
                    'Poppins-Bold',

                fontWeight: FontWeight.bold,
                fontSize: 22,

                color:
                    Colors.white,

              ),
            ),
          ],
        ),
      ),

      // ======================
      // BODY
      // ======================

      body: Padding(

        padding:
            const EdgeInsets.all(
                16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: const [

            Text(

              "Payment History",

              style:
                  TextStyle(

                fontFamily:
                    'Poppins-Bold',

                fontSize: 18,

              ),
            ),

            SizedBox(height: 20),

            Center(

              child: Text(

                "No payments yet",

                style:
                    TextStyle(

                  fontFamily:
                      'Poppins-Regular',

                  color:
                      Colors.black54,

                ),
              ),
            ),
          ],
        ),
      ),

      // ======================
      // FLOATING REFRESH
      // ======================

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            const Color.fromARGB(
                255, 16, 92, 177),

        onPressed:
            loading
                ? null
                : refreshPayments,

        child: loading
          ? const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            )
          : const Icon(
              Icons.refresh,
              color: Colors.white, // ← add this
            ),
                

      ),
    );
  }
}