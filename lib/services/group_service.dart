import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/repository/group_repository.dart';

class GroupService {
  GroupService._privateConstructor();

  static GroupService instance = GroupService._privateConstructor();

  final GroupRepository _groupRepository = GroupRepository.instance;

  Future<List<GroupModel>> getAllGroupForUser(String uid) async {
    final response = await _groupRepository.getAllGroupsByUser(uid);
    return response;
  }

  Future<GroupModel?> getGroupById(String id) async {
    final response = await _groupRepository.getGroupById(id);
    return response;
  }

  Future<void> addGroup(GroupModel model) async {
    await _groupRepository.addGroup(model);
  }

  Future<void> updateGroup(GroupModel model) async {
    await _groupRepository.updateGroup(model);
  }
}
