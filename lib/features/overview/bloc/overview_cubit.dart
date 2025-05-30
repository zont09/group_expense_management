import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/notification_model.dart';
import 'package:group_expense_management/services/group_service.dart';
import 'package:group_expense_management/services/notification_service.dart';

class OverviewCubit extends Cubit<int> {
  OverviewCubit() : super(0);

  final GroupService _groupService = GroupService.instance;

  List<GroupModel> groups = [];
  List<NotificationModel> notifications = [];
  Map<String, GroupModel> mapGroup = {};

  initData(String uid) async {
    uid = "oZbEeh0GJyk7I8otkySf";
    groups.clear();
    final data = await _groupService.getAllGroupForUser(uid);
    final notis = await NotificationService.instance.getAllNotificationForUser(uid);
    for(var e in notis) {
      if(e.notiTo.contains(uid)) {

      }
    }
    groups.addAll(data);
    for(var e in groups) {
      mapGroup[e.id] = e;
    }
    notifications.addAll(notis);
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