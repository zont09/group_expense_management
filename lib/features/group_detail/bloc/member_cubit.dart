import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/user_model.dart';

class MemberCubit extends Cubit<int> {
  MemberCubit(this.group, this.user, this.mC) : super(0);

  late final UserModel user;
  late final GroupModel group;
  late final MainCubit mC;

  List<UserModel> listMember = [];

  initData() {
    UserModel? owner = mC.mapUser[group.owner];
    if(owner != null) {
      owner = owner.copyWith();
      owner.roleInGroup = 0;
      listMember.add(owner);
      print("===> owner: ${owner.name} - ${owner.roleInGroup}");
    }

    for (var e in group.managers) {
      UserModel? mem = mC.mapUser[e];
      if(mem == null) continue;
      mem = mem.copyWith();
      mem.roleInGroup = 1;
      print("===> Manager: ${mem.name} - ${mem.roleInGroup}");
      listMember.add(mem);
    }

    for (var e in group.members) {
      UserModel? mem = mC.mapUser[e];
      if(mem == null) continue;
      mem = mem.copyWith();
      mem.roleInGroup = 2;
      print("===> Member: ${mem.name} - ${mem.roleInGroup}");
      listMember.add(mem);
    }

    for(var e in listMember) {
      print("===> member: ${e.name} - ${e.roleInGroup}");
    }
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}