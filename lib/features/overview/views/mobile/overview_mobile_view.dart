import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/group_detail_main_view.dart';
import 'package:group_expense_management/features/overview/widgets/card_group.dart';
import 'package:group_expense_management/features/profile/views/mobile/profile_mobile_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class OverviewMobileView extends StatelessWidget {
  const OverviewMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final GroupModel group = GroupModel(
        name: "Du lịch Théi Lennn",
        owner: "oZbEeh0GJyk7I8otkySf",
        members: ["a", "b", "c"]);
    return Material(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: Resizable.size(context, 150),
              padding: EdgeInsets.symmetric(
                  horizontal: Resizable.size(context, 24))
                  .copyWith(top: Resizable.size(context, 30)),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF74CEF7), // #74CEF7
                    Color(0xFF43EDDE), // #43EDDE
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24), // Bo góc trái dưới
                  bottomRight: Radius.circular(24), // Bo góc phải dưới
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(MainCubit
                      .fromContext(context)
                      .user
                      .name,
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black)),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              ProfileMobileView(
                                mainCubit: MainCubit.fromContext(context),
                              )));
                    },
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: Resizable.size(context, 30),
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.size(context, 24),
                        vertical: Resizable.size(context, 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppText.titleYourGroup.text,
                                style: TextStyle(
                                    fontSize: Resizable.font(context, 20),
                                    fontWeight: FontWeight.w500,
                                    color: ColorConfig.textColor6,
                                    shadows: const [ColorConfig.textShadow])),
                            SizedBox(width: Resizable.size(context, 9)),
                            Container(
                              height: Resizable.size(context, 20),
                              width: Resizable.size(context, 20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorConfig.primary2,
                                  boxShadow: const [ColorConfig.boxShadow2]),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: Resizable.size(context, 16),
                                  weight: 900,
                                ),
                              ),
                            ),
                            SizedBox(height: Resizable.size(context, 12)),
                          ],
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) =>
                                      GroupDetailMainView(group: group)));
                            },
                            child: CardGroup(group: group))
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }
}
