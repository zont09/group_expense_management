import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/user_model.dart';

class UserRepository {
  UserRepository._privateConstructor();

  static UserRepository instance = UserRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await fireStore
          .collection("users")
          .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => UserModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all users: $e");
      return [];
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final snapshot = await fireStore
          .collection("users")
          .where("email", isEqualTo: email)
          // .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => UserModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get user by email: $e");
      return null;
    }
  }

  Future<void> addUser(UserModel model) async {
    try {
      await fireStore
          .collection('users')
          .doc("users_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new user: $e");
    }
  }

  Future<void> updateUser(UserModel model) async {
    try {
      await fireStore
          .collection('users')
          .doc("users_${model.id}")
          .set({
        ...model.toJson(),
        "updateAt": DateTime.now(),
      });
    } catch (e) {
      debugPrint("====> Error update new user: $e");
    }
  }
}
