import 'package:cloud_firestore/cloud_firestore.dart';

class CurrencyModel {
  final String id;
  final String name;
  final double value;
  final bool enable;

  // Constructor với giá trị mặc định
  CurrencyModel({
    this.id = '',
    this.name = 'VND',
    this.value = 1.0,
    this.enable = true,
  });

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  CurrencyModel copyWith({
    String? id,
    String? name,
    double? value,
    bool? enable,
  }) {
    return CurrencyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'VND',
      value: (json['value'] ?? 1.0).toDouble(),
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory CurrencyModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return CurrencyModel();
    }

    return CurrencyModel(
      id: data['id'] ?? snapshot.id,
      name: data['name'] ?? 'VND',
      value: (data['value'] ?? 1.0).toDouble(),
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'CurrencyModel(id: $id, name: $name, value: $value, enable: $enable)';
  }
}

