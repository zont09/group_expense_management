import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/wallet_model.dart';

class WalletRepository {
  WalletRepository._privateConstructor();

  static WalletRepository instance =
      WalletRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<WalletModel>> getAllWalletByGroup(String gid) async {
    try {
      final snapshot = await fireStore
          .collection("wallets")
          .where('enable', isEqualTo: true)
          .where('group', isEqualTo: gid)
          .get();
      return snapshot.docs
          .map((e) => WalletModel.fromSnapshot(e))
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

  Future<WalletModel?> getWalletById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("wallets")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => WalletModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<void> addWalletModel(WalletModel model) async {
    try {
      await fireStore
          .collection('wallets')
          .doc("wallets_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new wallet: $e");
    }
  }

  Future<void> updateWalletModel(WalletModel model) async {
    try {
      await fireStore
          .collection('wallets')
          .doc("wallets_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new wallet: $e");
    }
  }
}
