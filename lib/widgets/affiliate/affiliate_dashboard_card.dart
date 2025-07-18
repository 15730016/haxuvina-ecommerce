import 'package:flutter/material.dart';
import '../../helpers/main_helpers.dart';
import '../../my_theme.dart';

class AffiliateDashboardCard extends StatelessWidget {
  final double balance;
  final VoidCallback onWithdrawTap;

  const AffiliateDashboardCard({
    Key? key,
    required this.balance,
    required this.onWithdrawTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Số dư khả dụng', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(convertPrice(balance.toString()), style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: MyTheme.green,
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: onWithdrawTap,
                  style: ElevatedButton.styleFrom(backgroundColor: MyTheme.accent_color),
                  child: const Text('Rút tiền', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
