import 'package:flutter/material.dart';
import '../models/bike.dart';
import '../models/loan_option.dart';
import '../data/bikes_data.dart';
import '../utils/formatters.dart';
import 'package:url_launcher/url_launcher.dart';

class BikeLoanScreen extends StatefulWidget {
  const BikeLoanScreen({super.key});

  @override
  State<BikeLoanScreen> createState() => _BikeLoanScreenState();
}

// =============================================================
// 🔥 NEW WIDGET: WHATSAPP BRANCH OPTION
// =============================================================
class WhatsAppBranchOption extends StatelessWidget {
  final String name;
  final String number;

  final String bike;
  final String downPayment;
  final String duration;
  final String weeklyPayment;

  const WhatsAppBranchOption({
    super.key,
    required this.name,
    required this.number,
    required this.bike,
    required this.downPayment,
    required this.duration,
    required this.weeklyPayment,
  });

  Future<void> openChat(BuildContext context) async {

    final message =
        "Hello $name,\n\n"
        "I would like to apply for a bike loan.\n\n"
        "Bike: $bike\n"
        "Down Payment: $downPayment\n"
        "Duration: $duration\n"
        "Weekly Payment: $weeklyPayment";

    final Uri uri = Uri.parse(
      "https://wa.me/$number?text=${Uri.encodeComponent(message)}",
    );

    await launchUrl(uri);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        "lib/assets/icon/whatsapp.png",
        width: 26,
        height: 26,
      ),
      title: Text(name),
      onTap: () => openChat(context),
    );
  }
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
String _bikeName = "";
  String _downPaymentText = "";
  String _durationText = "";
  String _weeklyPaymentText = "";

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

    // =========================================================
  // 🔥 NEW: APPLY POPUP (WHATSAPP BRANCH SELECTOR)
  // =========================================================
  void _showApplyPopup() {showModalBottomSheet(
  context: context,

  // 🔥 important for long branch list
  isScrollControlled: true,

  // 🔥 keeps true mobile bottom sheet behavior
  useSafeArea: true,

  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
  ),

  builder: (context) {
    return Padding(  
      padding: const EdgeInsets.all(16),
      
        child: Container(
      width: double.infinity,
      // 🔥 this mimics mobile screen width even on web
      constraints: const BoxConstraints(maxWidth: 400),

      // 🔥 NO ConstrainedBox → prevents web "desktop centering"
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          const Text(
            "Choose Branch",
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Poppins-Bold',
            ),
          ),

          const SizedBox(height: 16),

          // 🔥 FIX OVERFLOW + KEEP MOBILE FEEL
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // =========================
                  // ALL YOUR BRANCHES (UNCHANGED)
                  // =========================

                  WhatsAppBranchOption(
                    name: "Mbarara Branch",
                    number: "256755015732",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Ibanda",
                    number: "256788146323",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Jinja",
                    number: "256747658825",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Ishaka",
                    number: "256789970658",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Ntungamo",
                    number: "256706660271",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Rukungiri",
                    number: "256774825245",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Kihihi",
                    number: "256704171448",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Lyantonde",
                    number: "256772997931",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Fort Portal",
                    number: "256758240129",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Masaka",
                    number: "256700742866",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Iganga",
                    number: "256774681161",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Mukono",
                    number: "256705780046",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Nansana",
                    number: "256759554141",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),

                  WhatsAppBranchOption(
                    name: "Luwero",
                    number: "256751792660",
                    bike: _bikeName,
                    downPayment: _downPaymentText,
                    duration: _durationText,
                    weeklyPayment: _weeklyPaymentText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  },
);}

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
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400, // ← limit width here
      ),
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

        itemBuilder: (context, index) {
          final bike = bikes[index % bikes.length];

          final isSelected =
              selectedBike?.name == bike.name;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),

            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: isSelected ? 10 : 30,
            ),

            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.0 : 0.50,

              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isSelected ? 1.0 : 0.65,

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),

                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                      bike.imageUrl,
                      fit: BoxFit.contain,
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
              Column(crossAxisAlignment: CrossAxisAlignment.start,
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

                      const SizedBox(height: 5),

                      // =================================================
                      // 🔥 APPLY BUTTON (FIXED - WAS POSITIONED BEFORE)
                      // =================================================
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {

                            // store summary BEFORE popup
                            _bikeName = selectedBike!.name;
                            _downPaymentText = formatUGX(selectedDownPayment!);
                            _durationText =
                                "${(selectedDuration! / 52).toStringAsFixed(1)} yrs";
                            _weeklyPaymentText =
                                formatUGX(selectedWeeklyPayment!.round());

                            _showApplyPopup();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color.fromARGB(255, 16, 92, 177),
                          ),
                          child: const Text("Apply"),
                        ),
                      ),

                    ],
                  ),
                ),
            ],)
          ],
        ),
      ),
    );
  }



  
}

