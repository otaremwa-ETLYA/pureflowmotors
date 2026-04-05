import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'sign_up_screen.dart';
import 'main_navigation.dart';
import 'active_loan_screen.dart';

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

Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => const MainNavigation(),
  ),
  (route) => false, // removes all previous routes
);
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
      backgroundColor: Colors.grey[200], // optional for web
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [

                // 👇 CUSTOM APP BAR (now constrained)
                Container(
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 16, 92, 177),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: 'Poppins-Bold',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // balance back button
                    ],
                  ),
                ),

                // 👇 BODY (scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          const SizedBox(height: 10),

                          Image.asset(
                            'lib/assets/icon/app_icon.png',
                            height: 120,
                          ),

                          const SizedBox(height: 8),

                          const Text(
                          "Sign In to Keep Track of Your Journey Towards Owmership",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins-Bold',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 119, 119, 119),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 20),

                          TextField(
                            controller: bikeController,
                            focusNode: bikeFocus,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(pinFocus);
                            },
                            decoration: const InputDecoration(
                              labelText: "Bike Number",
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 20),

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

                          if (errorText != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              errorText!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],

                          const SizedBox(height: 30),

                          SizedBox(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}