import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const MoneyTextField({
    super.key,
    required this.controller,
    this.label = 'Số tiền',
  });

  @override
  State<MoneyTextField> createState() => _MoneyTextFieldState();
}

class _MoneyTextFieldState extends State<MoneyTextField> {
  final NumberFormat _formatter = NumberFormat("#,##0", "vi_VN");
  bool _isFormatting = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixText: '₫',
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (_isFormatting) return;
        _isFormatting = true;

        final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
        if (digitsOnly.isEmpty) {
          widget.controller.text = '';
        } else {
          final number = int.parse(digitsOnly);
          final newText = _formatter.format(number);

          widget.controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }

        _isFormatting = false;
      },
    );
  }
}
