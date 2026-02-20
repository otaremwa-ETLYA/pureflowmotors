import 'loan_option.dart';

class Bike {
  final String name;
  final String imageUrl;
  final String category;
  final List<LoanOption> loanOptions;

  Bike({
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.loanOptions,
  });
}
