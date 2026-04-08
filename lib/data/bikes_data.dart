import 'package:firebase_database/firebase_database.dart';
import '../models/bike.dart';
import '../models/loan_option.dart';

class BikesRepository {
  final DatabaseReference db = FirebaseDatabase.instance.ref("bikeLoans");

  List<Bike> _bikes = [];

  /// Getter for UI
  List<Bike> get bikes => _bikes;

  /// Map bike name → image path
  final Map<String, String> _bikeImages = {
    "Alloy Wheel Boxer": "lib/assets/bikes/boxer_alloy_wheel.png",
    "Bajaj Boxer": "lib/assets/bikes/bajaj_boxer.png",
    "Bajaj CT": "lib/assets/bikes/ct_23.png",
    "HAOJUE EG 150CC": "lib/assets/bikes/haojue_eg.png",
    "HAOJUE EG AND XPRESS 125CC": "lib/assets/bikes/haojue_XPRESSS.png",
    "HAOJUE XPRESS PLUS 125CC": "lib/assets/bikes/haojue_express_plus125cc.png",
    "HONDA 110": "lib/assets/bikes/honda_110.png",
    "Honda 125": "lib/assets/bikes/honda_125.png",
    "KEVLA 125": "lib/assets/bikes/kevla_125.png",
    "TVS STAR HLX 125CC": "lib/assets/bikes/tvs_star_hlx125.png",
    "TVS STAR HLX 125CC (5G)": "lib/assets/bikes/tvs_star_hlx125_5g.png",
    "TVS STAR HLX PLUS ES 100CC": "lib/assets/bikes/tvs_star_hlx_100CC.png",
  };
  

  /// Start listening to bikes in Firebase (live updates)
  void startListening() {
    db.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value == null) {
        _bikes = [];
        return;
      }

      final data = _convertToMap(value) as Map<String, dynamic>;

      List<Bike> loadedBikes = [];

      data.forEach((bikeName, downPaymentMap) {
        List<LoanOption> loanOptions = [];

        final paymentsByDownPayment =
            _convertToMap(downPaymentMap) as Map<String, dynamic>;

        paymentsByDownPayment.forEach((downPaymentStr, durationsMap) {
          final durations =
              _convertToMap(durationsMap) as Map<String, dynamic>;

          durations.forEach((durationStr, weeklyPaymentValue) {
            final downPayment =
                int.tryParse(downPaymentStr.toString()) ?? 0;

            final durationWeeks =
                int.tryParse(durationStr.toString()) ?? 0;

            final weeklyPayment = weeklyPaymentValue is num
                ? weeklyPaymentValue.toDouble()
                : double.tryParse(weeklyPaymentValue.toString()) ?? 0.0;

            loanOptions.add(
              LoanOption(
                downPayment: downPayment,
                durationWeeks: durationWeeks,
                weeklyPayment: weeklyPayment,
              ),
            );
          });
        });

        loadedBikes.add(
          Bike(
            name: bikeName.toString(),
            imageUrl: _bikeImages[bikeName.toString()] ??
                "lib/assets/bikes/honda_125.png",
            category: "Standard",
            loanOptions: loanOptions,
          ),
        );
      });

      _bikes = loadedBikes;
    });
  }

  /// Converts JS objects to Dart Map safely
  dynamic _convertToMap(dynamic obj) {
    if (obj is Map) {
      return obj.map((k, v) => MapEntry(k.toString(), _convertToMap(v)));
    }
    return obj;
  }
}

/// Singleton repository
final BikesRepository bikesRepository = BikesRepository();

/// Backwards compatible getter
List<Bike> get bikes => bikesRepository.bikes;