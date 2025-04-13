import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/category_model.dart';
import 'package:group_expense_management/models/wallet_model.dart';

class AddTransactionCubit extends Cubit<int> {
  AddTransactionCubit() : super(0);

  final TextEditingController conTitle = TextEditingController();
  final TextEditingController conAmount = TextEditingController();
  final TextEditingController conDes = TextEditingController();
  WalletModel? wallet;
  CategoryModel? category;
  DateTime date = DateTime.now();



  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}