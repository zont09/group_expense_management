import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/budget_model.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/services/budget_service.dart';
import 'package:group_expense_management/utils/toast_utils.dart';

class AddBudgetCubit extends Cubit<int> {
  AddBudgetCubit(this.group) : super(0);

  late final GroupModel group;

  final BudgetService _budgetService = BudgetService.instance;

  final TextEditingController conAmount = TextEditingController();
  DateTime date = DateTime.now();
  CategoryModel? category;
  List<CategoryModel> listCategory = [];

  initData(List<CategoryModel> data) async {
    conAmount.text = '';
    final now = DateTime.now();
    date = DateTime(now.year, now.month);
    listCategory.addAll(data);
    EMIT();
  }

  onChangeCategory(CategoryModel v) {
    category = v;
    EMIT();
  }

  changeDate(DateTime d) {
    date = DateTime(d.year, d.month);
    EMIT();
  }

  addBudget(BuildContext context) async {
    final dataBd = await _budgetService.getBudgetByGroupAndDate(group.id ,date);
    BudgetModel model = dataBd ?? BudgetModel(
      id: FirebaseFirestore.instance.collection('budgets').doc().id,
      date: date,
      detail: [],
      group: group.id,
      enable: true,
    );
    final isExist = await _budgetService.getBudgetDetailByBudgetCateDate(model.id ,category!.id, date);
    if(isExist == null) {
      ToastUtils.showBottomToast(context, "Ngân sách này đã được tạo rồi, vui lòng thử lại");
      return null;
    }
    final modelDetail = BudgetDetailModel(
      id: FirebaseFirestore.instance.collection('budget_details').doc().id,
      category: category!.id,
      group: group.id,
      amount: double.tryParse(conAmount.text) ?? 0,
      enable: true,
    );
    model = model.copyWith(detail: [...model.detail, modelDetail.id]);
    if(dataBd == null) {
      await _budgetService.addBudget(model);
    } else {
      await _budgetService.updateBudget(model);
    }
    await _budgetService.addBudgetDetail(modelDetail);
    return model;
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}