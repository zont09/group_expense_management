import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/widgets/transaction_item.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';
import 'package:group_expense_management/widgets/z_space.dart';
import 'package:intl/intl.dart';

class RecentTransaction extends StatelessWidget {
  const RecentTransaction(
      {super.key,
      required this.transactions,
      required this.actionSeeAll,
      required this.seeDetail});

  final List<TransactionModel> transactions;
  final Function() actionSeeAll;
  final Function(TransactionModel) seeDetail;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
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
          itemCount: min(4, transactions.length),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final cate = transaction.category.split('_')[1];
            return TransactionItem(
                transaction: transaction,
                cate: cate,
                onTap: (){seeDetail(transaction);});
            // return ListTile(
            //   leading: CircleAvatar(
            //     child: Icon(_getCategoryIcon(transaction.category)),
            //   ),
            //   title: Text(transaction.title),
            //   subtitle: Text(
            //     DateFormat('dd/MM/yyyy').format(transaction.date),
            //   ),
            //   trailing: Text(
            //     '- 150,000 đ',
            //     style: TextStyle(
            //       color: Colors.red[700],
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   onTap: () {
            //     DialogUtils.showAlertDialog(context,
            //         child: DetailTransaction(transaction: transaction));
            //   },
            // );
          },
        ),
      ],
    );
  }
}


