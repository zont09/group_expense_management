import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final List<String> wallets;
  final List<String> groups;
  final bool enable;

  // Constructor với giá trị mặc định
  UserModel({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.avatar = '',
    this.wallets = const [],
    this.groups = const [],
    this.enable = true,
  });

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    List<String>? wallets,
    List<String>? groups,
    bool? enable,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      wallets: wallets ?? List.from(this.wallets),
      groups: groups ?? List.from(this.groups),
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'wallets': wallets,
      'groups': groups,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      wallets: List<String>.from(json['wallets'] ?? []),
      groups: List<String>.from(json['groups'] ?? []),
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return UserModel();
    }

    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? '',
      wallets: List<String>.from(data['wallets'] ?? []),
      groups: List<String>.from(data['groups'] ?? []),
      enable: data['enable'] ?? true,
    );
  }

  int roleInGroup = 0;
  // 0: owner
  // 1: manager
  // 2: member

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, wallets: $wallets, groups: $groups, enable: $enable)';
  }
}
