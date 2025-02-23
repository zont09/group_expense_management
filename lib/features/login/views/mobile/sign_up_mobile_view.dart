import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/bloc/sign_up_cubit.dart';
import 'package:group_expense_management/features/login/widgets/gradient_text.dart';
import 'package:group_expense_management/features/login/widgets/password_textfield.dart';
import 'package:group_expense_management/features/login/widgets/username_textfield.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class SignUpMobileView extends StatelessWidget {
  const SignUpMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider(
        create: (context) => SignUpCubit(),
        child: BlocBuilder<SignUpCubit, int>(
          builder: (c, s) {
            var cubit = BlocProvider.of<SignUpCubit>(c);
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              padding:
                  EdgeInsets.symmetric(horizontal: Resizable.size(context, 20)),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientText(
                      AppText.textSignUp.text.toUpperCase(),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF74CEF7), Color(0xFF43EDDE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      style: TextStyle(
                          fontSize: Resizable.font(context, 40),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: Resizable.size(context, 20)),
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
                    SizedBox(height: Resizable.size(context, 3)),
                    if(cubit.errorUsername == 1)
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
                    if(cubit.errorUsername == 2)
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
                        controller: cubit.conPassword),
                    if(cubit.errorPassword == 1)
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
                    SizedBox(height: Resizable.size(context, 10)),
                    PasswordTextField(
                        hintText: AppText.textHintReEnterPassword.text,
                        icon: Icons.lock_outline,
                        controller: cubit.conRePassword),
                    if(cubit.errorRePassword == 1)
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
                    if(cubit.errorRePassword == 2)
                    Padding(
                      padding: EdgeInsets.only(left: Resizable.size(context, 12)),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(AppText.textRePasswordNotMatch.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 14),
                                fontWeight: FontWeight.w300,
                                color: ColorConfig.error)),
                      ),
                    ),
                    SizedBox(height: Resizable.size(context, 20)),
                    ZButton(
                        title: AppText.textSignUp.text,
                        onPressed: () {
                          cubit.checkError();
                        },
                        paddingHor: 20,
                        sizeTitle: 16,
                        fontWeight: FontWeight.w600,
                        colorBackground: ColorConfig.primary2,
                        isShadow: true),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
