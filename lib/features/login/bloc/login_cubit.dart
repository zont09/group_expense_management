import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<int> {
  LoginCubit() : super(0);

  final TextEditingController conUsername = TextEditingController();
  final TextEditingController conPassword = TextEditingController();

  onLogin() {

  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}