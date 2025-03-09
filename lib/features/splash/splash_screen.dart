import 'package:flutter/material.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF74CEF7), // #74CEF7
            Color(0xFF43EDDE), // #43EDDE
          ],
        ),
      ),
      child: Center(
          child: Image.asset('assets/images/logo_white.png',
              height: Resizable.size(context, 120))),
    );
  }
}
