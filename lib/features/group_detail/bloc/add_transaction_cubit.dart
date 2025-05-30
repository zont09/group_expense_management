import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/features/test/models.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/notification_model.dart';
import 'package:group_expense_management/models/transaction_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';
import 'package:group_expense_management/services/notification_service.dart';
import 'package:group_expense_management/services/transaction_service.dart';
import 'package:group_expense_management/services/wallet_service.dart';
import 'package:group_expense_management/utils/toast_utils.dart';

class AddTransactionCubit extends Cubit<int> {
  AddTransactionCubit(this.group, this.user, this.mC) : super(0);

  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conAmount = TextEditingController();
  final TextEditingController conDes = TextEditingController();
  WalletModel? wallet;
  CategoryModel? category;
  List<WalletModel> listWallets = [];
  List<CategoryModel> listCates = [];
  DateTime date = DateTime.now();

  late GroupModel group;
  late UserModel user;
  late final MainCubit mC;

  bool isEdit = true;
  bool canEdit = true;
  TransactionModel? model;

  initData(bool isEditMode, List<WalletModel> ws, List<CategoryModel> lc,
      {TransactionModel? model}) {
    isEdit = isEditMode;
    if (isEdit) {
      canEdit = false;
      model = model;
      conTitle.text = model!.title;
      conAmount.text = model.amount.toString();
      conDes.text = model.description;
      wallet = ws.where((e) => e.id == model!.wallet).firstOrNull;
      category =
          lc.where((e) => e.id == model!.category.split('_')[0]).firstOrNull;
    }
  }

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
    final noti = NotificationModel(
        id: FirebaseFirestore.instance.collection('notifications').doc().id,
        date: DateTime.now(),
        toUser: [
          ...group.members.where((e) => e != mC.user.id),
          ...group.managers.where((e) => e != mC.user.id),
          if (group.owner != mC.user.id) mC.user.id
        ],
        notiTo: [
          ...group.members.where((e) => e != mC.user.id),
          ...group.managers.where((e) => e != mC.user.id),
          if (group.owner != mC.user.id) mC.user.id
        ],
        group: group.id,
        description:
            "${mC.user.name} đã thêm giao dịch mới: ${category!.type == 0 ? "-" : "+"}${conAmount.text} vào ${group.name}");
    NotificationService.instance.addNotification(noti);
    return transaction;
  }

  updateTransaction(
      BuildContext context,
      WalletModel newWallet,
      Function(TransactionModel) updTran,
      Function(WalletModel) updWallet) async {
    if (model == null) return;
    final oldCatType = model!.category.split('_')[1] == '0' ? -1 : 1;
    final newCatType = (category?.type.toString() ?? '0') == '0' ? -1 : 1;
    double newAmount = 0;
    newAmount =
        newCatType * double.parse(conAmount.text) - oldCatType * model!.amount;
    if (newWallet.amount < newAmount) {
      ToastUtils.showBottomToast(
          context, "Ví không còn đủ số dư để thực hiện giao dịch");
      return;
    }

    await WalletService.instance
        .updateWallet(newWallet.copyWith(amount: newWallet.amount - newAmount));

    final tran = model!.copyWith(
      title: conTitle.text,
      amount: newAmount,
      description: conDes.text,
      category: "${category!.id}_${category!.type}",
      wallet: wallet!.id,
      user: user.id,
      group: group.id,
      date: date,
      updateAt: DateTime.now(),
    );

    await TransactionService.instance.updateTransaction(tran);
    updTran(tran);
    updWallet(newWallet.copyWith(amount: newWallet.amount - newAmount));
    EMIT();
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
