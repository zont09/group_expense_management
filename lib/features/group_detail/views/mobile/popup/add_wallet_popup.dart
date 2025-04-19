import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_wallet_cubit.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/currency_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/widgets/text_field_custom.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class AddWalletPopup extends StatelessWidget {
  const AddWalletPopup({super.key, required this.group, required this.onAdd});

  final GroupModel group;
  final Function(WalletModel) onAdd;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return BlocProvider(
      create: (context) => AddWalletCubit(mC.user, group)..initData(),
      child: BlocBuilder<AddWalletCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<AddWalletCubit>(c);
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
                  "Thêm mới ví",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor6),
                ),
                TextFieldCustom(title: "Tên ví", controller: cubit.conName),
                TextFieldCustom(
                    title: "Số dư",
                    controller: cubit.conAmount,
                    isNumberOnly: true),
                TextFieldCustom(
                    title: "Ghi chú",
                    controller: cubit.conNote,
                    isNumberOnly: true),
                DropdownCurrency(
                  title: "Tiền tệ",
                  items: cubit.listCurrency,
                  onChanged: (v) {
                    cubit.onChangeCurrency(v);
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
                          DialogUtils.showLoadingDialog(context);
                          final wallet = await cubit.addWallet();
                          if(context.mounted) {
                            Navigator.of(context).pop();
                          }
                          onAdd(wallet);
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

class DropdownCurrency extends StatelessWidget {
  const DropdownCurrency(
      {super.key,
      required this.title,
      required this.items,
      required this.onChanged});

  final String title;
  final List<CurrencyModel> items;
  final Function(CurrencyModel) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CurrencyModel>(
      decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorConfig.hintText)),
      // value: category,
      items: items.map((e) {
        return DropdownMenuItem<CurrencyModel>(
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
