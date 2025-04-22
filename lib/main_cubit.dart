import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/services/user_service.dart';

class MainCubit extends Cubit<int> {
  MainCubit() : super(0);

  static MainCubit fromContext(BuildContext context) =>
      BlocProvider.of<MainCubit>(context);

  final UserService _userService = UserService.instance;

  List<UserModel> allUsers = [];
  Map<String, UserModel> mapUser = {};

  UserModel user = UserModel(name: "None");

  initData() async {
    user = UserModel(id: "oZbEeh0GJyk7I8otkySf", name: "Pham Ngoc Thinh", email: "ngocthinh2209@gmail.com");
    await loadAllUser();
    EMIT();
  }

  loadAllUser() async {
    final data = await _userService.getAllUsers();
    allUsers.clear();
    allUsers.addAll(data);
    for(var e in allUsers) {
      mapUser[e.id] = e;
    }
  }

  changeUser(UserModel u) {
    user = u;
    EMIT();
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}