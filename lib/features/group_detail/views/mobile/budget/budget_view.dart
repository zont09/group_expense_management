import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/widgets/z_space.dart';
import 'package:intl/intl.dart';

class BudgetView extends StatelessWidget {
  const BudgetView({super.key, required this.cubitDt});

  final GroupDetailCubit cubitDt;

  @override
  Widget build(BuildContext context) {
    final now = "${DateTime.now().month - 1}/${DateTime.now().year}";
    double sumSpent = 0;
    cubitDt.mapMoneyBudget.forEach((k, v) {
      final cat = k.split('_')[0];
      final time = k.split('_')[1];
      if (time == now) {
        sumSpent += v;
      }
    });

    double sumBudget = 0;
    cubitDt.budgetDetails?.forEach((e) {
      if ("${e.date.month}/${e.date.year}" == now) {
        sumBudget += e.amount;
      }
    });

    debugPrint("=====> budget 2: ${cubitDt.budgets?.length}");
    debugPrint("=====> budget details 2: ${cubitDt.budgetDetails?.length}");

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: ColorConfig.primary5,
                  boxShadow: const [ColorConfig.boxShadow2]),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ngân sách tháng này",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConfig.textColor,
                          letterSpacing: -0.41),
                    ),
                    const ZSpace(h: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng ngân sách:",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.textColor),
                        ),
                        Text(
                          "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(sumBudget)}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.textColor),
                        )
                      ],
                    ),
                    const ZSpace(h: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Đã dùng:",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.textColor),
                        ),
                        Text(
                          "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(sumSpent)}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.textColor),
                        )
                      ],
                    ),
                    const ZSpace(h: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Còn lại:",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.textColor),
                        ),
                        Text(
                          "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(sumBudget - sumSpent)}",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorConfig.textColor),
                        )
                      ],
                    )
                  ])),
          const ZSpace(h: 22),
          Text(
            "Chi tiết ngân sách",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ColorConfig.textColor,
                letterSpacing: -0.41),
          ),
          const ZSpace(h: 12),
          ...cubitDt.budgetDetails!
              .where((e) => "${e.date.month}/${e.date.year}" == now)
              .map((e) => Column(
                children: [
                  Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: const [ColorConfig.boxShadow2]),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${cubitDt.mapCate[e.category]?.title ?? "Không rõ"}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConfig.textColor,
                                      letterSpacing: -0.41),
                                ),
                                Text(
                                    "${(((cubitDt.mapMoneyBudget[
                                                        "${e.category}_$now"] ??
                                                    0) /
                                                e.amount) *
                                            100)
                                        .toStringAsFixed(0)}%",
                                    // "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConfig.textColor,
                                        letterSpacing: -0.41)),
                              ],
                            ),
                            const ZSpace(h: 9),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(cubitDt.mapMoneyBudget["${e.category}_$now"] ?? 0)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConfig.textColor,
                                      letterSpacing: -0.41),
                                ),
                                Text(
                                    "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(e.amount)}",
                                    // "${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ColorConfig.textColor,
                                        letterSpacing: -0.41)),
                              ],
                            ),
                            const ZSpace(h: 9),
                            LinearProgressIndicator(
                              value: (cubitDt.mapMoneyBudget["${e.category}_$now"] ?? 0) / e.amount,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  getColorFromValue((cubitDt.mapMoneyBudget["${e.category}_$now"] ?? 0) / e.amount)
                              ),
                            ),
                          ],
                        ),
                      ),
                  const ZSpace(h: 15)
                ],
              ))
        ],
      ),
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
