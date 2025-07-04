import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/budget_model.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/budget_service.dart';
import 'package:group_expense_management/services/category_service.dart';
import 'package:group_expense_management/services/saving_service.dart';
import 'package:group_expense_management/services/transaction_service.dart';
import 'package:group_expense_management/services/wallet_service.dart';

class GroupDetailCubit extends Cubit<int> {
  GroupDetailCubit(this.group, this.mC) : super(0);

  final TransactionService _transactionService = TransactionService.instance;
  final WalletService _walletService = WalletService.instance;
  final CategoryService _categoryService = CategoryService.instance;
  final BudgetService _budgetService = BudgetService.instance;
  final SavingService _savingService = SavingService.instance;
  late GroupModel group;
  late MainCubit mC;
  UserModel userCurrent = UserModel();

  List<TransactionModel>? transactions;
  List<WalletModel>? wallets;
  List<CategoryModel>? categories;
  List<BudgetDetailModel>? budgetDetails;
  List<SavingModel>? savings;
  List<BudgetModel>? budgets;
  Map<String, double> mapMoneyBudget = {};
  Map<String, CategoryModel> mapCate = {};
  Map<String, TransactionModel> mapTrans = {};
  List<UserModel> listUser = [];

  initData() async {
    transactions?.clear();
    wallets?.clear();
    categories?.clear();
    budgets?.clear();
    budgetDetails?.clear();
    savings?.clear();
    listUser.clear();
    transactions = await _transactionService.getAllTransactionByGroup(group.id);
    for(var e in transactions ?? []) {
      mapTrans[e.id] = e;
    }
    wallets = await _walletService.getAllWalletByGroup(group.id);
    categories = await _categoryService.getAllCategory();
    for(var e in categories ?? []) {
      debugPrint("====> Cate: ${e.title}");
      mapCate[e.id] = e;
    }
    categories?.sort((a, b) => a.type.compareTo(b.type));
    budgets = await _budgetService.getBudgetByGroup(group.id);
    budgetDetails = [];
    for(var e in budgets!) {
      for(var f in e.detail) {
        final data = await _budgetService.getBudgetDetailById(f);
        if(data != null) {
          budgetDetails!.add(data);
        }
      }
    }
    savings = await _savingService.getAllSavingsByGroup(group.id);
    transactions!.sort((a, b) => b.date.compareTo(a.date));
    if(group.owner == mC.user.id) {
      UserModel tmp = mC.user;
      tmp.roleInGroup = 0;
      userCurrent = tmp;
      listUser.add(tmp.copyWith());
    }
    if(group.managers.any((e) => e == mC.user.id)) {
      UserModel tmp = mC.user;
      tmp.roleInGroup = 1;
      userCurrent = tmp;
      listUser.add(tmp.copyWith());
    }
    if(group.members.any((e) => e == mC.user.id)) {
      UserModel tmp = mC.user;
      tmp.roleInGroup = 2;
      userCurrent = tmp;
      listUser.add(tmp.copyWith());
    }
    calculateBudget();
    EMIT();
  }

  addTransaction(TransactionModel model) async {
    // await _transactionService.addTransaction(model);
    transactions ??= [];
    transactions?.add(model);
    mapTrans[model.id] = model;
    calculateBudget();
    EMIT();
  }

  updateTransaction(TransactionModel model) async {
    int index = transactions?.indexWhere((e) => e.id == model.id) ?? -1;
    if(index != -1) {
      if(model.enable) {
        transactions?[index] = model;
        mapTrans[model.id] = model;
      } else {
        transactions?.removeAt(index);
        mapTrans.remove(model.id);
      }
    } else {
      transactions?.add(model);
      mapTrans[model.id] = model;
    }
    calculateBudget();
    EMIT();
  }

  addWallet(WalletModel model) async {
    await _walletService.addWallet(model);
    wallets ??= [];
    wallets?.add(model);
    EMIT();
  }

  updateWallet(WalletModel model) async {
    int index = wallets?.indexWhere((e) => e.id == model.id) ?? -1;
    if(index != -1) {
      if(model.enable) {
        wallets?[index] = model;
      } else {
        wallets?.removeAt(index);
      }
    } else {
      wallets?.add(model);
    }
    EMIT();
  }

  addBudget(BudgetModel model) async {
    budgets ??= [];
    budgets?.add(model);
    EMIT();
  }

  updateBudget(BudgetModel model) async {
    int index = budgets?.indexWhere((e) => e.id == model.id) ?? -1;
    if(index != -1) {
      if(model.enable) {
        budgets?[index] = model;
      } else {
        budgets?.removeAt(index);
      }
    } else {
      budgets?.add(model);
    }
    EMIT();
  }

  addBudgetDetail(BudgetDetailModel model) async {
    budgetDetails ??= [];
    budgetDetails?.add(model);
    EMIT();
  }

  updateBudgetDetail(BudgetDetailModel model) async {
    int index = budgetDetails?.indexWhere((e) => e.id == model.id) ?? -1;
    if(index != -1) {
      if(model.enable) {
        budgetDetails?[index] = model;
      } else {
        budgetDetails?.removeAt(index);
      }
    } else {
      budgetDetails?.add(model);
    }
    EMIT();
  }

  addSaving(SavingModel model) async {
    savings ??= [];
    savings?.add(model);
    EMIT();
  }

  updateSaving(SavingModel model) async {
    int index = savings?.indexWhere((e) => e.id == model.id) ?? -1;
    if(index != -1) {
      if(model.enable) {
        savings?[index] = model;
      } else {
        savings?.removeAt(index);
      }
    } else {
      savings?.add(model);
    }
    EMIT();
  }

  calculateBudget() {
    mapMoneyBudget.clear();
    for(var e in transactions ?? <TransactionModel>[]) {
      final keySpent = "${e.category.split("_")[0]}_${e.date.month}/${e.date.year}";
      if(mapMoneyBudget.containsKey(keySpent)) {
        mapMoneyBudget[keySpent] = mapMoneyBudget[keySpent]! + e.amount;
      } else {
        mapMoneyBudget[keySpent] = e.amount;
      }
      print("=====> calc: $keySpent - ${mapMoneyBudget[keySpent]}");
    }
    EMIT();
  }

  updateGroup(GroupModel model) {
    group = model;
    debugPrint("====> update group: ----> EMIT");
    EMIT();
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}