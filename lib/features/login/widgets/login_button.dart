import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/bloc/login_cubit.dart';
import 'package:group_expense_management/features/overview/views/overview_main_view.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.cubit,
  });

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ZButton(
        title: AppText.textLogin.text,
        onPressed: () async {
          final isError = await cubit.checkError();
          if (isError) return;
          if (context.mounted) {
            DialogUtils.showLoadingDialog(context);
          }

          String loginStatus = "";

          if (context.mounted) {
            loginStatus = await cubit.signInWithEmailAndPassword(
                cubit.conUsername.text, cubit.conPassword.text, context);
          }

          if (context.mounted) {
            Navigator.of(context).pop();
          }

          if (loginStatus == "success" && context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OverviewMainView(),
              ),
            );
            return;
          }

          if (loginStatus != "success" && context.mounted) {
            DialogUtils.showResultDialog(
                context, AppText.textLoginFail.text, loginStatus);
            return;
          }
        },
        paddingHor: 20,
        sizeTitle: 16,
        fontWeight: FontWeight.w600,
        colorBackground: ColorConfig.primary2,
        isShadow: true);
  }
}