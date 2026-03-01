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

  late PageController bikePageController;
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

//late PageController bikePageController;

@override
void initState() {

  super.initState();

  bikePageController = PageController(
    viewportFraction: 0.7,
    initialPage: 1000, // fake infinite scroll
  );

  // ⭐ VERY IMPORTANT
  // Select first bike AFTER screen builds
  WidgetsBinding.instance.addPostFrameCallback((_) {

    final bikeIndex = 1000 % bikes.length;

    setState(() {

      selectedBike = bikes[bikeIndex];

    });

  });

}

@override
void dispose() {
  bikePageController.dispose();
  super.dispose();
}

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 16, 92, 177),
        //centerTitle: true,
       title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [

          Text(
            "Asset Financing",
            style: TextStyle(
              fontFamily: 'Poppins-Bold',
              fontWeight: FontWeight.bold,
              fontSize: 22, // AppBar works better around 20–24
              color: Colors.white,
            ),
          ),

          SizedBox(height: 2),

          Text(
            "Kingdom Initiatives Transforming Communities",
            style: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            SizedBox(
            height: 220,

            child: PageView.builder(

            controller: bikePageController,

            onPageChanged: (index) {

              final bikeIndex = index % bikes.length;

              setState(() {

                selectedBike = bikes[bikeIndex];

                selectedDownPayment = null;
                selectedDuration = null;
                selectedWeeklyPayment = null;

                freezeFiltering = false;

              });

            },

            itemBuilder: (context,index){

              final bike = bikes[index % bikes.length];

              final isSelected =
                  selectedBike?.name == bike.name;

              return AnimatedContainer(

                duration: const Duration(milliseconds:300),

                margin: EdgeInsets.symmetric(
                  horizontal:10,
                  vertical: isSelected ? 10 : 30,
                ),

                // decoration: BoxDecoration(

                //   borderRadius: BorderRadius.circular(16),

                //   boxShadow: [

                //     if (isSelected)
                //       BoxShadow(
                //         color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.20),
                //         blurRadius: 12,
                //         offset: const Offset(0,4),
                //       )

                //   ],
                // ),

                // ⭐ SCALE + OPACITY ADDED HERE
                child: AnimatedScale(

                  duration: const Duration(milliseconds:300),

                  scale: isSelected ? 1.0 : 0.50,

                  child: AnimatedOpacity(

                    duration: const Duration(milliseconds:300),

                    opacity: isSelected ? 1.0 : 0.65,

                    child: ClipRRect(

                      borderRadius: BorderRadius.circular(16),

                      child: Stack(

                        fit: StackFit.expand,

                        children: [

                          Image.asset(
                            bike.imageUrl,
                            fit: BoxFit.cover,
                          ),

                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.all(8),

                            color: Colors.transparent,

                          )

                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    ),
          ),

          const SizedBox(height:20),
            // ======================
            // BIKE DROPDOWN (TOP)
            // ======================
            Text(
              "Select Bike",
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontWeight: FontWeight.w400,
                fontSize: 10,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color.fromARGB(0, 144, 202, 249)!),
                boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
              ),
              child: DropdownButton<Bike>(
                isExpanded: true,
                underline: const SizedBox(),
                hint: Text(
                  "Choose a bike",
                  style: TextStyle(
                    fontFamily: 'Poppins-SemiBold',
                    //fontWeight: FontWeight.w300,
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
                        fontFamily: 'Poppins-SemiBold',
                        //fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (bike) {

                  setState(() {

                    selectedBike = bike;

                    selectedDownPayment = null;
                    selectedDuration = null;
                    selectedWeeklyPayment = null;

                    // VERY IMPORTANT
                    freezeFiltering = false;

                    // move gallery
                    final index = bikes.indexOf(bike!);

                    bikePageController.animateToPage(
                      1000 + index,
                      duration: const Duration(milliseconds:400),
                      curve: Curves.easeInOut,
                    );

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
                          "Down Payment(ugx)",
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color.fromARGB(0, 144, 202, 249)!),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const SizedBox.shrink(),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Poppins-SemiBold',
                                fontWeight: FontWeight.w600,
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
                                    fontFamily: 'Poppins-SemiBold',
                                    fontWeight: FontWeight.w600,
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
                          "Duration(Years)",
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color.fromARGB(0, 144, 202, 249)!),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const SizedBox.shrink(),
                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Poppins-Semibold',
                                fontWeight: FontWeight.w600,
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
                                    fontFamily: 'Poppins-Semibold',
                                    fontWeight: FontWeight.w600,
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
                          "Weekly Payment(ugx)",
                          style: TextStyle(
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 254, 254, 254),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color.fromARGB(0, 144, 202, 249)!),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButton<double>(
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const SizedBox.shrink(),

                            hint: Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Poppins-Semibold',
                                fontWeight: FontWeight.w600,
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
                                    fontFamily: 'Poppins-Semibold',
                                    fontWeight: FontWeight.w600,
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
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER OUTSIDE
              const Text(
                "Loan Summary",
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87, // change if needed
                ),
              ),

              const SizedBox(height: 10),

              /// CONTAINER BELOW HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 92, 177),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 160, 144, 249),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Bike: ${selectedBike!.name}",
                      style: const TextStyle(
                        fontFamily: 'Poppins-Medium',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                      
                    Text(
                      "Down Payment: ${formatUGX(selectedDownPayment!)}",
                      style: const TextStyle(
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Duration: ${(selectedDuration! / 52).toStringAsFixed(1)} yrs",
                      style: const TextStyle(
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Weekly Payment: ${formatUGX(selectedWeeklyPayment!.round())}",
                      style: const TextStyle(
                        fontFamily: 'Poppins-Light',
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          )
          ],
        ),
      ),
    );
  }
}
