import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/models/transaction_model.dart';

class StatisticalCubit extends Cubit<int> {
  StatisticalCubit(this.cubitDt) : super(0);

  late final GroupDetailCubit cubitDt;

  DateTime date = DateTime.now();
  double maxValue = 0;

  Map<String, double> cateCostIn = {};
  Map<String, double> cateCostOut = {};
  List<double> dayCostIncome = List.filled(32, 0);
  List<double> dayCostOutcome = List.filled(32, 0);

  initData() {
    date = DateTime(2025, 4, 1);
    calcStatisticalByDay();
    calcStatisticalByCategory();
    EMIT();
  }

  calcStatisticalByCategory() {
    cateCostIn.clear();
    cateCostOut.clear();
    for (var e in cubitDt.transactions ?? <TransactionModel>[]) {
      if (!isSameMonthAndYear(e.date, date)) continue;
      String cateId = e.category.split("_")[1];
      String cate = cubitDt.mapCate[cateId]?.title ?? "Không rõ";
      // debugPrint("===> Check cate transaction:");
      if(cateId == '1') {
        if (!cateCostIn.containsKey(cate)) {
          cateCostIn[cate] = 0;
        }
        cateCostIn[cate] = cateCostIn[cate]! + e.amount;
      } else {
        if (!cateCostOut.containsKey(cate)) {
          cateCostOut[cate] = 0;
        }
        cateCostOut[cate] = cateCostOut[cate]! + e.amount;
      }
    }
  }

  calcStatisticalByDay() {
    maxValue = 0;
    for(int i = 0; i < dayCostIncome.length; i++) {
      dayCostIncome[i] = 0;
    }
    for(int i = 0; i < dayCostOutcome.length; i++) {
      dayCostOutcome[i] = 0;
    }
    // for(var e in dayCostIncome) {
    //   e = 0;
    // }
    // for(var e in dayCostOutcome) {
    //   e = 0;
    // }
    for (var e in cubitDt.transactions ?? <TransactionModel>[]) {
      if (!isSameMonthAndYear(e.date, date)) continue;
      int day = e.date.day;
      String cateType = e.category.split("_")[1];
      if(cateType == "1") {
        dayCostIncome[day] += e.amount;
      } else {
        dayCostOutcome[day] += e.amount;
      }
    }
    for(int i = 1; i <= 31; i++) {
      maxValue = max(maxValue, max(dayCostIncome[i], dayCostOutcome[i]));
      debugPrint("===> Day $i: ${dayCostIncome[i]} - ${dayCostOutcome[i]}");
    }
  }

  changeDate(DateTime v) {
    date = v;
    calcStatisticalByDay();
    calcStatisticalByCategory();
    EMIT();
  }

  bool isSameMonthAndYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
