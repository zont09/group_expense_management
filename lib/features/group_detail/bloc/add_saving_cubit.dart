import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/saving_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/saving_service.dart';

class AddSavingCubit extends Cubit<int> {
  AddSavingCubit(this.group, this.user) : super(0);

  late final GroupModel group;
  late final UserModel user;

  final SavingService _savingService = SavingService.instance;

  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conDes = TextEditingController();
  final TextEditingController conTargetAmount = TextEditingController();
  DateTime targetDate = DateTime.now();
  // WalletModel? wallet;

  List<WalletModel> listWallets = [];

  bool canEdit = true;
  bool isEdit = false;

  initData(List<WalletModel> wallets) {
    listWallets.clear();
    listWallets.addAll([
      ...wallets,
      WalletModel(id: "Ca nhan", name: "Cá nhân", amount: -1),
      WalletModel(id: "Khac", name: "Khác", amount: -1)
    ]);
  }

  onSelectDate(DateTime date) {
    targetDate = date;
    EMIT();
  }

  onAddSaving() async {
    final newModel = SavingModel(
      id: FirebaseFirestore.instance.collection("savings").doc().id,
      title: conTitle.text,
      description: conDes.text,
      targetAmount: double.parse(conTargetAmount.text),
      targetDate: targetDate,
      group: group.id,
      owner: user.id,
    );
    await _savingService.addSavings(newModel);
    return newModel;
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
