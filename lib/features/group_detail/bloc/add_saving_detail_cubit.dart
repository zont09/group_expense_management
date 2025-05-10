import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/transaction_service.dart';

class AddSavingDetailCubit extends Cubit<int> {

  AddSavingDetailCubit(this.group, this.user, this.saving) : super(0);

  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conAmount = TextEditingController();
  final TextEditingController conDes = TextEditingController();
  WalletModel? wallet;
  List<WalletModel> listWallets = [];
  DateTime date = DateTime.now();

  late GroupModel group;
  late UserModel user;
  late SavingModel saving;

  bool isEdit = false;
  bool canEdit = true;

  initData(List<WalletModel> wallets) {
    listWallets.clear();
    listWallets.addAll(wallets);
    conTitle.text = "Đóng tiền TK -> ${saving.title}";
  }

  addTransaction() async {
    final newModel = TransactionModel(
      id: FirebaseFirestore.instance.collection("transactions").doc().id,
      title: conTitle.text,
      amount: double.parse(conAmount.text),
      description: conDes.text,
      wallet: wallet!.id,
      category: "-9_1",
      user: user.id,
      group: group.id
    );
    await TransactionService.instance.addTransaction(newModel);
    return newModel;
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}