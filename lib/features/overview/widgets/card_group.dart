import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';

class CardGroup extends StatelessWidget {
  const CardGroup({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    final mapUser = MainCubit.fromContext(context).mapUser;
    final owner = mapUser[group.owner] ?? UserModel();
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [ColorConfig.boxShadow2]),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.size(context, 12),
          vertical: Resizable.size(context, 12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (group.avatar.isNotEmpty)
                AvatarItem(group.avatar, size: Resizable.size(context, 24)),
              if (group.avatar.isEmpty)
                Image.asset('assets/images/demo_group.png',
                    height: Resizable.size(context, 24)),
              SizedBox(width: Resizable.size(context, 8)),
              Expanded(
                  child: Text(group.name,
                      style: TextStyle(
                          fontSize: Resizable.size(context, 16),
                          fontWeight: FontWeight.w500,
                          color: ColorConfig.textColor,
                          overflow: TextOverflow.ellipsis))),
            ],
          ),
          SizedBox(height: Resizable.size(context, 2)),
          Row(
            children: [
              Text("${AppText.textOwner.text}: ",
                  style: TextStyle(
                      fontSize: Resizable.size(context, 16),
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.textColor6,
                      overflow: TextOverflow.ellipsis)),
              AvatarItem(owner.avatar, size: Resizable.size(context, 24)),
              SizedBox(width: Resizable.size(context, 5)),
              Expanded(
                  child: Text(owner.name,
                      style: TextStyle(
                          fontSize: Resizable.size(context, 16),
                          fontWeight: FontWeight.w500,
                          color: ColorConfig.textColor6,
                          overflow: TextOverflow.ellipsis)))
            ],
          ),
          SizedBox(height: Resizable.size(context, 2)),
          Text("${AppText.textMembers.text}: ${group.members.length + group.managers.length + 1}",
              style: TextStyle(
                  fontSize: Resizable.size(context, 16),
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.textColor6,
                  overflow: TextOverflow.ellipsis)),
          SizedBox(height: Resizable.size(context, 2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.circle,
                  size: Resizable.size(context, 12),
                  color:
                      group.enable ? ColorConfig.active : ColorConfig.inactive),
              SizedBox(width: Resizable.size(context, 5)),
              Text(
                  group.enable
                      ? AppText.textActive.text
                      : AppText.textInactive.text,
                  style: TextStyle(
                      fontSize: Resizable.size(context, 16),
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.textColor6,
                      overflow: TextOverflow.ellipsis)),
            ],
          )
        ],
      ),
    );
  }
}
