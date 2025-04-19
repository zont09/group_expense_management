import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_transaction_cubit.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/wallet_service.dart';
import 'package:group_expense_management/utils/toast_utils.dart';
import 'package:group_expense_management/widgets/text_field_custom.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class AddTransactionPopup extends StatelessWidget {
  const AddTransactionPopup(
      {super.key,
      required this.group,
      required this.wallets,
      required this.categories,
      required this.onAdd});

  final GroupModel group;
  final List<WalletModel> wallets;
  final List<CategoryModel> categories;
  final Function(TransactionModel) onAdd;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return BlocProvider(
      create: (context) => AddTransactionCubit(group, mC.user),
      child: BlocBuilder<AddTransactionCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<AddTransactionCubit>(c);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Thêm mới giao dịch",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor6),
                ),
                TextFieldCustom(title: "Tiêu đề", controller: cubit.conTitle),
                TextFieldCustom(title: "Mô tả", controller: cubit.conDes),
                TextFieldCustom(
                    title: "Số tiền",
                    controller: cubit.conAmount,
                    isNumberOnly: true),
                DropdownCategory(
                  title: "Loại giao dịch",
                  items: categories,
                  onChanged: (v) {
                    cubit.category = v;
                  },
                ),
                DropdownWallet(
                  title: "Ví",
                  items: wallets,
                  onChanged: (v) {
                    cubit.wallet = v;
                  },
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ZButton(
                        title: AppText.btnCancel.text,
                        colorBackground: Colors.transparent,
                        colorBorder: Colors.transparent,
                        paddingHor: 12,
                        colorTitle: ColorConfig.primary2,
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    const SizedBox(width: 10),
                    ZButton(
                        title: "Thêm",
                        paddingHor: 12,
                        colorBackground: ColorConfig.primary2,
                        colorTitle: Colors.white,
                        onPressed: () async {
                          if (cubit.wallet == null) {
                            ToastUtils.showBottomToast(
                                context, "Vui lòng chọn ví để tiếp tục");
                            return;
                          }
                          final wallet = await WalletService.instance
                              .getWalletById(cubit.wallet!.id);
                          if (wallet == null) {
                            ToastUtils.showBottomToast(
                                context, "Ví không còn tồn tại");
                            return;
                          }
                          if (wallet.amount <
                              double.parse(cubit.conAmount.text)) {
                            ToastUtils.showBottomToast(context,
                                "Ví không còn đủ số dư để thực hiện giao dịch");
                            return;
                          }
                          await WalletService.instance.updateWallet(
                              wallet.copyWith(
                                  amount: wallet.amount -
                                      double.parse(cubit.conAmount.text)));
                          final trans = await cubit.addTransaction();
                          onAdd(trans);
                          if(context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class DropdownCategory extends StatelessWidget {
  const DropdownCategory(
      {super.key,
      required this.title,
      required this.items,
      required this.onChanged});

  final String title;
  final List<CategoryModel> items;
  final Function(CategoryModel) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryModel>(
      decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorConfig.hintText)),
      // value: category,
      items: items.map((e) {
        return DropdownMenuItem<CategoryModel>(
          value: e,
          child: Text(e.title),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) {
          onChanged(v);
        }
      },
    );
  }
}

class DropdownWallet extends StatelessWidget {
  const DropdownWallet(
      {super.key,
      required this.title,
      required this.items,
      required this.onChanged});

  final String title;
  final List<WalletModel> items;
  final Function(WalletModel) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<WalletModel>(
      decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorConfig.hintText)),
      // value: category,
      items: items.map((e) {
        return DropdownMenuItem<WalletModel>(
          value: e,
          child: Text(e.name),
        );
      }).toList(),
      onChanged: (v) {
        if (v != null) {
          onChanged(v);
        }
      },
    );
  }
}
