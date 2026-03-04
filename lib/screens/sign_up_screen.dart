import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController bikeController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController =
      TextEditingController();

  bool loading = false;
  String? bikeError;

  final String sheetUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/sheetData.json";

  final String pinsUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/pins";

  // ============================
  // SIGN UP FUNCTION
  // ============================

  Future<void> signUp() async {
  setState(() {
    bikeError = null;
  });

  String bike = bikeController.text.trim();
  String pin = pinController.text.trim();
  String confirmPin = confirmPinController.text.trim();

  if (bike.isEmpty || pin.isEmpty || confirmPin.isEmpty) {
    setState(() {
      bikeError = "All fields required";
    });
    return;
  }
  // ✅ Require full bike number (minimum 8 characters)
if (bike.length < 8) {
  setState(() {
    bikeError = "Enter full Bike Number.";
  });
  return;
}

  if (pin != confirmPin) {
    setState(() {
      bikeError = "Pins do not match";
    });
    return;
  }

  setState(() => loading = true);

  try {
    // Normalize user input
    String enteredBike = bike.toLowerCase().trim();

    // ======================
    // 1️⃣ CHECK IF BIKE EXISTS IN SHEET (COLUMN C)
    // ======================

    final sheetResponse = await http.get(Uri.parse(sheetUrl));
    final sheetData = json.decode(sheetResponse.body);

    bool bikeExists = false;
    String? matchedBikeNumber; // Store real DB value

    if (sheetData != null) {
      for (var row in sheetData) {
        if (row is List && row.length > 2) {
          String dbBike = row[2].toString().trim();
          String dbBikeLower = dbBike.toLowerCase();

          if (dbBikeLower.contains(enteredBike)) {
            bikeExists = true;
            matchedBikeNumber = dbBike; // Save exact DB value
            break;
          }
        }
      }
    }

    if (!bikeExists || matchedBikeNumber == null) {
      setState(() {
        bikeError = "Wrong bike number";
        loading = false;
      });
      return;
    }

    // ======================
    // 2️⃣ CHECK IF BIKE ALREADY IN PINS NODE
    // ======================

    final pinCheck =
        await http.get(Uri.parse("$pinsUrl/$matchedBikeNumber.json"));

    if (pinCheck.body != "null") {
      setState(() {
        bikeError = "Bike already signed in. Sign in?";
        loading = false;
      });
      return;
    }

    // ======================
    // 3️⃣ SAVE PIN TO FIREBASE
    // ======================

    await http.put(
      Uri.parse("$pinsUrl/$matchedBikeNumber.json"),
      body: json.encode({
        "pin": pin,
      }),
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account Created Successfully")),
    );

    Navigator.pop(context);
  } catch (e) {
    setState(() {
      bikeError = "Connection error";
      loading = false;
    });
  }
}

  // ============================
  // UI
  // ============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up",
        style: TextStyle(
          fontFamily: 'Poppins-Bold',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        backgroundColor:
            const Color.fromARGB(255, 16, 92, 177),
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
                errorText: bikeError,
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // PIN
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Create PIN",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // CONFIRM PIN
            TextField(
              controller: confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Re-enter PIN",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: loading ? null : signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 16, 92, 177),
                minimumSize:
                    const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // same as input boxes
                  ),
              ),
              child: loading
                  ? const CircularProgressIndicator(
                      color: Colors.white)
                  : const Text("Create Account",
                  style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                  ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}