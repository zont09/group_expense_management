import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:intl/intl.dart';

class WalletSummary extends StatelessWidget {
  const WalletSummary(
      {super.key, required this.wallets, required this.actionSeeAll});

  final List<WalletModel> wallets;
  final Function() actionSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ví',
                style: TextStyle(
                    fontSize: Resizable.font(context, 18),
                    fontWeight: FontWeight.w600,
                    color: ColorConfig.textColor6,
                    shadows: const [ColorConfig.textShadow])),
            TextButton(
              onPressed: () {
                actionSeeAll();
              },
              child: Text('Xem thêm',
                  style: TextStyle(
                      fontSize: Resizable.font(context, 12),
                      fontWeight: FontWeight.w600,
                      // color: ColorConfig.textColor6,
                      shadows: const [ColorConfig.textShadow])),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                              .format(wallet.amount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
