import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/notification/widgets/notification_card.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/notification_model.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen(
      {super.key, required this.notis, required this.mapGroup});

  final List<NotificationModel> notis;
  final Map<String, GroupModel> mapGroup;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(children: [
        Container(
          width: double.infinity,
          alignment: Alignment.bottomLeft,
          height: 100,
          decoration: const BoxDecoration(
              color: Colors.white, boxShadow: const [ColorConfig.boxShadow]),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.chevron_left,
                    size: 24, color: ColorConfig.textColor),
              ),
              const ZSpace(w: 12),
              Text("Thông báo",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor))
            ],
          ),
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Column(
            children: [
              ...notis.map((e) => Column(
                    children: [
                      NotificationCard(
                          noti: e,
                          group: mapGroup[e.group] ??
                              GroupModel(name: 'Không xác định')),
                    ],
                  ))
            ],
          ),
        )))
      ]),
    );
  }
}
