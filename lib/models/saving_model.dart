import 'package:cloud_firestore/cloud_firestore.dart';

class SavingModel {
  final String id;
  final String title;
  final String description;
  final double targetAmount;
  final DateTime targetDate;
  final double currentAmount;
  final String currency;
  final List<String> details;
  final String group;
  final bool enable;

  // Constructor với giá trị mặc định
  SavingModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.targetAmount = 0.0,
    DateTime? targetDate,
    this.currentAmount = 0.0,
    this.currency = 'VND',
    this.details = const [],
    this.group = '',
    this.enable = true,
  }) : this.targetDate = targetDate ?? DateTime.now().add(const Duration(days: 30));

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  SavingModel copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    DateTime? targetDate,
    double? currentAmount,
    String? currency,
    List<String>? details,
    String? group,
    bool? enable,
  }) {
    return SavingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      currentAmount: currentAmount ?? this.currentAmount,
      currency: currency ?? this.currency,
      details: details ?? List.from(this.details),
      group: group ?? this.group,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'targetDate': targetDate.toIso8601String(),
      'currentAmount': currentAmount,
      'currency': currency,
      'details': details,
      'group': group,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      targetAmount: (json['targetAmount'] ?? 0.0).toDouble(),
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      currentAmount: (json['currentAmount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'VND',
      details: List<String>.from(json['details'] ?? []),
      group: json['group'] ?? '',
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory SavingModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return SavingModel();
    }

    return SavingModel(
      id: data['id'] ?? snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0.0).toDouble(),
      targetDate: data['targetDate'] != null
          ? (data['targetDate'] is Timestamp
          ? (data['targetDate'] as Timestamp).toDate()
          : DateTime.parse(data['targetDate']))
          : null,
      currentAmount: (data['currentAmount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'VND',
      details: List<String>.from(data['details'] ?? []),
      group: data['group'] ?? '',
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'SavingModel(id: $id, title: $title, description: $description, targetAmount: $targetAmount, targetDate: $targetDate, currentAmount: $currentAmount, currency: $currency, details: $details, group: $group, enable: $enable)';
  }
}

