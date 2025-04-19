import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/currency_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/wallet_service.dart';

class AddWalletCubit extends Cubit<int> {
  AddWalletCubit(this.user, this.group) : super(0);

  final WalletService _walletService = WalletService.instance;
  final TextEditingController conName = TextEditingController();
  final TextEditingController conAmount = TextEditingController();
  final TextEditingController conNote = TextEditingController();
  late CurrencyModel currency;

  List<CurrencyModel> listCurrency = [
    CurrencyModel(id: "vnd", name: "VND", value: 1, enable: true),
    CurrencyModel(id: "usd", name: "USD", value: 25000, enable: true),
  ];

  late UserModel user;
  late GroupModel group;

  initData() {
    conName.clear();
    conAmount.clear();
    conNote.clear();
    currency = listCurrency[0];
  }

  addWallet() async {
    final wallet = WalletModel(
      id: FirebaseFirestore.instance.collection("wallets").doc().id,
      name: conName.text,
      amount: double.parse(conAmount.text),
      note: conNote.text,
      user: user.id,
      group: group.id, // Replace with actual group ID
    );
    await _walletService.addWallet(wallet);
    return wallet;
  }

  onChangeCurrency(CurrencyModel value) {
    currency = value;
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
