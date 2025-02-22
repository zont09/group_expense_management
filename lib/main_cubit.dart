import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/user_model.dart';

class MainCubit extends Cubit<int> {
  MainCubit() : super(0);

  UserModel user = UserModel();

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