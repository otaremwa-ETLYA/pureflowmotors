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

  bool loading = false;
  String? errorText;

  final String pinsUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/pins";

  // ============================
  // SIGN IN FUNCTION
  // ============================
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

    setState(() => loading = true);

    try {
      // Fetch bike from pins node
      final response = await http.get(Uri.parse("$pinsUrl/$bike.json"));

      if (response.body == "null") {
        setState(() {
          errorText = "Bike not signed up";
          loading = false;
        });
        return;
      }

      final Map<String, dynamic> data = json.decode(response.body);

      if (data["pin"] != pin) {
        setState(() {
          errorText = "Incorrect PIN";
          loading = false;
        });
        return;
      }

      // Save login info locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("bike", bike);
      await prefs.setString("name", "Customer"); // you can modify to fetch from sheetData later

      setState(() => loading = false);

      // Call parent callback
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        backgroundColor: const Color.fromARGB(255, 16, 92, 177),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // BIKE NUMBER
            TextField(
              controller: bikeController,
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
              obscureText: true,
              keyboardType: TextInputType.number,
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
                    borderRadius: BorderRadius.circular(5), // same as input boxes
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