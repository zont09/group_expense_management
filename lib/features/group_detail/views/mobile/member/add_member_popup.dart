import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_member_cubit.dart';
import 'package:group_expense_management/features/group_detail/views/mobile/popup/add_group_popup.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/toast_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class AddMemberPopup extends StatelessWidget {
  const AddMemberPopup({super.key, required this.group, required this.onUpdateGroup});

  final GroupModel group;
  final Function(GroupModel) onUpdateGroup;

  @override
  Widget build(BuildContext context) {
    final mC = MainCubit.fromContext(context);
    final controller = TextEditingController();
    return BlocProvider(
      create: (context) => AddMemberCubit(group),
      child: BlocBuilder<AddMemberCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<AddMemberCubit>(c);
          return IntrinsicHeight(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: SearchField(controller: controller)),
                      SizedBox(width: 9),
                      ZButton(
                        title: "Mời",
                        radius: 4,
                        colorBackground: ColorConfig.primary1,
                        colorBorder: ColorConfig.primary1,
                        onPressed: () async {
                          DialogUtils.showLoadingDialog(context);
            
                          final user = mC.allUsers
                              .where((e) => e.email == controller.text)
                              .firstOrNull;
                          if (user == null) {
                            ToastUtils.showBottomToast(
                                context, "Người dùng không tồn tại");
                          } else {
                            cubit.addMember(user);
                            controller.text = '';
                          }
            
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: cubit.listMember.map((e) {
                      return Chip(
                        label: Text(e.name),
                        onDeleted: () {
                          cubit.removeMember(e);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ZButton(
                        title: "Hủy",
                        radius: 8,
                        colorBorder: Colors.transparent,
                        colorBackground: Colors.transparent,
                        colorTitle: ColorConfig.textColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 10),
                      ZButton(
                        title: "Thêm",
                        onPressed: () async {
                          final updGroup = cubit.handleAddMember();
                          onUpdateGroup(updGroup);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
