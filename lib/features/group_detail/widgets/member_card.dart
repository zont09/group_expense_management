import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member});

  final UserModel member;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: ColorConfig.border))),
      child: Row(children: [
        AvatarItem(member.avatar, size: 24),
        const ZSpace(w: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.textColor,
                      letterSpacing: -0.41,
                      overflow: TextOverflow.ellipsis)),
              Text(_getMemberRole(member.roleInGroup),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.hintText,
                      letterSpacing: -0.41,
                      overflow: TextOverflow.ellipsis))
            ],
          ),
        ),
        const ZSpace(w: 9),
        const Icon(Icons.more_vert, size: 24, color: ColorConfig.textColor,)
      ]),
    );
  }
  
  _getMemberRole(int role) {
    switch (role) {
      case 0: return "Người tạo";
      case 1: return "Quản lý";
      case 2: return "Thành viên";
      default: return "";
    }
  }
}
