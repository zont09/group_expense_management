import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/budget_model.dart';

class BudgetViewCubit extends Cubit<int> {
  BudgetViewCubit() : super(0);

  List<BudgetModel> budgets = [];
  List<BudgetDetailModel> budgetDetails = [];


  initData() {

  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}