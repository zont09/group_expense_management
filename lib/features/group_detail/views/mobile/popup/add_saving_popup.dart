import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_saving_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_transaction_cubit.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/wallet_service.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/toast_utils.dart';
import 'package:group_expense_management/widgets/datetime_picker.dart';
import 'package:group_expense_management/widgets/text_field_custom.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class AddSavingPopup extends StatelessWidget {
  const AddSavingPopup(
      {super.key,
      required this.group,
      required this.wallets,
      required this.onAdd,
      required this.onUpdate,
      required this.onUpdateWallet,
      this.isEdit = false,
      this.model});

  final GroupModel group;
  final List<WalletModel> wallets;
  final Function(SavingModel) onAdd;
  final Function(SavingModel) onUpdate;
  final Function(WalletModel) onUpdateWallet;
  final bool isEdit;
  final SavingModel? model;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return BlocProvider(
      create: (context) => AddSavingCubit(group, mC.user)..initData(wallets),
      child: BlocBuilder<AddSavingCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<AddSavingCubit>(c);
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
                  !isEdit
                      ? "Thêm mới khoảng tiết kiệm"
                      : "Chỉnh sửa khoảng tiết kiệm",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor6),
                ),
                TextFieldCustom(
                  title: "Tên",
                  controller: cubit.conTitle,
                  canEdit: cubit.canEdit,
                ),
                TextFieldCustom(
                    title: "Mô tả",
                    controller: cubit.conDes,
                    canEdit: cubit.canEdit),
                TextFieldCustom(
                    title: "Số tiền",
                    controller: cubit.conTargetAmount,
                    isNumberOnly: true,
                    canEdit: cubit.canEdit),
                DayPickerCustom(
                    title: "Hạn đến",
                    controller: TextEditingController(
                        text:
                            "${cubit.targetDate.day}/${cubit.targetDate.month}/${cubit.targetDate.year}"),
                    onDateSelected: (v) {
                      cubit.onSelectDate(v);
                    }),
                // AbsorbPointer(
                //   absorbing: cubit.isEdit,
                //   child: DropdownWallet(
                //     title: "Ví",
                //     initItem: cubit.wallet,
                //     items: cubit.listWallets,
                //     onChanged: (v) {
                //       cubit.wallet = v;
                //     },
                //   ),
                // ),
                const SizedBox(height: 18),
                if (cubit.isEdit && !cubit.canEdit)
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
                      if (
                          group.owner == mC.user.id)
                        ZButton(
                            title: "Chỉnh sửa",
                            paddingHor: 12,
                            colorBackground: ColorConfig.primary2,
                            colorTitle: Colors.white,
                            onPressed: () async {
                              cubit.canEdit = true;
                              cubit.EMIT();
                            }),
                    ],
                  ),
                if (!cubit.isEdit || cubit.canEdit)
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
                          title: cubit.isEdit ? "Cập nhật" : "Thêm",
                          paddingHor: 12,
                          colorBackground: ColorConfig.primary2,
                          colorTitle: Colors.white,
                          onPressed: () async {
                            // if (cubit.wallet == null) {
                            //   ToastUtils.showBottomToast(
                            //       context, "Vui lòng chọn ví để tiếp tục");
                            //   return;
                            // }
                            DialogUtils.showLoadingDialog(context);
                            // final wallet = cubit.wallet!.id == "Ca nhan" ||
                            //         cubit.wallet!.id == "Khac"
                            //     ? cubit.wallet
                            //     : await WalletService.instance
                            //         .getWalletById(cubit.wallet!.id);
                            // if (wallet == null) {
                            //   ToastUtils.showBottomToast(
                            //       context, "Ví không còn tồn tại");
                            //   if (context.mounted) {
                            //     Navigator.of(context).pop();
                            //   }
                            //   return;
                            // }
                            if(cubit.conTitle.text.isEmpty) {
                              ToastUtils.showBottomToast(context, "Vui lòng nhập tên khoảng tiết kiệm");
                              return;
                            }
                            if(cubit.conDes.text.isEmpty) {
                              ToastUtils.showBottomToast(context, "Vui lòng nhập mô tả khoảng tiết kiệm");
                              return;
                            }
                            if(cubit.conTargetAmount.text.isEmpty) {
                              ToastUtils.showBottomToast(context, "Vui lòng nhập số tiền cần tiết kiệm");
                              return;
                            }
                            if(double.parse(cubit.conTargetAmount.text) <= 0) {
                              ToastUtils.showBottomToast(context, "Vui lòng nhập số tiền lớn hơn 0");
                              return;
                            }
                            // if (wallet.amount <
                            //         double.parse(cubit.conTargetAmount.text) &&
                            //     wallet.amount != -1) {
                            //   ToastUtils.showBottomToast(context,
                            //       "Ví không còn đủ số dư để thực hiện giao dịch");
                            //   return;
                            // }
                            // debugPrint(
                            //     "=====> wallet: ${wallet.id} - ${wallet.group}");
                            // final updWallet = wallet.copyWith(
                            //     amount: wallet.amount -
                            //         double.parse(cubit.conTargetAmount.text));
                            // await WalletService.instance
                            //     .updateWallet(updWallet);
                            final trans = await cubit.onAddSaving();
                            onAdd(trans);
                            // onUpdateWallet(updWallet);
                            if (context.mounted) {
                              debugPrint("=====> add transaction here");
                              Navigator.of(context).pop();
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
      required this.initItem,
      required this.items,
      required this.onChanged});

  final String title;
  final CategoryModel? initItem;
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
      value: initItem,
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
      required this.initItem,
      required this.items,
      required this.onChanged});

  final String title;
  final WalletModel? initItem;
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
      value: initItem,
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
