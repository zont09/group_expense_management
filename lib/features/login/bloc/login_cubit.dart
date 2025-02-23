import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
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

  int errorUsername = -1;
  int errorPassword = -1;

  checkError() {
    if(conUsername.text.isEmpty) {
      errorUsername = 1;
    } else if(!isValidEmail(conUsername.text)) {
      errorUsername = 2;
    }  else {
      errorUsername = 0;
    }

    if(conPassword.text.isEmpty) {
      errorPassword = 1;
    } else {
      errorPassword = 0;
    }

    EMIT();
    return errorPassword > 0 || errorUsername > 0;
  }

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

  signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    final user = await AuthService().signInWithEmailAndPassword(email, password);
    if(user.first != null && context.mounted) {
      final success = await onGetUserInApp(user.first!, context);
      return success ? "success" : AppText.textHasErrorAndTryAgain.text;
    } else {
      return user.second;
    }
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

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}
