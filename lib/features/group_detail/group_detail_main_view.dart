import 'package:flutter/material.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/group_detail_mobile_view.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/widgets/responsive_layout.dart';

class GroupDetailMainView extends StatelessWidget {
  const GroupDetailMainView({super.key, required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobile: GroupDetailMobileView(group: group),
        tablet: GroupDetailMobileView(group: group),
        desktop: GroupDetailMobileView(group: group));
  }
}
