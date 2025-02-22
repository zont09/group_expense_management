import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class UsernameTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;

  const UsernameTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(229), // Bo góc 8px
        boxShadow: const [ColorConfig.boxShadow],
      ),
      child: TextField(
        controller: controller,
        cursorColor: ColorConfig.primary1,
        style: TextStyle(
            fontSize: Resizable.font(context, 16),
            color: ColorConfig.primary1,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon,
              color: ColorConfig.primary1, size: Resizable.size(context, 20)),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: Resizable.font(context, 16),
              color: ColorConfig.hintText,
              fontWeight: FontWeight.w400),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(229),
            borderSide: BorderSide(
                color: ColorConfig.border6,
                width: Resizable.size(context, 1)), // Viền khi focus
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(229),
            borderSide: BorderSide(
                color: ColorConfig.border6,
                width: Resizable.size(context, 1)), // Viền khi focus
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(229),
            borderSide: BorderSide(
                color: ColorConfig.primary1, width: 2), // Viền khi focus
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
              vertical: Resizable.size(context, 6),
              horizontal: Resizable.size(context, 12)),
        ),
      ),
    );
  }
}
