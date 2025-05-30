import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/group_detail_main_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/notification_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.noti, required this.group});

  final NotificationModel noti;
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return InkWell(
      onTap: () {
        if(group.id.isEmpty) return;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                GroupDetailMainView(group: group)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: noti.notiTo.contains(mC.user.id) ? ColorConfig.primary5 : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: ColorConfig.border))),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (group.avatar.isNotEmpty)
              AvatarItem(group.avatar, size: Resizable.size(context, 24)),
            if (group.avatar.isEmpty)
              Image.asset('assets/images/demo_group.png',
                  height: Resizable.size(context, 24)),
            const ZSpace(w: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConfig.textColor6)),
                  const ZSpace(h: 5),
                  Text(noti.description,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorConfig.textColor))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
