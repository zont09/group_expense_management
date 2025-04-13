import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/category_service.dart';
import 'package:group_expense_management/services/transaction_service.dart';
import 'package:group_expense_management/services/wallet_service.dart';

class GroupDetailCubit extends Cubit<int> {
  GroupDetailCubit(this.group) : super(0);

  final TransactionService _transactionService = TransactionService.instance;
  final WalletService _walletService = WalletService.instance;
  final CategoryService _categoryService = CategoryService.instance;
  late GroupModel group;

  List<TransactionModel>? transactions;
  List<WalletModel>? wallets;
  List<CategoryModel>? categories;

  initData() async {
    transactions?.clear();
    wallets?.clear();
    categories?.clear();
    transactions = await _transactionService.getAllTransactionByGroup(group.id);
    wallets = await _walletService.getAllWalletByGroup(group.id);
    categories = await _categoryService.getAllCategory();
    EMIT();
  }

  addTransaction(TransactionModel model) async {
    await _transactionService.addTransaction(model);
    transactions ??= [];
    transactions?.add(model);
    EMIT();
  }

  updateTransaction(TransactionModel model) async {
    int index = transactions?.indexWhere((e) => e.id == model.id) ?? -1;
    if(index != -1) {
      if(model.enable) {
        transactions?[index] = model;
      } else {
        transactions?.removeAt(index);
      }
    } else {
      transactions?.add(model);
    }
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

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}