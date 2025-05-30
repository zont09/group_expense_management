import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final DateTime date;
  final List<String> toUser;
  final String description;
  final String group;
  final bool enable;
  final String userCreated;
  final List<String> notiTo;

  // Constructor với giá trị mặc định
  NotificationModel({
    this.id = '',
    DateTime? date,
    this.toUser = const [],
    this.description = '',
    this.group = '',
    this.enable = true,
    this.userCreated = '',
    this.notiTo = const [],
  }) : this.date = date ?? DateTime.now();

  // Phương thức copyWith
  NotificationModel copyWith({
    String? id,
    DateTime? date,
    List<String>? toUser,
    String? description,
    String? group,
    bool? enable,
    String? userCreated,
    List<String>? notiTo,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      date: date ?? this.date,
      toUser: toUser ?? List.from(this.toUser),
      description: description ?? this.description,
      group: group ?? this.group,
      enable: enable ?? this.enable,
      userCreated: userCreated ?? this.userCreated,
      notiTo: notiTo ?? List.from(this.notiTo),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'toUser': toUser,
      'description': description,
      'group': group,
      'enable': enable,
      'userCreated': userCreated,
      'notiTo': notiTo,
    };
  }

  // Tạo từ JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      toUser: List<String>.from(json['toUser'] ?? []),
      description: json['description'] ?? '',
      group: json['group'] ?? '',
      enable: json['enable'] ?? true,
      userCreated: json['userCreated'] ?? '',
      notiTo: List<String>.from(json['notiTo'] ?? []),
    );
  }

  // Tạo từ Firestore snapshot
  factory NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return NotificationModel();
    }

    return NotificationModel(
      id: data['id'] ?? snapshot.id,
      date: data['date'] != null
          ? (data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.parse(data['date']))
          : null,
      toUser: List<String>.from(data['toUser'] ?? []),
      description: data['description'] ?? '',
      group: data['group'] ?? '',
      enable: data['enable'] ?? true,
      userCreated: data['userCreated'] ?? '',
      notiTo: List<String>.from(data['notiTo'] ?? []),
    );
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, date: $date, toUser: $toUser, description: $description, enable: $enable, userCreated: $userCreated, notiTo: $notiTo)';
  }
}
