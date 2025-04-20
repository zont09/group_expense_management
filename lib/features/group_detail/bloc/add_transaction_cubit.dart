import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/transaction_service.dart';

class AddTransactionCubit extends Cubit<int> {
  AddTransactionCubit(this.group, this.user) : super(0);

  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conAmount = TextEditingController();
  final TextEditingController conDes = TextEditingController();
  WalletModel? wallet;
  CategoryModel? category;
  DateTime date = DateTime.now();

  late GroupModel group;
  late UserModel user;

  addTransaction() async {
    final transaction = TransactionModel(
        id: FirebaseFirestore.instance.collection("transactions").doc().id,
        title: conTitle.text,
        amount: double.parse(conAmount.text),
        description: conDes.text,
        category: "${category!.id}_${category!.type}",
        wallet: wallet!.id,
        user: user.id,
        group: group.id,
        date: date,
        createAt: DateTime.now());
    await TransactionService.instance.addTransaction(transaction);
    return transaction;
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
