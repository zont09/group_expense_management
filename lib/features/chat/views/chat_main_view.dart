import 'package:flutter/material.dart';
import 'package:group_expense_management/features/chat/views/desktop/chat_screen_desktop.dart';
import 'package:group_expense_management/features/chat/views/mobile/chat_screen_mobile.dart';
import 'package:group_expense_management/features/chat/views/tablet/chat_screen_tablet.dart';
import 'package:group_expense_management/widgets/responsive_layout.dart';

class ChatMainView extends StatelessWidget {
  const ChatMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobile: ChatScreenMobile(),
        tablet: ChatScreenTablet(),
        desktop: ChatScreenDesktop());
  }
}
