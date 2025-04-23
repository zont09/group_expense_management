import 'package:flutter/material.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/widgets/z_space.dart';
import 'package:intl/intl.dart';

class BudgetSummary extends StatelessWidget {
  const BudgetSummary(
      {super.key,
      required this.actionSeeAll,
      required this.details,
      required this.mapCate,
      required this.mapBudgetValue});

  final Function() actionSeeAll;
  final List<BudgetDetailModel> details;
  final Map<String, CategoryModel> mapCate;
  final Map<String, double> mapBudgetValue;

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
                ...details.map((e) {
                  double value = mapBudgetValue["${e.category}_${e.date.month}/${e.date.year}"] ?? 0;
                  return Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mapCate[e.category]?.title ?? "Không rõ"),
                              Text('${NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ')
                                  .format(value)} / ${NumberFormat.currency(
                                  locale: 'vi_VN',
                                  symbol: 'đ')
                                  .format(e.amount)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: value / e.amount,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                getColorFromValue(value / e.amount)
                            ),
                          ),
                        ],
                      ),
                      const ZSpace(h: 12),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color getColorFromValue(double value) {
    assert(value >= 0.0 && value <= 1.0);

    if (value < 0.5) {
      double t = value / 0.5;
      return Color.lerp(Colors.green, Colors.yellow, t)!;
    } else {
      double t = (value - 0.5) / 0.5;
      return Color.lerp(Colors.yellow, Colors.red, t)!;
    }
  }
}


