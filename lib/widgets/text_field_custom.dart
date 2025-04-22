import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_expense_management/configs/color_configs.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom(
      {super.key,
        required this.title,
        required this.controller,
        this.isNumberOnly = false,
        this.canEdit = true});

  final String title;
  final bool isNumberOnly;
  final TextEditingController controller;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: canEdit,
      keyboardType: isNumberOnly ? TextInputType.number : null,
      inputFormatters: [
        if (isNumberOnly) FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorConfig.hintText)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      controller: controller,
    );
  }
}