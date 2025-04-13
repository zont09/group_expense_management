import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String avatar;
  final String owner;
  final List<String> members;
  final List<String> admins;
  final List<String> managers;
  final List<String> viewers;
  final bool enable;

  // Constructor với đầy đủ tham số và giá trị mặc định
  GroupModel({
    this.id = '',
    this.name = '',
    this.avatar = '',
    this.owner = '',
    this.members = const [],
    this.admins = const [],
    this.managers = const [],
    this.viewers = const [],
    this.enable = true,
  });

  // Phương thức copyWith để tạo bản sao có chỉnh sửa
  GroupModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? owner,
    List<String>? members,
    List<String>? admins,
    List<String>? managers,
    List<String>? viewers,
    bool? enable,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      owner: owner ?? this.owner,
      members: members ?? List.from(this.members),
      admins: admins ?? List.from(this.admins),
      managers: managers ?? List.from(this.managers),
      viewers: viewers ?? List.from(this.viewers),
      enable: enable ?? this.enable,
    );
  }

  // Chuyển đổi từ object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'owner': owner,
      'members': members,
      'admins': admins,
      'managers': managers,
      'viewers': viewers,
      'enable': enable,
    };
  }

  // Tạo object từ JSON
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      owner: json['owner'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      admins: List<String>.from(json['admins'] ?? []),
      managers: List<String>.from(json['managers'] ?? []),
      viewers: List<String>.from(json['viewers'] ?? []),
      enable: json['enable'] ?? true,
    );
  }

  // Tạo object từ Firestore snapshot
  factory GroupModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return GroupModel();
    }

    return GroupModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      avatar: data['avatar'] ?? '',
      owner: data['owner'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      admins: List<String>.from(data['admins'] ?? []),
      managers: List<String>.from(data['managers'] ?? []),
      viewers: List<String>.from(data['viewers'] ?? []),
      enable: data['enable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name, avatar: $avatar, owner: $owner, members: $members, admins: $admins, managers: $managers, viewers: $viewers, enable: $enable)';
  }
}
