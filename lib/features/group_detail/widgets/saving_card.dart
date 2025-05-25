import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_saving_detail_popup.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/saving/saving_details_view.dart';
import 'package:group_expense_management/models/dummy_data.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/function_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class SavingCard extends StatelessWidget {
  const SavingCard({super.key, required this.e, required this.cubitOv});

  final SavingModel e;
  final GroupDetailCubit cubitOv;

  double calculateProgress(SavingModel saving) {
    double sum = 0;
    for (var svD in saving.details) {
      sum += (cubitOv.mapTrans[svD]?.amount ?? 0.0);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final current = calculateProgress(e);
    final percent = e.targetAmount == 0 ? 0 : current * 100 ~/ e.targetAmount;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              boxShadow: const [ColorConfig.boxShadow2]),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(e.title,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConfig.textColor6)),
                  ),
                  const ZSpace(w: 8),
                  Text("$percent%",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConfig.textColor6)),
                ],
              ),
              const ZSpace(h: 6),
              Text(
                  "Thời hạn: ${e.targetDate.day}/${e.targetDate.month}/${e
                      .targetDate.year}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor7)),
              const ZSpace(h: 10),
              LinearProgressIndicator(
                value: percent / 100.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                    getColorFromValue(percent / 100.0)),
              ),
              const ZSpace(h: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      "${FunctionUtils.formatVND(current)}/",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConfig.textColor7)),
                  Text(
                      "${FunctionUtils.formatVND(e.targetAmount)}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConfig.textColor7)),
                ],
              ),
              const ZSpace(h: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZButton(
                      title: "Đóng góp",
                      onPressed: () async {
                        DialogUtils.showAlertDialog(context,
                            child: AddSavingDetailPopup(
                                group: cubitOv.group,
                                wallets: [
                                  ...(cubitOv.wallets ?? []),
                                  DummyData.walletPersonal,
                                  DummyData.walletOther
                                ],
                                saving: e,
                                onAdd: (v) {
                                  cubitOv.addTransaction(v);
                                },
                                onUpdateTrans: (v) {
                                  cubitOv.updateTransaction(v);
                                },
                                onUpdateSaving: (v) {
                                  cubitOv.updateSaving(v);
                                },
                                onUpdateWallet: (v) {
                                  cubitOv.updateWallet(v);
                                }));
                      },
                      sizeTitle: 12,
                      paddingVer: 5,
                      colorBackground: Colors.transparent,
                      colorTitle: ColorConfig.primary2),
                  const ZSpace(w: 12),
                  ZButton(
                    title: "Chi tiết",
                    sizeTitle: 12,
                    paddingVer: 5,
                    onPressed: () {
                      DialogUtils.showAlertDialog(context,
                          child: SavingDetailsView(saving: e, details: e.details
                              .where((e) => cubitOv.mapTrans[e] != null).map((
                              e) => cubitOv.mapTrans[e]!).toList()));
                    },
                    // colorBackground: Colors.transparent,
                    // colorTitle: ColorConfig.primary3
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Color getColorFromValue(double value) {
    assert(value >= 0.0 && value <= 1.0);

    if (value < 0.5) {
      double t = value / 0.5;
      return Color.lerp(Colors.green, Colors.yellow, t)!;
    } else {
      double t = (value - 0.5) / 0.5;
      return Color.lerp(Colors.yellow, Colors.red, t)!;
    }
  }
}
