import 'package:flutter/material.dart';
import '../models/bike.dart';
import '../models/loan_option.dart';
import '../data/bikes_data.dart';
import '../utils/formatters.dart';

class BikeLoanScreen extends StatefulWidget {
  const BikeLoanScreen({super.key});

  @override
  State<BikeLoanScreen> createState() => _BikeLoanScreenState();
}

class _BikeLoanScreenState extends State<BikeLoanScreen> {
  
  bool freezeFiltering = false;

  Bike? selectedBike;
  int? selectedDownPayment;
  int? selectedDuration;
  double? selectedWeeklyPayment;

  bool get isFullMatch =>
      selectedDownPayment != null &&
      selectedDuration != null &&
      selectedWeeklyPayment != null;

  bool get hasFullSelection => isFullMatch;

  // ================================
  // FILTER LOGIC
  // ================================
  List<int> getAvailableDownPayments() {
    if (selectedBike == null) return [];
    if (freezeFiltering) {
      return selectedBike!.loanOptions.map((e) => e.downPayment).toSet().toList();
    }
    return selectedBike!.loanOptions
        .where((loan) =>
            (selectedDuration == null || loan.durationWeeks == selectedDuration) &&
            (selectedWeeklyPayment == null || loan.weeklyPayment == selectedWeeklyPayment))
        .map((e) => e.downPayment)
        .toSet()
        .toList();
  }

  List<int> getAvailableDurations() {
    if (selectedBike == null) return [];
    if (freezeFiltering) {
      return selectedBike!.loanOptions.map((e) => e.durationWeeks).toSet().toList();
    }
    return selectedBike!.loanOptions
        .where((loan) =>
            (selectedDownPayment == null || loan.downPayment == selectedDownPayment) &&
            (selectedWeeklyPayment == null || loan.weeklyPayment == selectedWeeklyPayment))
        .map((e) => e.durationWeeks)
        .toSet()
        .toList();
  }

  List<double> getAvailableWeeklyPayments() {
    if (selectedBike == null) return [];
    if (freezeFiltering) {
      return selectedBike!.loanOptions.map((e) => e.weeklyPayment).toSet().toList();
    }
    return selectedBike!.loanOptions
        .where((loan) =>
            (selectedDownPayment == null || loan.downPayment == selectedDownPayment) &&
            (selectedDuration == null || loan.durationWeeks == selectedDuration))
        .map((e) => e.weeklyPayment)
        .toSet()
        .toList();
  }

  // ================================
  // UI
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        title: Text(
          "Asset Financing",
          style: const TextStyle(
            fontFamily: 'FrizQuadrata',
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================
            // BIKE DROPDOWN (TOP)
            // ======================
            Text(
              "Select Bike",
              style: TextStyle(
                fontFamily: 'Avenir', // Avenir Light
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: DropdownButton<Bike>(
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text(
                  "Choose a bike",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                  ),
                ),
                value: selectedBike,
                items: bikes.map((bike) {
                  return DropdownMenuItem<Bike>(
                    value: bike,
                    child: Text(
                      bike.name,
                      style: const TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (bike) {

                  setState(() {

                    selectedBike = bike;

                    // Reset ALL selections
                    selectedDownPayment = null;
                    selectedDuration = null;
                    selectedWeeklyPayment = null;

                    // VERY IMPORTANT
                    freezeFiltering = false;

                  });

                },
              ),
            ),

            const SizedBox(height: 30),

            // ======================
            // THREE DROPDOWNS ROW
            // ======================
            if (selectedBike != null)
              Row(
                children: [
                  // Down Payment
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Down Payment",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                            value: selectedDownPayment,
                            items: getAvailableDownPayments().map((dp) {
                              return DropdownMenuItem<int>(
                                value: dp,
                                child: Text(
                                  formatUGX(dp),
                                  style: const TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {

                              final wasFullMatch = isFullMatch;

                              setState(() {

                                // user changing mind after match
                                if (wasFullMatch) {

                                  selectedDuration = null;
                                  selectedWeeklyPayment = null;

                                  freezeFiltering = false; // resume filtering
                                }

                                selectedDownPayment = value;

                                // new full match reached
                                if (isFullMatch) {
                                  freezeFiltering = true;
                                }

                              });

                              },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Duration
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Duration",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                            value: selectedDuration,
                            items: getAvailableDurations().map((dur) {
                              return DropdownMenuItem<int>(
                                value: dur,
                                child: Text(
                                  "${(dur / 52).toStringAsFixed(1)} yrs",
                                  style: const TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {

                              final wasFullMatch = isFullMatch;

                              setState(() {

                                if (wasFullMatch) {

                                  selectedDownPayment = null;
                                  selectedWeeklyPayment = null;

                                  freezeFiltering = false;
                                }

                                selectedDuration = value;

                                if (isFullMatch) {
                                  freezeFiltering = true;
                                }

                              });

                              },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Weekly Payment
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Weekly Payment",
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: DropdownButton<double>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.w300,
                                color: Colors.black54,
                              ),
                            ),
                            value: selectedWeeklyPayment,
                            items: getAvailableWeeklyPayments().map((wp) {
                              return DropdownMenuItem<double>(
                                value: wp,
                                child: Text(
                                  formatUGX(wp.toInt()),
                                  style: const TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (double? value) {

                              final wasFullMatch = isFullMatch;

                              setState(() {

                                if (wasFullMatch) {

                                  selectedDownPayment = null;
                                  selectedDuration = null;

                                  freezeFiltering = false;
                                }

                                selectedWeeklyPayment = value;

                                if (isFullMatch) {
                                  freezeFiltering = true;
                                }

                              });

                              },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 30),

            // ======================
            // SUMMARY CARD
            // ======================
            if (hasFullSelection)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(174, 119, 178, 245),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loan Summary",
                      style: const TextStyle(
                        fontFamily: 'FrizQuadrata',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text("Bike: ${selectedBike!.name}",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.white70,
                        )),
                    Text("Down Payment: ${formatUGX(selectedDownPayment!)}",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.white70,
                        )),
                    Text(
                        "Duration: ${(selectedDuration! / 52).toStringAsFixed(1)} yrs",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.white70,
                        )),
                    Text(
                        "Weekly Payment: ${formatUGX(selectedWeeklyPayment!.round())}",
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.white70,
                        )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
