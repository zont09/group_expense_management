import 'package:flutter/material.dart';

// This file would contain reusable widgets for your app
// For example, custom cards, buttons, etc.

class TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String category;
  final VoidCallback onTap;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amount.startsWith('-') ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final String name;
  final String amount;
  final String currency;
  final Color color;
  final VoidCallback onTap;

  const WalletCard({
    Key? key,
    required this.name,
    required this.amount,
    required this.currency,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '$amount $currency',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetProgressCard extends StatelessWidget {
  final String category;
  final double current;
  final double target;
  final String currency;
  final Color color;

  const BudgetProgressCard({
    Key? key,
    required this.category,
    required this.current,
    required this.target,
    required this.currency,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = current / target;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${(percentage * 100).toInt()}%',
                  style: TextStyle(
                    color: percentage > 0.9 ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.9 ? Colors.red : color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$current $currency'),
                Text('$target $currency'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MemberTile extends StatelessWidget {
  final String name;
  final String role;
  final String? avatar;
  final VoidCallback onTap;

  const MemberTile({
    Key? key,
    required this.name,
    required this.role,
    this.avatar,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
        child: avatar == null ? Text(name.substring(0, 1)) : null,
      ),
      title: Text(name),
      subtitle: Text(role),
      trailing: const Icon(Icons.more_vert),
      onTap: onTap,
    );
  }
}

