import 'package:flutter/services.dart';

class CommaWithPeriodReplacer extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      newValue.copyWith(text: newValue.text.replaceAll(',', '.'));
}

final decimalTextInputFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'));
