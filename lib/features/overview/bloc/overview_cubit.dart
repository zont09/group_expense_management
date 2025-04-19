import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/services/group_service.dart';

class OverviewCubit extends Cubit<int> {
  OverviewCubit() : super(0);

  final GroupService _groupService = GroupService.instance;

  List<GroupModel> groups = [];

  initData(String uid) async {
    uid = "oZbEeh0GJyk7I8otkySf";
    groups.clear();
    final data = await _groupService.getAllGroupForUser(uid);
    groups.addAll(data);
    EMIT();
  }

  addGroup(GroupModel model) {
    if(groups.contains(model)) return;
    _groupService.addGroup(model);
    groups.add(model);
    EMIT();
  }

  EMIT() {
    if (!isClosed) {
      emit(state + 1);
    }
  }
}