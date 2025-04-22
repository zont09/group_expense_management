import 'package:flutter/material.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class BudgetSummary extends StatelessWidget {
  const BudgetSummary({super.key, required this.actionSeeAll, required this.details});

  final Function() actionSeeAll;
  final List<BudgetDetailModel> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tình trạng ngân sách',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {
                actionSeeAll();
              },
              child: const Text('Xem thêm'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...details.map((e) => Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Food'),
                            Text('${e.current} / ${e.amount}'),
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
                      ],
                    ),
                    const ZSpace(h: 12),
                  ],
                )),
              ],
            ),
          ),
        ),
      ],
    );;
  }
}
