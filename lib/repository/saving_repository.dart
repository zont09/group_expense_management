import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/saving_model.dart';

class SavingRepository {
  SavingRepository._privateConstructor();

  static SavingRepository instance =
  SavingRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<SavingModel>> getAllSavings() async {
    try {
      final snapshot = await fireStore
          .collection("savings")
          .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => SavingModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all wallets by id group: $e");
      return [];
    }
  }

  Future<SavingModel?> getSavingById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("savings")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => SavingModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<List<SavingModel>> getSavingByGroup(String gid) async {
    try {
      final snapshot = await fireStore
          .collection("savings")
          .where('enable', isEqualTo: true)
          .where('group', isEqualTo: gid)
          .get();
      return snapshot.docs
          .map((e) => SavingModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return [];
    }
  }

  Future<void> addSaving(SavingModel model) async {
    try {
      await fireStore
          .collection('savings')
          .doc("savings_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new wallet: $e");
    }
  }

  Future<void> updateSaving(SavingModel model) async {
    try {
      await fireStore
          .collection('savings')
          .doc("savings_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new wallet: $e");
    }
  }
}
