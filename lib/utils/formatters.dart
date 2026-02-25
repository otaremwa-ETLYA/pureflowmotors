import 'package:intl/intl.dart';

String formatUGX(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_UG',
    symbol: '',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
