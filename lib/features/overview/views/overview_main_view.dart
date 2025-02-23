import 'package:flutter/material.dart';
import 'package:group_expense_management/features/overview/views/mobile/overview_mobile_view.dart';
import 'package:group_expense_management/widgets/responsive_layout.dart';

class OverviewMainView extends StatelessWidget {
  const OverviewMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
        mobile: OverviewMobileView(),
        tablet: OverviewMobileView(),
        desktop: OverviewMobileView());
  }
}
