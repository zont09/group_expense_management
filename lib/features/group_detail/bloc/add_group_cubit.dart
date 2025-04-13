import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/user_model.dart';

class AddGroupCubit extends Cubit<int> {
  AddGroupCubit() : super(0);

  final TextEditingController conName = TextEditingController();
  List<UserModel> members = [];

  addMember(UserModel model) {
    if(members.contains(model)) return;
    members.add(model);
    EMIT();
  }

  removeMember(UserModel model) {
    members.removeWhere((e) => e.id == model.id);
    EMIT();
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}