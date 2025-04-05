import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetDetailModel {
  final String id;
  final String category;
  final String group;
  final double amount;
  final String currency;
  final bool enable;

  // Constructor với giá trị mặc định
  BudgetDetailModel({
    this.id = '',
    this.category = '',
    this.group = '',
    this.amount = 0.0,
    this.currency = 'VND',
    this.enable = true,
  });

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  BudgetDetailModel copyWith({
    String? id,
    String? category,
    String? group,
    double? amount,
    String? currency,
    bool? enable,
  }) {
    return BudgetDetailModel(
      id: id ?? this.id,
      category: category ?? this.category,
      group: group ?? this.group,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'group': group,
      'amount': amount,
      'currency': currency,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory BudgetDetailModel.fromJson(Map<String, dynamic> json) {
    return BudgetDetailModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      group: json['group'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'VND',
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory BudgetDetailModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return BudgetDetailModel();
    }

    return BudgetDetailModel(
      id: data['id'] ?? snapshot.id,
      category: data['category'] ?? '',
      group: data['group'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'VND',
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'BudgetDetailModel(id: $id, category: $category, group: $group, amount: $amount, currency: $currency, enable: $enable)';
  }
}

