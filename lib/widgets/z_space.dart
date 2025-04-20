import 'package:flutter/material.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class ZSpace extends StatelessWidget {
  const ZSpace({super.key, this.h = 0, this.w = 0});

  final double h;
  final double w;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Resizable.size(context, h), width: Resizable.size(context, w));
  }
}
