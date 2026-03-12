import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const SignInScreen({super.key, required this.onLoginSuccess});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController bikeController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  final FocusNode bikeFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();

  bool loading = false;
  String? errorText;

  final String pinsUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/pins";

  // ============================
  // SIGN IN FUNCTION
  // ============================
  @override
void initState() {
  super.initState();
  Future.delayed(Duration(milliseconds: 300), () {
    FocusScope.of(context).requestFocus(bikeFocus);
  });
}

  Future<void> signIn() async {
    setState(() {
      errorText = null;
    });

    String bike = bikeController.text.trim();
    String pin = pinController.text.trim();

    if (bike.isEmpty || pin.isEmpty) {
      setState(() {
        errorText = "All fields are required";
      });
      return;
    }

    // Require at least 8 characters
    if (bike.length < 7) {
      setState(() {
        errorText = "Enter full Bike Number.";
      });
      return;
    }

    setState(() => loading = true);

    try {
      String enteredBike = bike.toLowerCase().trim();

      // ======================
      // FETCH ALL PINS
      // ======================

      final response = await http.get(Uri.parse("$pinsUrl.json"));

      if (response.body == "null") {
        setState(() {
          errorText = "Bike not signed up";
          loading = false;
        });
        return;
      }

      final Map<String, dynamic> allPins = json.decode(response.body);

      String? matchedBikeKey;
      Map<String, dynamic>? matchedBikeData;

      // ======================
      // FIND MATCH
      // ======================

      allPins.forEach((key, value) {
        String dbKeyLower = key.toLowerCase();

        if (dbKeyLower.contains(enteredBike)) {
          matchedBikeKey = key;
          matchedBikeData = value;
        }
      });

      if (matchedBikeKey == null || matchedBikeData == null) {
        setState(() {
          errorText = "Bike not signed up";
          loading = false;
        });
        return;
      }

      // ======================
      // CHECK PIN
      // ======================

      if (matchedBikeData!["pin"] != pin) {
        setState(() {
          errorText = "Incorrect PIN";
          loading = false;
        });
        return;
      }

      // ======================
      // SAVE LOGIN INFO
      // ======================

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("bike", matchedBikeKey!);
      await prefs.setString("name", "Customer");

      setState(() => loading = false);

      widget.onLoginSuccess();
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorText = "Connection error";
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    bikeController.dispose();
    pinController.dispose();
    bikeFocus.dispose();
    pinFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign In",
          style: TextStyle(
            fontFamily: 'Poppins-Bold',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 16, 92, 177),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // APP ICON
            const SizedBox(height: 10),
            Image.asset(
              'lib/assets/icon/app_icon.png',
              height: 120,
            ),
            const SizedBox(height: 30),

            // BIKE NUMBER
            TextField(
              controller: bikeController,
              focusNode: bikeFocus,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(pinFocus);
              },
              decoration: InputDecoration(
                labelText: "Bike Number",
                border: const OutlineInputBorder(),
                errorText: errorText,
              ),
            ),

            const SizedBox(height: 20),

            // PIN
            TextField(
              controller: pinController,
              focusNode: pinFocus,
              obscureText: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                signIn();
              },
              decoration: const InputDecoration(
                labelText: "PIN",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // SIGN IN BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 16, 92, 177),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Sign In",
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // SIGN UP LINK
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignUpScreen(),
                  ),
                );
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}