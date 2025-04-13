import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_transaction_cubit.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/widgets/text_field_custom.dart';

class AddTransactionPopup extends StatelessWidget {
  const AddTransactionPopup(
      {super.key,
      required this.wallets,
      required this.categories,
      required this.onAdd});

  final List<WalletModel> wallets;
  final List<CategoryModel> categories;
  final Function(TransactionModel) onAdd;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTransactionCubit(),
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
                TextFieldCustom(
                    title: "Tiêu đề", controller: cubit.conTitle),
                TextFieldCustom(
                    title: "Mô tả", controller: cubit.conDes),
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
