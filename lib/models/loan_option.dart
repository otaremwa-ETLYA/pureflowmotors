class LoanOption {
  final int downPayment;
  final int durationWeeks;
  final double weeklyPayment;


  LoanOption({
    required this.downPayment,
    required this.durationWeeks,
    required this.weeklyPayment,
  });

  double get durationYears => durationWeeks / 52;
}
