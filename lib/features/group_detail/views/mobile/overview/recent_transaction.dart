import 'package:flutter/material.dart';
import 'package:group_expense_management/features/group_detail/widgets/overview/detail_transaction.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:intl/intl.dart';

class RecentTransaction extends StatelessWidget {
  const RecentTransaction(
      {super.key, required this.transactions, required this.actionSeeAll});

  final List<TransactionModel> transactions;
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
              'Giao dịch gần đây',
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(_getCategoryIcon(transaction.category)),
              ),
              title: Text(transaction.title),
              subtitle: Text(
                DateFormat('dd/MM/yyyy').format(transaction.date),
              ),
              trailing: Text(
                '- 150,000 đ',
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                DialogUtils.showAlertDialog(context,
                    child: DetailTransaction(transaction: transaction));
              },
            );
          },
        ),
      ],
    );
  }
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'food':
        return Icons.restaurant;
      case 'supplies':
        return Icons.shopping_bag;
      default:
        return Icons.attach_money;
    }
  }
}
