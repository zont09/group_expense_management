import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetModel {
  final String id;
  final DateTime date;
  final List<String> detail;
  final String group;
  final bool enable;

  // Constructor với giá trị mặc định
  BudgetModel({
    this.id = '',
    DateTime? date,
    this.detail = const [],
    this.group = '',
    this.enable = true,
  }) : this.date = date ?? DateTime.now();

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  BudgetModel copyWith({
    String? id,
    DateTime? date,
    List<String>? detail,
    String? group,
    bool? enable,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      date: date ?? this.date,
      detail: detail ?? List.from(this.detail),
      group: group ?? this.group,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'detail': detail,
      'group': group,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      detail: List<String>.from(json['detail'] ?? []),
      group: json['group'] ?? '',
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory BudgetModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return BudgetModel();
    }

    return BudgetModel(
      id: data['id'] ?? snapshot.id,
      date: data['date'] != null
          ? (data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.parse(data['date']))
          : null,
      detail: List<String>.from(data['detail'] ?? []),
      group: data['group'] ?? '',
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'BudgetModel(id: $id, date: $date, detail: $detail, group: $group, enable: $enable)';
  }
}

