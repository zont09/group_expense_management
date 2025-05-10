import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_saving_detail_popup.dart';
import 'package:group_expense_management/models/dummy_data.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class SavingView extends StatelessWidget {
  const SavingView({super.key, required this.savings, required this.cubitOv});

  final List<SavingModel> savings;
  final GroupDetailCubit cubitOv;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Các khoản tiết kiệm",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: ColorConfig.textColor)),
                const ZSpace(h: 12),
                ...savings.map((e) => Column(
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
                                  Text("20%",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: ColorConfig.textColor6)),
                                ],
                              ),
                              const ZSpace(h: 6),
                              Text(
                                  "Thời hạn: ${e.targetDate.day}/${e.targetDate.month}/${e.targetDate.year}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConfig.textColor7)),
                              const ZSpace(h: 10),
                              LinearProgressIndicator(
                                value: (20) / e.targetAmount,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    getColorFromValue((20) / e.targetAmount)),
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
                                    onPressed: () {},
                                    // colorBackground: Colors.transparent,
                                    // colorTitle: ColorConfig.primary3
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
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
