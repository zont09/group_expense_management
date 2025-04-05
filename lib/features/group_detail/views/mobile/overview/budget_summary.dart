import 'package:flutter/material.dart';

class BudgetSummary extends StatelessWidget {
  const BudgetSummary({super.key, required this.actionSeeAll});

  final Function() actionSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                actionSeeAll();
              },
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Food'),
                    Text('1,500,000 / 2,000,000 đ'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Transportation'),
                    Text('500,000 / 1,000,000 đ'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );;
  }
}
