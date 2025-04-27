import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/utils/function_utils.dart';

class TransactionViewCubit extends Cubit<int> {
  TransactionViewCubit() : super(0);

  List<TransactionModel> listData = [];
  List<TransactionModel> listShow = [];

  final TextEditingController controller = TextEditingController();

  initData(List<TransactionModel> data) {
    listData.clear();
    listShow.clear();
    listData.addAll(data);
    updateListShow();
  }

  updateListShow() {
    listShow.clear();
    listShow.addAll(listData.where((e) => controller.text.isEmpty || FunctionUtils()
        .normalizeVietnamese(e.title)
        .contains(FunctionUtils().normalizeVietnamese(controller.text))));
    EMIT();
  }

  updateSearch(String value) {
    updateListShow();
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
