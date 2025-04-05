import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/transaction_model.dart';

class TransactionRepository {
  TransactionRepository._privateConstructor();

  static TransactionRepository instance =
      TransactionRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<TransactionModel>> getAllTransactionsByGroup(String gid) async {
    try {
      final snapshot = await fireStore
          .collection("transactions")
          .where('enable', isEqualTo: true)
          .where('group', isEqualTo: gid)
          .get();
      return snapshot.docs
          .map((e) => TransactionModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all group by id: $e");
      return [];
    }
  }

  Future<List<TransactionModel>> getAllTransactionsByWallet(String gid) async {
    try {
      final snapshot = await fireStore
          .collection("transactions")
          .where('enable', isEqualTo: true)
          .where('wallet', isEqualTo: gid)
          .get();
      return snapshot.docs
          .map((e) => TransactionModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all group by id: $e");
      return [];
    }
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("transactions")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => TransactionModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get transaction by id: $e");
      return null;
    }
  }

  Future<void> addTransaction(TransactionModel model) async {
    try {
      await fireStore
          .collection('transactions')
          .doc("transactions_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new transaction: $e");
    }
  }

  Future<void> updateTransaction(TransactionModel model) async {
    try {
      await fireStore
          .collection('transactions')
          .doc("transactions_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new transaction: $e");
    }
  }
}
