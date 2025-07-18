import 'package:flutter/material.dart';

class AffiliateStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const AffiliateStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                Icon(icon, size: 30, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
