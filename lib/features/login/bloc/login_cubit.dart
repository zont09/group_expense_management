import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/services/auth_service.dart';
import 'package:group_expense_management/services/user_service.dart';
import 'package:group_expense_management/utils/function_utils.dart';

class LoginCubit extends Cubit<int> {
  LoginCubit() : super(0);

  final UserService _userService = UserService.instance;

  final TextEditingController conUsername = TextEditingController();
  final TextEditingController conPassword = TextEditingController();

  onSignInWithGoogle(BuildContext context) async {
    final user = await AuthService().signInWithGoogle();
    if (user != null) {
      print("Đăng nhập thành công: ${user.displayName} - ${user.email}");
      if(context.mounted) {
        final success = await onGetUserInApp(user, context);
        return success;
      }
    } else {
      print("Đăng nhập thất bại");
    }
    return false;
  }

  onGetUserInApp(User u, BuildContext context) async {
    final userInApp = await _userService.getUserByEmail(u.email ?? "");
    if (userInApp == null) {
      final id = FunctionUtils.getIdDb("users");
      final newUser = UserModel(
        id: id,
        name: u.displayName ?? id,
        email: u.email ?? "",
        phone: "",
      );
      await _userService.addUser(newUser);
      if(context.mounted) {
        final mainCB = MainCubit.fromContext(context);
        mainCB.changeUser(newUser);
      }
      return true;
    }
    if(userInApp.enable) {
      if(context.mounted) {
        final mainCB = MainCubit.fromContext(context);
        mainCB.changeUser(userInApp);
      }
      return true;
    }
    return false;
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
