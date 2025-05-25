import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/widgets/saving_card.dart';
import 'package:group_expense_management/models/saving_model.dart';
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
                    SavingCard(e: e, cubitOv: cubitOv),
                    const ZSpace(h: 12),
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
