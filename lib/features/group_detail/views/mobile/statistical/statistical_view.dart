import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/statistical_cubit.dart';
import 'package:group_expense_management/utils/function_utils.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class StatisticalView extends StatelessWidget {
  const StatisticalView({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailCubit, int>(
  builder: (cc, ss) {
    var cubitDt = BlocProvider.of<GroupDetailCubit>(cc);
    return BlocProvider(
      create: (context) => StatisticalCubit(cubitDt)..initData(),
      child: BlocBuilder<StatisticalCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<StatisticalCubit>(c);
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    width: 30,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        6,
                                        (index) {
                                          // Các giá trị trục Y (từ 0 đến maxY)
                                          final value = (5 - index) *
                                              (cubit.maxValue / 5).floor();
                                          return Text(
                                            // FunctionUtils.formatVND(value.toDouble()),
                                            FunctionUtils.shortMoney(
                                                value.toDouble()),
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: true
                                            ? FunctionUtils.getDaysInMonth(
                                                    cubit.date.year,
                                                    cubit.date.month) *
                                                40.0
                                            : 480,
                                        height: 400,
                                        child: BarChart(
                                          BarChartData(
                                            barGroups: cubit.dayCostIncome
                                                .asMap()
                                                .entries
                                                .map((item) {
                                              return BarChartGroupData(
                                                x: item.key,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: item.value,
                                                    color:
                                                        ColorConfig.greenState,
                                                    width: 15,
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                  BarChartRodData(
                                                    toY: cubit.dayCostOutcome[
                                                        item.key],
                                                    color: ColorConfig.redState,
                                                    width: 15,
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              rightTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              topTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                    showTitles: false),
                                              ),
                                              bottomTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  getTitlesWidget:
                                                      (double value,
                                                          TitleMeta meta) {
                                                    return Text(value
                                                        .toInt()
                                                        .toString());
                                                  },
                                                ),
                                              ),
                                            ),
                                            borderData: FlBorderData(
                                              show: true,
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.black,
                                                  // Màu của đường viền bên trái
                                                  width:
                                                      1, // Độ dày của đường viền
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  // Màu của đường viền dưới cùng
                                                  width:
                                                      1, // Độ dày của đường viền
                                                ),
                                                right: BorderSide.none,
                                                // Ẩn viền bên phải
                                                top: BorderSide
                                                    .none, // Ẩn viền trên
                                              ),
                                            ),
                                            gridData: FlGridData(
                                              show: true,
                                              drawVerticalLine: true,
                                              drawHorizontalLine: true,
                                              getDrawingHorizontalLine:
                                                  (value) {
                                                return FlLine(
                                                  color: Colors.grey,
                                                  strokeWidth: 0.5,
                                                );
                                              },
                                              getDrawingVerticalLine: (value) {
                                                return FlLine(
                                                  color: Colors.grey,
                                                  strokeWidth: 0.5,
                                                );
                                              },
                                            ),
                                            barTouchData: BarTouchData(
                                              touchTooltipData:
                                                  BarTouchTooltipData(
                                                getTooltipColor: (group) {
                                                  return ColorConfig.primary3;
                                                },
                                                tooltipMargin: 8,
                                                // Khoảng cách giữa tooltip và cột
                                                fitInsideHorizontally: true,
                                                // Đảm bảo tooltip không vượt ra ngoài màn hình theo chiều ngang
                                                fitInsideVertically: true,
                                                // Đảm bảo tooltip không vượt ra ngoài màn hình theo chiều dọc
                                                getTooltipItem: (group,
                                                    groupIndex, rod, rodIndex) {
                                                  return BarTooltipItem(
                                                    FunctionUtils.formatVND(
                                                        rod.toY),
                                                    TextStyle(
                                                        color: Colors.white),
                                                  );
                                                },
                                              ),
                                              touchCallback: (event, response) {
                                                if (response != null &&
                                                    response.spot != null) {
                                                  print(
                                                      'Touched spot at x: ${response.spot!.touchedBarGroupIndex}, y: ${response.spot!.touchedRodData.toY}');
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    const ZSpace(h: 12),
                    Container(
                        // height: 500,
                        child: CategoryStatistical(
                            cubit: cubit,
                            cateCost: cubit.cateCostOut,
                            title: "Thống kê chi")),
                    const ZSpace(h: 12),
                    Container(
                        // height: 500,
                        child: CategoryStatistical(
                            cubit: cubit,
                            cateCost: cubit.cateCostIn,
                            title: "Thống kê thu"))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  },
);
  }
}

class CategoryStatistical extends StatefulWidget {
  const CategoryStatistical(
      {super.key,
      required this.cubit,
      required this.cateCost,
      required this.title});

  final StatisticalCubit cubit;
  final Map<String, double> cateCost;
  final String title;

  @override
  State<CategoryStatistical> createState() => _CategoryStatisticalState();
}

class _CategoryStatisticalState extends State<CategoryStatistical> {
  int touchIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double maxW = MediaQuery.of(context).size.width;
    final listOutcome = widget.cateCost.entries.toList();
    double totalOutcome = widget.cateCost.isNotEmpty
        ? widget.cateCost.values.reduce((a, b) => a + b)
        : 0.0;
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 5),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Container(
              height: 400,
              child: Stack(alignment: Alignment.center, children: [
                listOutcome.isEmpty
                    ? Center(child: Text("Không có dữ liệu"))
                    : Padding(
                        padding: EdgeInsets.all(16),
                        child: PieChart(
                          PieChartData(
                            sections: getSections(widget.cateCost, touchIndex),
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchIndex = -1;
                                    return;
                                  }
                                  touchIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                  print("touched index ${touchIndex}");
                                  print(
                                      "Value index ${touchIndex != -1 ? getSections(widget.cateCost, touchIndex)[touchIndex].value : 00} ");
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                listOutcome.isEmpty
                    ? Center(
                        child: Text("Không có dữ liệu"),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 0.5 * maxW,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              // Thu nhỏ chữ nếu vượt quá không gian
                              child: Text(
                                touchIndex == -1
                                    ? "Tổng"
                                    : listOutcome[touchIndex].key,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0.5 * maxW,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                touchIndex == -1
                                    ? FunctionUtils.formatVND(totalOutcome)
                                    : '${FunctionUtils.formatVND(getSections(widget.cateCost, touchIndex)[touchIndex].value)}',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
              ]),
            ),
            ...listOutcome.asMap().entries.map((item) => Padding(
                  padding:
                      EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.square,
                                color: ColorConfig.chartColors[item.key],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                item.value.key,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis),
                              )
                            ],
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  FunctionUtils.formatVND(item.value.value),
                                  style: TextStyle(fontSize: 15),
                                )),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

List<PieChartSectionData> getSections(
    Map<String, double> dataChart, int touchedIndex) {
  double totalValue =
      dataChart.isNotEmpty ? dataChart.values.reduce((a, b) => a + b) : 0.0;
  return dataChart.entries.toList().asMap().entries.map((entry) {
    final index = entry.key;
    final data = entry.value;
    final isTouched = index == touchedIndex;
    final double radius = isTouched ? 60 : 50;

    return PieChartSectionData(
      value: data.value,
      color: ColorConfig.chartColors[index % 20],
      title: (data.value / totalValue * 100) > 3
          ? '${(data.value / totalValue * 100).toStringAsFixed(1)}%'
          : "",
      radius: radius,
      titleStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }).toList();
}
