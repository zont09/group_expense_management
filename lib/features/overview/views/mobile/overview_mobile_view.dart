import 'package:flutter/material.dart';
import 'package:group_expense_management/features/profile/views/mobile/profile_mobile_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class OverviewMobileView extends StatelessWidget {
  const OverviewMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: Resizable.size(context, 150),
          padding: EdgeInsets.symmetric(horizontal: Resizable.size(context, 20))
              .copyWith(top: Resizable.size(context, 30)),
          decoration: BoxDecoration(
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
              Text(
                MainCubit.fromContext(context).user.name + "adqsa",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ProfileMobileView(
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
        )
      ],
    ));
  }
}
