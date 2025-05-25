import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/bloc/login_cubit.dart';
import 'package:group_expense_management/features/login/views/mobile/forgot_password_popup.dart';
import 'package:group_expense_management/features/login/widgets/password_textfield.dart';
import 'package:group_expense_management/features/login/widgets/username_textfield.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class LoginTextFieldView extends StatelessWidget {
  const LoginTextFieldView({
    super.key,
    required this.cubit,
  });

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UsernameTextField(
          hintText: AppText.textHintUsername.text,
          icon: Icons.account_circle_outlined,
          controller: cubit.conUsername,
          isError: cubit.errorUsername > 0,
          changeError: (v) {
            cubit.errorUsername = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorUsername > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorUsername == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        if (cubit.errorUsername == 2)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textInvalidEmail.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        SizedBox(height: Resizable.size(context, 10)),
        PasswordTextField(
          hintText: AppText.textHintPassword.text,
          icon: Icons.lock_outline,
          controller: cubit.conPassword,
          isError: cubit.errorPassword > 0,
          changeError: (v) {
            cubit.errorPassword = v;
            cubit.EMIT();
          },
        ),
        if (cubit.errorPassword > 0)
          SizedBox(height: Resizable.size(context, 3)),
        if (cubit.errorPassword == 1)
          Padding(
            padding: EdgeInsets.only(left: Resizable.size(context, 12)),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(AppText.textPleaseDoNotLeaveItBlank.text,
                  style: TextStyle(
                      fontSize: Resizable.font(context, 14),
                      fontWeight: FontWeight.w300,
                      color: ColorConfig.error)),
            ),
          ),
        SizedBox(height: Resizable.size(context, 5)),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () async {
              final status = await DialogUtils.showAlertDialog(context,
                  child: ForgotPasswordPopup());
              if (status == 0) {
                DialogUtils.showResultDialog(
                    context, AppText.titleResetPasswordSuccess.text,
                    AppText.textResetPasswordSuccess.text);
              }
              if (status == 1) {
                DialogUtils.showResultDialog(
                    context, AppText.textHasError.text,
                    AppText.textEmailNoSignUp.text);
              }
              if (status == 2) {
                DialogUtils.showResultDialog(
                    context, AppText.textHasError.text,
                    AppText.textHasErrorAndTryAgain.text);
              }
            },
            child: Text(AppText.textForgotPassword.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w500,
                    color: ColorConfig.primary2)),
          ),
        ),
      ],
    );
  }
}
