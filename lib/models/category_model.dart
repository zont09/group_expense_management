import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String title;
  final String type;
  final bool enable;

  // Constructor với giá trị mặc định
  CategoryModel({
    this.id = '',
    this.title = '',
    this.type = '',
    this.enable = true,
  });

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  CategoryModel copyWith({
    String? id,
    String? title,
    String? type,
    bool? enable,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return CategoryModel();
    }

    return CategoryModel(
      id: data['id'] ?? snapshot.id,
      title: data['title'] ?? '',
      type: data['type'] ?? '',
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, title: $title, type: $type, enable: $enable)';
  }
}

