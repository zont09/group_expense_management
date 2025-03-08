import 'package:flutter/material.dart';
import 'package:group_expense_management/features/profile/views/mobile/profile_mobile_view.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/widgets/responsive_layout.dart';

class OverviewMainView extends StatelessWidget {
  const OverviewMainView({super.key, required this.mainCubit});

  final MainCubit mainCubit;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobile: ProfileMobileView(mainCubit: mainCubit),
        tablet: ProfileMobileView(mainCubit: mainCubit),
        desktop: ProfileMobileView(mainCubit: mainCubit));
  }
}
