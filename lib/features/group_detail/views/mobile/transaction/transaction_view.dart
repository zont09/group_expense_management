import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/transaction_view_cubit.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_transaction_popup.dart';
import 'package:group_expense_management/features/group_detail/widgets/transaction_item.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailCubit, int>(
  builder: (cc, ss) {
    var cubitDt = BlocProvider.of<GroupDetailCubit>(cc);
    return BlocProvider(
      create: (context) =>
          TransactionViewCubit()..initData(cubitDt.transactions ?? []),
      child: BlocBuilder<TransactionViewCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<TransactionViewCubit>(c);
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ZSearchField(
                  controller: cubit.controller,
                  onChange: (v) {
                    cubit.updateSearch(v);
                  },
                ),
                const ZSpace(h: 5),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:  8.0),
                      child: Column(
                        children: [
                          ...cubit.listShow.map((e) => Column(
                                children: [
                                  TransactionItem(
                                      transaction: e,
                                      cate: e.category.split('_')[1],
                                      onTap: () {
                                        DialogUtils.showAlertDialog(context, child: AddTransactionPopup(
                                          group: cubitDt.group,
                                          wallets: cubitDt.wallets ?? [],
                                          categories: cubitDt.categories ?? [],
                                          onAdd: (v) {
                                            cubitDt.addTransaction(v);
                                          },
                                          onUpdateTrans: (v) {
                                            cubitDt.updateTransaction(v);
                                          },
                                          onUpdateWallet: (v) {
                                            cubitDt.updateWallet(v);
                                          },
                                          isEdit: true,
                                          model: e,
                                        ),);
                                      }),
                                  const ZSpace(h: 10),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  },
);
  }
}

class ZSearchField extends StatelessWidget {
  const ZSearchField(
      {super.key, required this.controller, required this.onChange});

  final TextEditingController controller;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        labelText: "Nhập tiêu đề tìm kiếm",
        labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: ColorConfig.hintText),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: ColorConfig.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: ColorConfig.primary2)),
      ),
      onChanged: (value) {
        onChange(value);
      },
    );
  }
}
