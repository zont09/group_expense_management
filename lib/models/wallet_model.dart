import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String id;
  final String name;
  final double amount;
  final String note;
  final String currency;
  final String user;
  final String group;
  final bool enable;

  // Constructor với giá trị mặc định
  WalletModel({
    this.id = '',
    this.name = '',
    this.amount = 0.0,
    this.note = '',
    this.currency = '',
    this.user = '',
    this.group = '',
    this.enable = true,
  });

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  WalletModel copyWith({
    String? id,
    String? name,
    double? amount,
    String? note,
    String? currency,
    String? user,
    String? group,
    bool? enable,
  }) {
    return WalletModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      currency: currency ?? this.currency,
      user: user ?? this.user,
      group: group ?? this.group,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'note': note,
      'currency': currency,
      'user': user,
      'group': group,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      note: json['note'] ?? '',
      currency: json['currency'] ?? 'VND',
      user: json['user'] ?? '',
      group: json['group'] ?? '',
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory WalletModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return WalletModel();
    }

    return WalletModel(
      id: data['id'] ?? snapshot.id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      note: data['note'] ?? '',
      currency: data['currency'] ?? 'VND',
      user: data['user'] ?? '',
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'WalletModel(id: $id, name: $name, amount: $amount, note: $note, currency: $currency, user: $user, enable: $enable)';
  }
}

