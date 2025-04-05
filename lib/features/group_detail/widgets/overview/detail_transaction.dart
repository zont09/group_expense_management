import 'package:flutter/material.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:intl/intl.dart';

class DetailTransaction extends StatelessWidget {
  const DetailTransaction({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Description: ${transaction.description}'),
          const SizedBox(height: 8),
          Text('Date: ${DateFormat('dd/MM/yyyy').format(transaction.date)}'),
          const SizedBox(height: 8),
          Text('Amount: 150,000 đ'), // Mock amount
          const SizedBox(height: 8),
          Text('Category: ${transaction.category}'),
          const SizedBox(height: 8),
          Text('Wallet: Group Cash'), // Mock wallet name
          const SizedBox(height: 8),
          Text('Added by: John Doe'), // Mock user name
        ],
      ),
    );
  }
}
