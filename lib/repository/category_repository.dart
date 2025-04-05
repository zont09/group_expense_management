import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/category_model.dart';

class CategoryRepository {
  CategoryRepository._privateConstructor();

  static CategoryRepository instance =
      CategoryRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<CategoryModel>> getAllCategory() async {
    try {
      final snapshot = await fireStore
          .collection("categories")
          .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => CategoryModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all wallets by id group: $e");
      return [];
    }
  }

  // Future<List<TransactionModel>> getAllTransactionsByWallet(String gid) async {
  //   try {
  //     final snapshot = await fireStore
  //         .collection("transactions")
  //         .where('enable', isEqualTo: true)
  //         .where('wallet', isEqualTo: gid)
  //         .get();
  //     return snapshot.docs
  //         .map((e) => TransactionModel.fromSnapshot(e))
  //         .toList();
  //   } catch (e) {
  //     debugPrint("====> Error get all group by id: $e");
  //     return [];
  //   }
  // }

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("categories")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => CategoryModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<void> addCategory(CategoryModel model) async {
    try {
      await fireStore
          .collection('categories')
          .doc("categories_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new wallet: $e");
    }
  }

  Future<void> updateCategory(CategoryModel model) async {
    try {
      await fireStore
          .collection('categories')
          .doc("categories_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new wallet: $e");
    }
  }
}
