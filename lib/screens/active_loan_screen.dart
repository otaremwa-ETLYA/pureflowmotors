import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ActiveLoanScreen extends StatefulWidget {
  const ActiveLoanScreen({super.key});

  @override
  State<ActiveLoanScreen> createState() => _ActiveLoanScreenState();
}

class _ActiveLoanScreenState extends State<ActiveLoanScreen> {

  String formatUGX(double amount) {

  final formatter =
      NumberFormat("#,##0", "en_US");

  return "UGX ${formatter.format(amount)}";
  }

  /// Controllers
  final bikeController = TextEditingController();
  final passwordController = TextEditingController();

  /// Login state
  bool loggedIn = false;
  bool loading = false;
  bool bikeError = false;

  String userName = "";

  /// Loan Data
  String bikeNumber = "";
  double paid = 0;
  double balance = 0;
  double overdue = 0;
  String nextDue = "";

  final firebaseUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/sheetData.json";

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  /// AUTO LOGIN
  Future checkLogin() async {

    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString("name");

    if (savedName != null) {

      setState(() {

        loggedIn = true;
        userName = savedName;

        bikeNumber = prefs.getString("bike") ?? "";

        paid = prefs.getDouble("paid") ?? 0;
        balance = prefs.getDouble("balance") ?? 0;
        overdue = prefs.getDouble("overdue") ?? 0;

        nextDue =
            prefs.getString("nextDue") ?? "";

      });
      await fetchLatestLoanData();
    }
  }

  /// LOGIN FUNCTION
  Future login() async {
  final bikeInput = bikeController.text.trim().toUpperCase();
  final passInput = passwordController.text.trim(); // phone number

  if (bikeInput.isEmpty || passInput.isEmpty) return;

  setState(() {
    loading = true;
    bikeError = false;
  });

  try {
    // fetch data from Firebase
    final response = await http.get(Uri.parse(firebaseUrl));
    final List data = jsonDecode(response.body);

    bool found = false;
    String name = "";

    // skip first 3 rows if they are headers
    for (int i = 3; i < data.length; i++) {
      final row = data[i];

      // normalize bike number
      final rowBike = row[2].toString().trim().toUpperCase();
      final rowPassword = row[9].toString().trim(); // Column J (phone number)

      // compare bike number + phone number
      if (rowBike == bikeInput && rowPassword == passInput) {
        found = true;
        name = row[1].toString().trim(); // Column B (customer name)

        // save loan info
        bikeNumber = row[2].toString().trim();
        paid = double.tryParse(row[5].toString()) ?? 0;
        balance = double.tryParse(row[6].toString()) ?? 0;
        overdue = double.tryParse(row[8].toString()) ?? 0;

        // next due date formatting
        final rawNextDue = row[10].toString();
        nextDue = rawNextDue.isNotEmpty ? rawNextDue : "-";

        break;
      }
    }

    if (found) {
      // save locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", name);
      await prefs.setString("bike", bikeNumber);
      await prefs.setDouble("paid", paid);
      await prefs.setDouble("balance", balance);
      await prefs.setDouble("overdue", overdue);
      await prefs.setString("nextDue", nextDue);

      setState(() {
        loggedIn = true;
        userName = name;
        bikeError = false;
      });

      // refresh displayed data
      await fetchLatestLoanData();
    } else {
      setState(() {
        bikeError = true; // show red border if login fails
      });
    }
  } catch (e) {
    debugPrint(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Connection Error")),
    );
  }

  setState(() {
    loading = false;
  });
}
  Future fetchLatestLoanData() async {

  if (bikeNumber.isEmpty) return;

  try {

    final response =
        await http.get(Uri.parse(firebaseUrl));

    final List data =
        jsonDecode(response.body);

    for (int i = 1; i < data.length; i++) {

      final row = data[i];

      final rowBike =
          row[2].toString().trim();

      if (rowBike == bikeNumber) {

        setState(() {

          paid =
              double.tryParse(
                row[5].toString()) ?? 0;

          balance =
              double.tryParse(
                row[6].toString()) ?? 0;

          overdue =
              double.tryParse(
                row[8].toString()) ?? 0;

          final rawDate = row[10].toString();

          try {

            final parsed =
                DateTime.parse(rawDate).toLocal();

            nextDue =
                DateFormat("dd/MM/yyyy")
                    .format(parsed);

          } catch (e) {

            // fallback if not a date
            nextDue = rawDate;

          }

        });

        /// UPDATE LOCAL SAVE ALSO

        final prefs =
            await SharedPreferences
                .getInstance();

        await prefs.setDouble(
            "paid", paid);

        await prefs.setDouble(
            "balance", balance);

        await prefs.setDouble(
            "overdue", overdue);

        await prefs.setString(
            "nextDue", nextDue);

        break;
      }
    }

  } catch (e) {

    debugPrint(e.toString());

  }
}

  /// LOGOUT
  Future logout() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {

      loggedIn = false;

    });
  }

  /// INFO BOX UI
  Widget infoBox(
      String title,
      String value) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color:
            const Color.fromARGB(255, 255, 255, 255),

        borderRadius:
            BorderRadius.circular(12),
        boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(title,
              style:
                  const TextStyle(
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w400,
                fontSize: 10,
          )),

          const SizedBox(height: 6),

          Text(value,
              style:
                  const TextStyle(
                  fontFamily: 'Poppins-SemiBold',
                  fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    /// LOGGED IN SCREEN
    if (loggedIn) {

      return Scaffold(

        appBar: AppBar(
  backgroundColor: const Color.fromARGB(255, 16, 92, 177),

  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [

      // ======================
      // GREETING (SMALL TEXT)
      // ======================
      Text(
        "Welcome, $userName",
        style: const TextStyle(
          fontFamily: 'Poppins-Regular',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.white70,
        ),
      ),

      const SizedBox(height: 1),

      // ======================
      // BIKE NUMBER (BIG TEXT)
      // ======================
      Text(
        "Bike $bikeNumber",
        style: const TextStyle(
          fontFamily: 'Poppins-Bold',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
    ],
  ),

  actions: [


    // logout button
    IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: logout,
    ),
  ],
),

        body: Padding(

          padding:
              const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              

              const SizedBox(height: 20),

              Row(

                children: [

                  Expanded(

                    child: infoBox(
                        "Paid",
                        formatUGX(paid)),
                  ),

                  const SizedBox(width: 10),

                  Expanded(

                    child: infoBox(
                        "Balance",
                        formatUGX(balance)),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              infoBox(
                "Overdue",
                formatUGX(overdue),
              ),

              const SizedBox(height: 15),

              infoBox(
                "Due Next",
                nextDue,
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
  backgroundColor: const Color.fromARGB(255, 16, 92, 177),
  onPressed: loading
      ? null // disable button while loading
      : () async {
          setState(() {
            loading = true;
          });

          await fetchLatestLoanData(); // your refresh function

          setState(() {
            loading = false;
          });
        },
  child: loading
      ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
      : const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
),

      );
    }

    /// LOGIN SCREEN
    return Scaffold(

      body: Center(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

                  child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// APP ICON
            Image.asset(
              'lib/assets/icon/app_icon.png', // make sure this file is in assets/
              width: 120,
              height: 120,
            ),

            const SizedBox(height: 20),

            /// WELCOME TEXT
            const Text(
              "Log in to Track Your Journey to Ownership",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins-light',
                fontSize: 22,
                fontWeight: FontWeight.w300,
              ),
            ),

            const SizedBox(height: 30),

            /// USERNAME / BIKE NUMBER
            TextField(
              controller: bikeController,
              decoration: InputDecoration(
                labelText: "User Name",
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: bikeError ? Colors.red : Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: bikeError ? Colors.red : Colors.blue,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// PASSWORD (HIDDEN)
            TextField(
              controller: passwordController,
              obscureText: true, // <-- hides the password
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// LOGIN BUTTON
            ElevatedButton(
              onPressed: loading ? null : login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60), // matches typical TextField height
                backgroundColor: const Color.fromARGB(255, 16, 92, 177), // custom color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // same as TextField border
                ),
              ),
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}