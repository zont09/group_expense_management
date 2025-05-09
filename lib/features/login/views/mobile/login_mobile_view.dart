import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/login/bloc/login_cubit.dart';
import 'package:group_expense_management/features/login/views/mobile/login_textfield_view.dart';
import 'package:group_expense_management/features/login/views/mobile/sign_up_mobile_view.dart';
import 'package:group_expense_management/features/login/widgets/login_button.dart';
import 'package:group_expense_management/features/login/widgets/sign_in_with_gg_button.dart';
import 'package:group_expense_management/features/overview/views/overview_main_view.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

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
                    LoginTextFieldView(cubit: cubit),
                    SizedBox(height: Resizable.size(context, 15)),
                    LoginButton(cubit: cubit),
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
