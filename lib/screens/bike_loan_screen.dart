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
  
  int currentIndex = 0; // stores the index of the currently selected bike

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
    initialPage: 0,
  );

  // 👇 listen to repository updates
  bikesRepository.onUpdate = () {
    setState(() {
      if (bikes.isNotEmpty && selectedBike == null) {
        currentIndex = 0;
        selectedBike = bikes[0];
      }
    });
  };
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
  void _showApplyPopup() {
    showModalBottomSheet(
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
);
}

  // ================================
  // UI
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
  toolbarHeight: 85, // taller AppBar
  backgroundColor: const Color.fromARGB(255, 16, 92, 177),
  elevation: 15, // subtle shadow
  shadowColor: Colors.black.withOpacity(0.3),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(10), // rounded bottom corners
    ),
  ),
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text(
        "Asset Financing",
        style: TextStyle(
          fontFamily: 'Poppins-Bold',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 2),
      Text(
        "Kingdom Initiatives Transforming Communities",
        style: TextStyle(
          fontFamily: 'Poppins-Regular',
          fontWeight: FontWeight.w400,
          fontSize: 14,
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
             const SizedBox(height: 8),
             Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 92, 177),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "To Get Started",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Poppins-Bold',
        ),
      ),
    ),

    const SizedBox(width: 10),

    const Expanded(
      child: Text(
        "Choose a Bike And The Desired Loan Specifications to Begin Your Journey Towards Ownership. Blessings!",
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'Poppins-Bold',
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
          height: 1.5,
        ),
      ),
    ),
  ],
),


            SizedBox(
  height: 220,
  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        //maxWidth: 400, // ← limit width here
      ),
      child: PageView.builder(
        controller: bikePageController,
        itemCount: bikes.length, 

        onPageChanged: (index) {
        setState(() {
          currentIndex = index;
          selectedBike = bikes[currentIndex];

          // Reset dependent selections
          selectedDownPayment = null;
          selectedDuration = null;
          selectedWeeklyPayment = null;
          freezeFiltering = false;
        });
},


        itemBuilder: (context, index) {
          final bike = bikes[index]; // no modulo
          final isSelected = index == currentIndex;
          
          

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
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 40),
                        );
                      },
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
                borderRadius: BorderRadius.circular(5),
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
                dropdownColor: Colors.white,
                hint: Text(
                  "Choose a bike",
                  style: TextStyle(
                    fontFamily: 'Poppins-SemiBold',
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
                        fontFamily: 'Poppins-SemiBold',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (bike) {
                final index = bikes.indexOf(bike!);
                setState(() {
                  currentIndex = index;
                  selectedBike = bike;

                  // Reset dependent selections
                  selectedDownPayment = null;
                  selectedDuration = null;
                  selectedWeeklyPayment = null;
                  freezeFiltering = false;
                });

                bikePageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
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
        padding: const EdgeInsets.symmetric(horizontal: 8), // reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.transparent),
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
          dropdownColor: Colors.white, // dropdown list background
          icon: const Icon( // visible arrow
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),

          hint: const Text(
            "Select",
            style: TextStyle(
              fontFamily: 'Poppins-Semibold',
              fontWeight: FontWeight.w400,
              fontSize: 12, // smaller text
              color: Colors.grey, // grey color
            ),
          ),

          value: selectedDownPayment,

          items: getAvailableDownPayments().map((dp) {
            return DropdownMenuItem<int>(
              value: dp,
              child: Text(
                formatUGX(dp),
                style: const TextStyle(
                  fontFamily: 'Poppins-Semibold',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
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
        padding: const EdgeInsets.symmetric(horizontal: 8), // reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.transparent),
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
          dropdownColor: Colors.white, // dropdown list background
          icon: const Icon( // visible arrow
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),

          hint: const Text(
            "Select",
            style: TextStyle(
              fontFamily: 'Poppins-Semibold',
              fontWeight: FontWeight.w400,
              fontSize: 12, // smaller text
              color: Colors.grey, // grey color
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
                  fontSize: 13,
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
        padding: const EdgeInsets.symmetric(horizontal: 8), // reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.transparent),
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
          dropdownColor: Colors.white, // dropdown list background
          icon: const Icon( // arrow icon added
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),

          hint: const Text(
            "Select",
            style: TextStyle(
              fontFamily: 'Poppins-Semibold',
              fontWeight: FontWeight.w400,
              fontSize: 12, // smaller text
              color: Colors.grey, // grey color
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
                  fontSize: 13,
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
                    fontSize: 14,
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
    borderRadius: BorderRadius.circular(5),
    border: Border.all(
      color: const Color.fromARGB(255, 160, 144, 249),
    ),
  ),
  child: Stack(
    children: [
      // -------------------
      // CARD CONTENT
      // -------------------
      Column(
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
          const SizedBox(height: 16), // extra spacing so button doesn't cover text
        ],
      ),

      // -------------------
      // APPLY BUTTON (OVERLAY)
      // -------------------
      Positioned(
        bottom: 0,
        right: 0,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // radius 5
            ),
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

