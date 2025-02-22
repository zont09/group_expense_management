import 'package:flutter/material.dart';
import 'package:group_expense_management/features/login/views/mobile/login_mobile_view.dart';
import 'package:group_expense_management/widgets/responsive_layout.dart';

class ChatMainView extends StatelessWidget {
  const ChatMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobile: LoginMobileView(),
        tablet: LoginMobileView(),
        desktop: LoginMobileView());
  }
}
