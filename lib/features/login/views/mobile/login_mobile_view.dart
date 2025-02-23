import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/bloc/login_cubit.dart';
import 'package:group_expense_management/features/login/views/mobile/sign_up_mobile_view.dart';
import 'package:group_expense_management/features/login/widgets/password_textfield.dart';
import 'package:group_expense_management/features/login/widgets/sign_in_with_gg_button.dart';
import 'package:group_expense_management/features/login/widgets/username_textfield.dart';
import 'package:group_expense_management/features/overview/views/overview_main_view.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class LoginMobileView extends StatelessWidget {
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocBuilder<LoginCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<LoginCubit>(c);
          return Material(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: Resizable.size(context, 20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png',
                        height: Resizable.size(context, 120)),
                    SizedBox(height: Resizable.size(context, 40)),
                    // GradientText(
                    //   AppText.textLogin.text.toUpperCase(),
                    //   gradient: const LinearGradient(
                    //     colors: [Color(0xFF74CEF7), Color(0xFF43EDDE)],
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //   ),
                    //   style: TextStyle(
                    //       fontSize: Resizable.font(context, 30),
                    //       fontWeight: FontWeight.bold),
                    // ),
                    // SizedBox(height: Resizable.size(context, 15)),
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
                        padding:
                        EdgeInsets.only(left: Resizable.size(context, 12)),
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
                        padding:
                        EdgeInsets.only(left: Resizable.size(context, 12)),
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
                        padding:
                        EdgeInsets.only(left: Resizable.size(context, 12)),
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
                        onTap: () {},
                        child: Text(AppText.textForgotPassword.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 14),
                                fontWeight: FontWeight.w500,
                                color: ColorConfig.primary2)),
                      ),
                    ),
                    SizedBox(height: Resizable.size(context, 15)),
                    ZButton(
                        title: AppText.textLogin.text,
                        onPressed: () async {
                          final isError = await cubit.checkError();
                          if (isError) return;
                          if (context.mounted) {
                            DialogUtils.showLoadingDialog(context);
                          }

                          String loginStatus = "";

                          if (context.mounted) {
                            loginStatus =
                            await cubit.signInWithEmailAndPassword(
                                cubit.conUsername.text,
                                cubit.conPassword.text,
                                context);
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
                                context, AppText.textLoginFail.text,
                                loginStatus);
                            return;
                          }
                        },
                        paddingHor: 20,
                        sizeTitle: 16,
                        fontWeight: FontWeight.w600,
                        colorBackground: ColorConfig.primary2,
                        isShadow: true),
                    SizedBox(height: Resizable.size(context, 12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppText.textNoAccount.text,
                            style: TextStyle(
                                fontSize: Resizable.font(context, 14),
                                fontWeight: FontWeight.w500,
                                color: ColorConfig.textColor7)),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignUpMobileView()));
                          },
                          child: Text(AppText.textCreateAccountNow.text,
                              style: TextStyle(
                                  fontSize: Resizable.font(context, 14),
                                  fontWeight: FontWeight.w500,
                                  color: ColorConfig.primary2)),
                        ),
                      ],
                    ),
                    SizedBox(height: Resizable.size(context, 80)),
                    SignInWithGgButton(
                      onLogin: () async {
                        DialogUtils.showLoadingDialog(context);
                        final success = await cubit.onSignInWithGoogle(context);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          if (success) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => OverviewMainView(),
                              ),
                            );
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
