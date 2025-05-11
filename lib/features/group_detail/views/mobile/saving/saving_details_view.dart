import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/widgets/transaction_item.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/widgets/z_button.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class SavingDetailsView extends StatelessWidget {
  const SavingDetailsView(
      {super.key, required this.saving, required this.details});

  final SavingModel saving;
  final List<TransactionModel> details;

  @override
  Widget build(BuildContext context) {
    details.sort((a, b) => b.date.compareTo(a.date));
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(saving.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorConfig.textColor6)),
          Container(
              height: 1,
              width: double.infinity,
              color: ColorConfig.border,
              padding: EdgeInsets.symmetric(vertical: 9)),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                ...details.map((e) =>
                    Column(
                      children: [
                        TransactionItem(transaction: e, cate: '1', onTap: () {}),
                        const ZSpace(h: 8),
                      ],
                    ))
              ],
            ),
          )),
          const ZSpace(h: 9),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:  20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZButton(
                    title: AppText.btnOk.text,
                    paddingHor: 24,
                    paddingVer: 6,
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
