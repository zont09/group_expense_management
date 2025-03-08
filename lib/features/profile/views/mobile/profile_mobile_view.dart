import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/login_main_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/services/auth_service.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class ProfileMobileView extends StatelessWidget {
  const ProfileMobileView({super.key, required this.mainCubit});

  final MainCubit mainCubit;

  @override
  Widget build(BuildContext context) {
    final user = mainCubit.user;
    return Material(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.size(context, 24)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Resizable.size(context, 8)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_left,
                                    color: ColorConfig.textColor6,
                                    size: Resizable.size(context, 24)),
                                SizedBox(width: Resizable.size(context, 6)),
                                Text(
                                  AppText.textProfile.text,
                                  style: TextStyle(
                                      fontSize: Resizable.size(context, 20),
                                      color: ColorConfig.textColor6,
                                      fontWeight: FontWeight.w500,
                                      shadows: const [ColorConfig.textShadow],
                                      height: 1.1),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Resizable.size(context, 18)),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [ColorConfig.boxShadow2]),
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.size(context, 12),
                                vertical: Resizable.size(context, 6)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AvatarItem(user.avatar,
                                    size: Resizable.size(context, 35)),
                                SizedBox(width: Resizable.size(context, 9)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                          fontSize: Resizable.size(context, 16),
                                          color: ColorConfig.textColor,
                                          fontWeight: FontWeight.w500,
                                          height: 1.1),
                                    ),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                          fontSize: Resizable.size(context, 14),
                                          color: ColorConfig.primary2,
                                          fontWeight: FontWeight.w400,
                                          height: 1.1),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Resizable.size(context, 30)),
                    ZButton(
                        maxWidth: double.infinity,
                        radius: 8,
                        title: AppText.btnSignOut.text,
                        onPressed: () {
                          AuthService().signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginMainView()),
                            // Màn hình mới bạn muốn push
                            (Route<dynamic> route) =>
                                false, // Điều kiện để xóa hết stack
                          );
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
