import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/member_cubit.dart';
import 'package:group_expense_management/features/group_detail/widgets/member_card.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class MemberMainView extends StatelessWidget {
  const MemberMainView({super.key, required this.cubitGD});

  final GroupDetailCubit cubitGD;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return BlocProvider(
      create: (context) => MemberCubit(cubitGD.group, mC.user, mC)..initData(),
      child: BlocBuilder<MemberCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<MemberCubit>(c);
          return Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Danh sách thành viên",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: ColorConfig.textColor6,
                            shadows: const [ColorConfig.textShadow]),
                      ),
                      const ZSpace(h: 12),
                      ...cubit.listMember.map((e) => Column(
                        children: [
                          MemberCard(member: e),
                          const ZSpace(h: 12)
                        ],
                      ))
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
