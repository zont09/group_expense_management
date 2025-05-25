import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/services/group_service.dart';

class AddMemberCubit extends Cubit<int> {
  AddMemberCubit(this.group) : super(0);

  late final GroupModel group;

  final GroupService _groupService = GroupService.instance;

  List<UserModel> listMember = [];

  initData() {

  }

  addMember(UserModel u) {
    if(!listMember.any((e) => e.id == u.id)) {
      listMember.add(u);
    }
    EMIT();
  }

  removeMember(UserModel u) {
    int index = listMember.indexWhere((e) => e.id == u.id);
    if(index != -1) {
      listMember.removeAt(index);
    }
    EMIT();
  }

  handleAddMember()  {
    GroupModel updGroup = group.copyWith();
    for(var e in listMember) {
      updGroup = updGroup.copyWith(members: updGroup.members + [e.id]);
    }
    _groupService.updateGroup(updGroup);
    EMIT();
    return updGroup;
  }

  EMIT() {
    if(!isClosed) {
      emit(state + 1);
    }
  }
}