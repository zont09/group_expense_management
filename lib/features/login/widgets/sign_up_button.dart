import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/bloc/sign_up_cubit.dart';
import 'package:group_expense_management/services/auth_service.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';


class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
    required this.cubit,
  });

  final SignUpCubit cubit;

  @override
  Widget build(BuildContext context) {
    return ZButton(
        title: AppText.textSignUp.text,
        onPressed: () async {
          final isError = await cubit.checkError();
          debugPrint("====> Check error: ${isError}");
          if (isError) return;
          if (context.mounted) {
            DialogUtils.showLoadingDialog(context);
          }

          final res = await AuthService().signUpAndVerifyEmail(
              cubit.conUsername.text, cubit.conPassword.text);

          if (context.mounted) {
            Navigator.of(context).pop();
          }

          if (res == 0 && context.mounted) {
            await DialogUtils.showResultDialog(
                context,
                AppText.textSignUpSuccess.text,
                AppText.textCheckVerifyEmail.text);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }

          if (res == 1 && context.mounted) {
            await DialogUtils.showResultDialog(
                context,
                AppText.textSignUpFail.text,
                AppText.textEmailAlreadyInUse.text);
          }

          if (res == 2 && context.mounted) {
            await DialogUtils.showResultDialog(
                context,
                AppText.textSignUpFail.text,
                AppText.textHasErrorAndTryAgain.text);
          }
        },
        paddingHor: 20,
        sizeTitle: 16,
        fontWeight: FontWeight.w600,
        colorBackground: ColorConfig.primary2,
        isShadow: true);
  }
}