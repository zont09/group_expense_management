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
              child: Text('Xem thêm', style: TextStyle(
                  fontSize: Resizable.font(context, 12),
                  fontWeight: FontWeight.w600,
                  // color: ColorConfig.textColor6,
                  shadows: const [ColorConfig.textShadow])),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return AspectRatio(
                aspectRatio: 2,
                  child: WalletCardItem(wallet: wallet));
            },
          ),
        ),
      ],
    );
  }
}

class WalletCardItem extends StatelessWidget {
  const WalletCardItem({super.key, required this.wallet});

  final WalletModel wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConfig.primary3,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          ColorConfig.boxShadow2,
        ],
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(right: 8, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(wallet.name,
              style: TextStyle(
                  fontSize: Resizable.size(context, 16),
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: 'đ')
                    .format(wallet.amount),
                style: TextStyle(
                    fontSize: Resizable.size(context, 18),
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
