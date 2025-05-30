import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:group_expense_management/models/notification_model.dart';

class NotificationRepository {
  NotificationRepository._privateConstructor();

  static NotificationRepository instance =
  NotificationRepository._privateConstructor();

  FirebaseFirestore get fireStore {
    return FirebaseFirestore.instance;
  }

  FirebaseStorage get fireStorage {
    return FirebaseStorage.instance;
  }

  Future<List<NotificationModel>> getAllNotificationForUser(String uid) async {
    try {
      final snapshot = await fireStore
          .collection("notifications")
          .where('toUser', arrayContains: uid)
          .where('enable', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((e) => NotificationModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      debugPrint("====> Error get all notification by id user: $e");
      return [];
    }
  }

  Future<NotificationModel?> getNotificationById(String id) async {
    try {
      final snapshot = await fireStore
          .collection("notifications")
          .where('enable', isEqualTo: true)
          .where('id', isEqualTo: id)
          .get();
      return snapshot.docs
          .map((e) => NotificationModel.fromSnapshot(e))
          .firstOrNull;
    } catch (e) {
      debugPrint("====> Error get wallet by id: $e");
      return null;
    }
  }

  Future<void> addNotification(NotificationModel model) async {
    try {
      await fireStore
          .collection('notifications')
          .doc("categories_${model.id}")
          .set(model.toJson());
    } catch (e) {
      debugPrint("====> Error add new wallet: $e");
    }
  }

  Future<void> updateNotification(NotificationModel model) async {
    try {
      await fireStore
          .collection('notifications')
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
