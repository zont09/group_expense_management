import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetDetailModel {
  final String id;
  final String category;
  final String group;
  final double current;
  final double amount;
  final String currency;
  final String budget;
  final DateTime date;
  final bool enable;

  // Constructor với giá trị mặc định
  BudgetDetailModel({
    this.id = '',
    this.category = '',
    this.group = '',
    this.current = 0.0,
    this.amount = 0.0,
    this.currency = 'VND',
    this.budget = '',
    DateTime? date,
    this.enable = true,
  }): date = date ?? DateTime(2004, 9);

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  BudgetDetailModel copyWith({
    String? id,
    String? category,
    String? group,
    double? current,
    double? amount,
    String? currency,
    String? budget,
    DateTime? date,
    bool? enable,
  }) {
    return BudgetDetailModel(
      id: id ?? this.id,
      category: category ?? this.category,
      group: group ?? this.group,
      current: current ?? this.current,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      budget: budget ?? this.budget,
      date: date ?? this.date,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'group': group,
      'current': current,
      'amount': amount,
      'currency': currency,
      'budget': budget,
      'date': Timestamp.fromDate(date), // Lưu DateTime dưới dạng Timestamp
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory BudgetDetailModel.fromJson(Map<String, dynamic> json) {
    return BudgetDetailModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      group: json['group'] ?? '',
      current: (json['current'] ?? 0.0).toDouble(),
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'VND',
      budget: json['budget'] ?? '',
      date: (json['date'] as Timestamp?)?.toDate() ?? DateTime(2023, 1),
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
      current: (data['current'] ?? 0.0).toDouble(),
      amount: (data['amount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'VND',
      budget: data['budget'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime(2023, 1),
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'BudgetDetailModel(id: $id, category: $category, group: $group, amount: $amount, currency: $currency, budget: $budget, date: $date, enable: $enable)';
  }
}