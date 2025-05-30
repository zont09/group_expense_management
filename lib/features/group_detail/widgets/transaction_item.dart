import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';
import 'package:group_expense_management/widgets/z_space.dart';
import 'package:intl/intl.dart';


class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.cate,
    required this.onTap,
  });

  final TransactionModel transaction;
  final String cate;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: const [ColorConfig.boxShadow2]),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.only(bottom: 9),
          child: Row(
            children: [
              CircleAvatar(
                child: Icon(_getCategoryIcon(transaction.category)),
              ),
              const ZSpace(w: 9),
              Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const ZSpace(w: 9),
                          Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      (cate == "0" ? "-" : "+") +
                                          NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'đ')
                                              .format(transaction.amount),
                                      style: TextStyle(
                                          fontSize: Resizable.size(context, 14),
                                          fontWeight: FontWeight.w600,
                                          color: cate == "0"
                                              ? ColorConfig.outcome
                                              : ColorConfig.income)),
                                ),
                              )),
                        ],
                      ),
                      const ZSpace(h: 9),
                      Row(
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy').format(transaction.date),
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorConfig.textColor7,
                                fontWeight: FontWeight.w400),
                          ),
                          const ZSpace(w: 9),
                          Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AvatarItem(
                                      mC.mapUser[transaction.user]?.avatar ?? ""),
                                  const ZSpace(w: 6),
                                  Text(
                                    mC.mapUser[transaction.user]?.name ??
                                        "Không xác định",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConfig.textColor,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ))
                        ],
                      )
                    ],
                  )),
            ],
          )),
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