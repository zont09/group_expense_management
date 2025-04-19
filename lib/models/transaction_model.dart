import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String wallet;
  final String user;
  final String group;
  final String category;
  final String isRepeat;
  final bool enable;
  final DateTime createAt;
  final DateTime updateAt;

  // Constructor với giá trị mặc định
  TransactionModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.amount = 0,
    DateTime? date,
    this.wallet = '',
    this.user = '',
    this.group = '',
    this.category = '',
    this.isRepeat = 'no',
    this.enable = true,
    DateTime? createAt,
    DateTime? updateAt,
  })  : this.date = date ?? DateTime.now(),
        this.createAt = createAt ?? DateTime.now(),
        this.updateAt = updateAt ?? DateTime.now();

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  TransactionModel copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    DateTime? date,
    String? wallet,
    String? user,
    String? group,
    String? category,
    String? isRepeat,
    bool? enable,
    DateTime? createAt,
    DateTime? updateAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      wallet: wallet ?? this.wallet,
      user: user ?? this.user,
      group: group ?? this.group,
      category: category ?? this.category,
      isRepeat: isRepeat ?? this.isRepeat,
      enable: enable ?? this.enable,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'wallet': wallet,
      'user': user,
      'group': group,
      'category': category,
      'isRepeat': isRepeat,
      'enable': enable,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }

  // Tạo object từ JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: json['amount'] ?? 0,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      wallet: json['wallet'] ?? '',
      user: json['user'] ?? '',
      group: json['group'] ?? '',
      category: json['category'] ?? '',
      isRepeat: json['isRepeat'] ?? 'no',
      enable: json['enable'] ?? true,
      createAt:
          json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
      updateAt:
          json['updateAt'] != null ? DateTime.parse(json['updateAt']) : null,
    );
  }

  // Tạo object từ Firestore snapshot
  factory TransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return TransactionModel();
    }

    return TransactionModel(
      id: data['id'] ?? snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: data['amount'] ?? 0,
      date: data['date'] != null
          ? (data['date'] is Timestamp
              ? (data['date'] as Timestamp).toDate()
              : DateTime.parse(data['date']))
          : null,
      wallet: data['wallet'] ?? '',
      user: data['user'] ?? '',
      group: data['group'] ?? '',
      category: data['category'] ?? '',
      isRepeat: data['isRepeat'] ?? 'no',
      enable: data['enable'] ?? true,
      createAt: data['createAt'] != null
          ? (data['createAt'] is Timestamp
              ? (data['createAt'] as Timestamp).toDate()
              : DateTime.parse(data['createAt']))
          : null,
      updateAt: data['updateAt'] != null
          ? (data['updateAt'] is Timestamp
              ? (data['updateAt'] as Timestamp).toDate()
              : DateTime.parse(data['updateAt']))
          : null,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, description: $description, date: $date, wallet: $wallet, user: $user, group: $group, category: $category, isRepeat: $isRepeat, enable: $enable, createAt: $createAt, updateAt: $updateAt)';
  }
}
