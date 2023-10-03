import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldsFormatter extends TextInputFormatter {
  String mask = "xx xxx xxx xx xxxx";
  final String separator;

  FieldsFormatter({
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text[0] == '8') {
      mask = "x xxx xxx xx xx xx";
    } else {
      mask = "xx xxx xxx xx xx xx";
    }

    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
