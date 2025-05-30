import 'package:group_expense_management/models/notification_model.dart';
import 'package:group_expense_management/repository/notification_repository.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static NotificationService instance = NotificationService._privateConstructor();

  final NotificationRepository _notificationRepository = NotificationRepository.instance;

  Future<List<NotificationModel>> getAllNotificationForUser(String uid) async {
    final response = await _notificationRepository.getAllNotificationForUser(uid);
    return response;
  }

  Future<NotificationModel?> getNotificationById(String id) async {
    final response = await _notificationRepository.getNotificationById(id);
    return response;
  }

  Future<void> addNotification(NotificationModel model) async {
    await _notificationRepository.addNotification(model);
  }

  Future<void> updateNotification(NotificationModel model) async {
    await _notificationRepository.updateNotification(model);
  }
}
