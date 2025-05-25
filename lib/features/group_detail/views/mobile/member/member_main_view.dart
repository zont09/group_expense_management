import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/features/group_detail/bloc/member_cubit.dart';
import 'package:group_expense_management/features/group_detail/widgets/member_card.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class MemberMainView extends StatelessWidget {
  const MemberMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    return BlocBuilder<GroupDetailCubit, int>(
      builder: (cc, ss) {
        var cubitGD = BlocProvider.of<GroupDetailCubit>(cc);
        debugPrint(
            "====> MemberMainView - cubitGD: ${cubitGD.group.members.length}");
        return BlocProvider(
          create: (context) =>
          MemberCubit( mC.user, mC)
            ..initData(cubitGD.group),
          child: BlocBuilder<MemberCubit, int>(
            builder: (c, s) {
              var cubit = BlocProvider.of<MemberCubit>(c);
              return BlocListener<GroupDetailCubit, int>(
                listener: (ccc, sss) {
                  cubit.initData(cubitGD.group);
                },
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                            ...cubit.listMember.map((e) =>
                                Column(
                                  children: [
                                    MemberCard(
                                      member: e,
                                      cubitGD: cubitGD,
                                    ),
                                    const ZSpace(h: 12)
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )),
              );
            },
          ),
        );
      },
    );
  }
}
