import 'package:flutter/material.dart';
import '../../my_theme.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    Key? key,
    required this.message,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: MyTheme.brick_red, fontSize: 16),
          ),
          const SizedBox(height: 20),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(backgroundColor: MyTheme.accent_color),
              child: const Text("Thử lại"),
            ),
        ],
      ),
    );
  }
}
