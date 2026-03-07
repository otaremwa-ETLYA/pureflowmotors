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
    category: "Standard",
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
    category: "Standard",
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

  Bike(
    name: "Kevla 200cc With Water Cooling",
    imageUrl: "lib/assets/bikes/kevla_200cc.png",
    category: "Tuku Tuku",
    loanOptions: [
      ...buildLoanOptions(3100000,{104: 119346,78: 143385,52: 191462}),
      ...buildLoanOptions(3300000,{104: 116131,78: 139528,52: 186323}),
      ...buildLoanOptions(3500000,{104: 112915,78: 135672,52: 181185}),
      ...buildLoanOptions(4000000,{104: 104877,78: 126031,52: 168338}),
      ...buildLoanOptions(4500000,{104: 96838,78: 116390,52: 155492}),
    ],
  ),
Bike(
  name: "Kevla 250cc With Tipping",
  imageUrl: "lib/assets/bikes/kevla_250cc_tipping.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(6000000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(6100000,{104: 117738,78: 141456,52: 188892}),
    ...buildLoanOptions(6200000,{104: 116131,78: 139528,52: 186323}),
    ...buildLoanOptions(6500000,{104: 111308,78: 133744,52: 178615}),
    ...buildLoanOptions(7000000,{104: 103269,78: 124103,52: 165769}),
  ],
),

// Bike(
//   name: "Kevla 250cc With Tipping",
//   imageUrl: "lib/assets/bikes/kevla_250cc_tipping.png",
//   category: "Tuku Tuku",
//   loanOptions: [
//     ...buildLoanOptions(6000000,{104: 119346,78: 143385,52: 191462}),
//     ...buildLoanOptions(6100000,{104: 117738,78: 141456,52: 188892}),
//     ...buildLoanOptions(6200000,{104: 116131,78: 139528,52: 186323}),
//     ...buildLoanOptions(6500000,{104: 111308,78: 133744,52: 178615}),
//     ...buildLoanOptions(7000000,{104: 103269,78: 124103,52: 165769}),
//   ],
// ),

Bike(
  name: "Kevla 300cc With Tipping",
  imageUrl: "lib/assets/bikes/kevla_300cc_tipping.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(6900000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(7000000,{104: 117738,78: 141456,52: 188892}),
    ...buildLoanOptions(7200000,{104: 114523,78: 137600,52: 183754}),
    ...buildLoanOptions(7300000,{104: 112915,78: 135672,52: 181185}),
    ...buildLoanOptions(7500000,{104: 109700,78: 131815,52: 176046}),
  ],
),

Bike(
  name: "Zongshen 200cc Water Cooled",
  imageUrl: "lib/assets/bikes/zongshen_200cc_water_cooled.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(3250000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(3500000,{104: 115327,78: 138564,52: 185038}),
    ...buildLoanOptions(4000000,{104: 107288,78: 128923,52: 172192}),
    ...buildLoanOptions(4500000,{104: 99250,78: 119282,52: 159346}),
  ],
),

Bike(
  name: "Zongshen 250cc Water Cooled No Tipping",
  imageUrl: "lib/assets/bikes/zongshen_250cc_no_tipping.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(4700000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(5000000,{104: 114523,78: 137600,52: 183754}),
    ...buildLoanOptions(5200000,{104: 111308,78: 133744,52: 178615}),
    ...buildLoanOptions(5500000,{104: 106485,78: 127959,52: 170908}),
    ...buildLoanOptions(5700000,{104: 103269,78: 124103,52: 165769}),
  ],
),

Bike(
  name: "Zongshen 200cc Air Cooled",
  imageUrl: "lib/assets/bikes/zongshen_200cc_air_cooled.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(2600000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(3000000,{104: 112915,78: 135672,52: 181185}),
    ...buildLoanOptions(3500000,{104: 104877,78: 126031,52: 168338}),
    ...buildLoanOptions(4000000,{104: 96838,78: 116390,52: 155492}),
    ...buildLoanOptions(4500000,{104: 88800,78: 106749,52: 142646}),
  ],
),

Bike(
  name: "Zongshen 250cc Double Tyre With No Tipping",
  imageUrl: "lib/assets/bikes/zongshen_250cc_double_tyre_no_tipping.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(5400000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(5500000,{104: 117738,78: 141456,52: 188892}),
    ...buildLoanOptions(5700000,{104: 114523,78: 137600,52: 183754}),
    ...buildLoanOptions(6000000,{104: 109700,78: 131815,52: 176046}),
    ...buildLoanOptions(6500000,{104: 101662,78: 122174,52: 163200}),
  ],
),

Bike(
  name: "Zongshen 250cc Water Cooled Tipping",
  imageUrl: "lib/assets/bikes/zongshen_250cc_water_cooled_tipping.png",
  category: "Tuku Tuku",
  loanOptions: [
    ...buildLoanOptions(5000000,{104: 119346,78: 143385,52: 191462}),
    ...buildLoanOptions(5200000,{104: 116131,78: 139528,52: 186323}),
    ...buildLoanOptions(5500000,{104: 111308,78: 133744,52: 178615}),
    ...buildLoanOptions(5700000,{104: 108092,78: 129887,52: 173477}),
    ...buildLoanOptions(6000000,{104: 103269,78: 124103,52: 165769}),
  ],
),




];