import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/group_model.dart';

class GroupRepository {
  GroupRepository._privateConstructor();

  static GroupRepository instance = GroupRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<GroupModel>> getAllGroupsByUser(String uid) async {
    try {
      final snapshot = await fireStore
          .collection("groups")
          .where('enable', isEqualTo: true)
          .where(Filter.or(
              Filter('members', arrayContains: uid),
              Filter('managers', arrayContains: uid),
              Filter('owner', isEqualTo: uid)))
          .get();
      return snapshot.docs.map((e) => GroupModel.fromSnapshot(e)).toList();
    } catch (e) {
      debugPrint("====> Error get all group by user: $e");
      return [];
    }
  }

  Future<GroupModel?> getGroupById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("groups")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs.map((e) => GroupModel.fromSnapshot(e)).firstOrNull;
    } catch (e) {
      debugPrint("====> Error get transaction by id: $e");
      return null;
    }
  }

  Future<void> addGroup(GroupModel model) async {
    try {
      await fireStore
          .collection('groups')
          .doc("groups_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new transaction: $e");
    }
  }

  Future<void> updateGroup(GroupModel model) async {
    try {
      await fireStore.collection('groups').doc("groups_${model.id}").set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new transaction: $e");
    }
  }
}
