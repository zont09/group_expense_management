import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class SignInWithGgButton extends StatelessWidget {
  const SignInWithGgButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(229),
          border: Border.all(width: 1, color: ColorConfig.border6),
          color: Colors.white,
          boxShadow: const [ColorConfig.boxShadow]),
      padding: EdgeInsets.symmetric(vertical: Resizable.size(context, 8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo_gg.png',
              height: Resizable.size(context, 25)),
          SizedBox(width: Resizable.size(context, 6)),
          Text(AppText.textSignInWithGG.text,
              style: TextStyle(
                  fontSize: Resizable.font(context, 16),
                  fontWeight: FontWeight.w500,
                  color: ColorConfig.textColor)),
        ],
      ),
    );
  }
}
