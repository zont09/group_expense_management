import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/features/test/models.dart';
import 'package:group_expense_management/models/budget_detail_model.dart';
import 'package:group_expense_management/models/budget_model.dart';

class BudgetRepository {
  BudgetRepository._privateConstructor();

  static BudgetRepository instance =
  BudgetRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<BudgetModel>> getAllBudgets() async {
    try {
      final snapshot = await fireStore
          .collection("budgets")
          .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => BudgetModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all wallets by id group: $e");
      return [];
    }
  }

  Future<BudgetModel?> getBudgetById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("budgets")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => BudgetModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<BudgetModel?> getBudgetByGroupAndDate(String gid, DateTime date) async {
    try {

      debugPrint("====> ${gid} - ${date}");
      final snapshot = await fireStore
          .collection("budgets")
          .where('enable', isEqualTo: true)
          .where('group', isEqualTo: gid)
          // .where('date', isEqualTo: date)
          .get();
      return snapshot.docs
          .map((e) => BudgetModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<List<BudgetModel>> getBudgetByGroup(String gid) async {
    try {
      final snapshot = await fireStore
          .collection("budgets")
          .where('enable', isEqualTo: true)
          .where('group', isEqualTo: gid)
          .get();
      return snapshot.docs
          .map((e) => BudgetModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return [];
    }
  }

  Future<void> addBudget(BudgetModel model) async {
    try {
      await fireStore
          .collection('budgets')
          .doc("budgets_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new wallet: $e");
    }
  }

  Future<void> updateBudget(BudgetModel model) async {
    try {
      await fireStore
          .collection('budgets')
          .doc("budgets_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new wallet: $e");
    }
  }

  Future<List<BudgetDetailModel>> getAllBudgetDetails() async {
    try {
      final snapshot = await fireStore
          .collection("budget_details")
          .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => BudgetDetailModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all wallets by id group: $e");
      return [];
    }
  }

  Future<BudgetDetailModel?> getBudgetDetailById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("budget_details")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => BudgetDetailModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<BudgetDetailModel?> getBudgetDetailByBudgetCateDate(String bid, String cid, DateTime date) async {
    try {
      final snapshot = await fireStore
          .collection("budget_details")
          .where('enable', isEqualTo: true)
          .where('budget', isEqualTo: bid)
          .where('category', isEqualTo: cid)
          .where('date', isEqualTo: date)
          .get();
      return snapshot.docs
          .map((e) => BudgetDetailModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<void> addBudgetDetail(BudgetDetailModel model) async {
    try {
      await fireStore
          .collection('budget_details')
          .doc("budget_details_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new wallet: $e");
    }
  }

  Future<void> updateBudgetDetail(BudgetDetailModel model) async {
    try {
      await fireStore
          .collection('budget_details')
          .doc("budget_details_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new wallet: $e");
    }
  }
}
