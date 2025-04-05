import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: group.avatar.isEmpty ? ColorConfig.primary2 : null,
              backgroundImage: group.avatar.isNotEmpty
                  ? NetworkImage(group.avatar)
                  : null,
              child: group.avatar.isEmpty
                  ? Text(group.name.substring(0, 1).toUpperCase(),  style: TextStyle(
                  fontSize: Resizable.font(context, 18),
                  fontWeight: FontWeight.w600,
                  color: Colors.white))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  Text(
                    '${group.members.length} thành viên',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
