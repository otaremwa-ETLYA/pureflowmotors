import '../models/bike.dart';
import '../models/loan_option.dart';

/// Helper to reduce repetition
List<LoanOption> buildLoanOptions(
  int downPayment,
  Map<int, double> weeklyByDuration,
) {
  return weeklyByDuration.entries
      .map(
        (e) => LoanOption(
          downPayment: downPayment,
          durationWeeks: e.key,
          weeklyPayment: e.value,
        ),
      )
      .toList();
}

final List<Bike> bikes = [

  // =========================
  // BAJAJ BOXER
  // =========================
  Bike(
    name: "Bajaj Boxer",
    imageUrl: "lib/assets/bikes/bajaj_boxer.png",
    category: "Standard",
    loanOptions: [
      ...buildLoanOptions(950000, {130: 76920,117: 81518,104: 87266,78: 104511,52: 138999}),
      ...buildLoanOptions(1050000,{130: 75504,117: 80017,104: 85659,78: 102582,52: 136430}),
      ...buildLoanOptions(1250000,{130: 72674,117: 77016,104: 82443,78: 98726,52: 131291}),
      ...buildLoanOptions(1550000,{130: 68427,117: 72513,104: 77620,78: 92941,52: 123584}),
      ...buildLoanOptions(2050000,{130: 61351,117: 65009,104: 69582,78: 83300,52: 110737}),
    ],
  ),

  // =========================
  // ALLOY WHEEL BOXER BAJAJ
  // =========================
  Bike(
    name: "Alloy Wheel Boxer Bajaj",
    imageUrl: "lib/assets/bikes/Boxer_alloy_wheel.png",
    category: "Standard",
    loanOptions: [
      ...buildLoanOptions(950000,{130:78512,117:83207,104:89075,78:106680,52:141889}),
      ...buildLoanOptions(1050000,{130:77097,117:81706,104:87467,78:104752,52:139320}),
      ...buildLoanOptions(1250000,{130:74266,117:78704,104:84252,78:100895,52:134182}),
      ...buildLoanOptions(1550000,{130:70020,117:74202,104:79429,78:95111,52:126474}),
      ...buildLoanOptions(2050000,{130:62943,117:66697,104:71390,78:85469,52:113628}),
    ],
  ),

  // =========================
  // CT 23
  // =========================
  Bike(
    name: "CT 125CC",
    imageUrl: "lib/assets/bikes/CT_23.png",
    category: "Standard",
    loanOptions: [
      ...buildLoanOptions(950000,{130:71683,117:75965,104:81318,78:97376,52:129493}),
      ...buildLoanOptions(1050000,{130:70267,117:74464,104:79710,78:95448,52:126924}),
      ...buildLoanOptions(1250000,{130:67437,117:71462,104:76495,78:91592,52:121785}),
      ...buildLoanOptions(1550000,{130:63191,117:66960,104:71672,78:85807,52:114077}),
      ...buildLoanOptions(2050000,{130:56114,117:59456,104:63633,78:76166,52:101231}),
    ],
  ),

  // =========================
  // HAOJUE XPRESS PLUS 125CC
  // =========================
  Bike(
    name: "Haojue Xpress Plus 125CC",
    imageUrl: "lib/assets/bikes/haojue_express_plus125cc.png",
    category: "Scooter",
    loanOptions: [
      ...buildLoanOptions(950000,{117:84145,104:89914,78:107222,52:141839}),
      ...buildLoanOptions(1050000,{117:82644,104:88306,78:105294,52:139270}),
      ...buildLoanOptions(1250000,{117:79642,104:85091,78:101438,52:134131}),
      ...buildLoanOptions(1550000,{117:75139,104:80268,78:95653,52:126424}),
      ...buildLoanOptions(2050000,{117:67635,104:72229,78:86012,52:113577}),
    ],
  ),

  // =========================
  // HAOJUE EG & XPRESS 125CC
  // =========================
  Bike(
    name: "Haojue EG and Xpress 125CC",
    imageUrl: "lib/assets/bikes/haojue_XPRESs.png",
    category: "Scooter",
    loanOptions: [
      ...buildLoanOptions(950000,{117:79642,104:85091,78:101438,52:134131}),
      ...buildLoanOptions(1050000,{117:78141,104:83483,78:99509,52:131562}),
      ...buildLoanOptions(1250000,{117:75139,104:80268,78:95653,52:126424}),
      ...buildLoanOptions(1550000,{117:70637,104:75445,78:89868,52:118716}),
      ...buildLoanOptions(2050000,{117:63133,104:67406,78:80227,52:105870}),
    ],
  ),

  // =========================
  // HAOJUE EG 150CC
  // =========================
  Bike(
    name: "Haojue EG 150CC",
    imageUrl: "lib/assets/bikes/haojue_eg.png",
    category: "Standard",
    loanOptions: [
      ...buildLoanOptions(950000,{117:75890,104:81072,78:96617,52:127708}),
      ...buildLoanOptions(1050000,{117:68386,104:73033,78:86976,52:114862}),
      ...buildLoanOptions(1250000,{117:60881,104:64995,78:77335,52:102016}),
      ...buildLoanOptions(1550000,{117:53377,104:56956,78:67694,52:89170}),
      ...buildLoanOptions(2050000,{117:68386,104:73033,78:86976,52:114862}),
    ],
  ),

  // =========================
  // HONDA 110
  // =========================
  Bike(
    name: "Honda 110",
    imageUrl: "lib/assets/bikes/honda_110.png",
    category: "Standard",
    loanOptions: [
      ...buildLoanOptions(950000,{104:80201.68,78:95651.04,52:126549.75}),
      ...buildLoanOptions(1050000,{104:78593.98,78:93722.83,52:123980.52}),
      ...buildLoanOptions(1250000,{104:75378.60,78:89866.42,52:118842.06}),
      ...buildLoanOptions(1550000,{104:70555.52,78:84081.81,52:111134.37}),
      ...buildLoanOptions(2050000,{104:62517.06,78:74440.78,52:98288.22}),
    ],
  ),

  // =========================
  // HONDA 125
  // =========================
  Bike(
    name: "Honda 125",
    imageUrl: "lib/assets/bikes/honda_125.png",
    category: "Standard",
    loanOptions: [
      ...buildLoanOptions(950000,{104:85024.75,78:101435.65,52:134257.45}),
      ...buildLoanOptions(1050000,{104:83417.06,78:99507.45,52:131688.22}),
      ...buildLoanOptions(1250000,{104:80201.68,78:95651.04,52:126549.75}),
      ...buildLoanOptions(1550000,{104:75378.60,78:89866.42,52:118842.06}),
      ...buildLoanOptions(2050000,{104:67340.14,78:80225.39,52:105995.91}),
    ],
  ),
];