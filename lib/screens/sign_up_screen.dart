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
  final TextEditingController confirmPinController = TextEditingController();

  final FocusNode bikeFocus = FocusNode();
  final FocusNode pinFocus = FocusNode();
  final FocusNode confirmPinFocus = FocusNode();

  bool loading = false;
  String? bikeError;

  final String sheetUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/sheetData.json";

  final String pinsUrl =
      "https://activeloaninfo-default-rtdb.firebaseio.com/pins";



  // ============================
  // SIGN UP FUNCTION
  // ============================
  @override
void initState() {
  super.initState();
  Future.delayed(const Duration(milliseconds: 300), () {
    FocusScope.of(context).requestFocus(bikeFocus);
  });
}

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

    if (bike.length < 7) {
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
      String enteredBike = bike.toLowerCase().trim();

      // ======================
      // CHECK BIKE IN SHEET
      // ======================

      final sheetResponse = await http.get(Uri.parse(sheetUrl));
      final sheetData = json.decode(sheetResponse.body);

      bool bikeExists = false;
      String? matchedBikeNumber;

      if (sheetData != null) {
        for (var row in sheetData) {
          if (row is List && row.length > 2) {
            String dbBike = row[2].toString().trim();
            String dbBikeLower = dbBike.toLowerCase();

            if (dbBikeLower.contains(enteredBike)) {
              bikeExists = true;
              matchedBikeNumber = dbBike;
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
      // CHECK IF PIN EXISTS
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
      // SAVE PIN
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

  @override
  void dispose() {
    bikeController.dispose();
    pinController.dispose();
    confirmPinController.dispose();
    bikeFocus.dispose();
    pinFocus.dispose();
    confirmPinFocus.dispose();
    super.dispose();
  }

  // ============================
  // UI
  // ============================

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[200],
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [

              // ✅ CUSTOM APP BAR (constrained)
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
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ✅ BODY
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

                        const SizedBox(height: 30),

                        // BIKE NUMBER
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

                        // CREATE PIN
                        TextField(
                          controller: pinController,
                          focusNode: pinFocus,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(confirmPinFocus);
                          },
                          decoration: const InputDecoration(
                            labelText: "Create PIN",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // CONFIRM PIN
                        TextField(
                          controller: confirmPinController,
                          focusNode: confirmPinFocus,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            signUp();
                          },
                          decoration: const InputDecoration(
                            labelText: "Re-enter PIN",
                            border: OutlineInputBorder(),
                          ),
                        ),

                        // ✅ ERROR TEXT (cleaner than inside TextField)
                        if (bikeError != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            bikeError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],

                        const SizedBox(height: 30),

                        // BUTTON (radius kept same = 5)
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: loading ? null : signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 16, 92, 177),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontFamily: 'Poppins-Bold',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
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