import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/add_group_cubit.dart';
import 'package:group_expense_management/main_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/utils/toast_utils.dart';
import 'package:group_expense_management/widgets/text_field_custom.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class AddGroupPopup extends StatelessWidget {
  const AddGroupPopup({super.key, required this.onAdd});

  final Function(GroupModel) onAdd;

  @override
  Widget build(BuildContext context) {
    final mC = BlocProvider.of<MainCubit>(context);
    final controller = TextEditingController();
    return BlocProvider(
      create: (context) => AddGroupCubit(),
      child: BlocBuilder<AddGroupCubit, int>(
        builder: (c, s) {
          var cubit = BlocProvider.of<AddGroupCubit>(c);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tạo nhóm mới",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ColorConfig.textColor6),
                ),
                TextFieldCustom(title: "Tên nhóm", controller: cubit.conName),
                const SizedBox(height: 10),
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

                        for (var e in mC.allUsers) {
                          debugPrint(
                              "=====> User: ${e.id} - ${e.name} - ${e.email} == ${controller.text} - ${e.email == controller.text}");
                        }
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
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: cubit.members.map((e) {
                    return Chip(
                      label: Text(e.email),
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
                      title: "Tạo nhóm",
                      onPressed: () {
                        if (cubit.conName.text.isEmpty) {
                          ToastUtils.showBottomToast(
                              context, "Tên nhóm không được để trống");
                          return;
                        }
                        List<String> members = cubit.members.map((e) => e.id).toList();
                        if(!members.contains(mC.user.id)) {
                          members.add(mC.user.id);
                        }
                        final group = GroupModel(
                          id: FirebaseFirestore.instance
                              .collection('groups')
                              .doc()
                              .id,
                          name: cubit.conName.text,
                          members: members,
                          managers: [mC.user.id],
                          owner: mC.user.id,
                        );
                        onAdd(group);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        labelText: "Nhập email người dùng",
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ColorConfig.hintText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorConfig.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorConfig.primary2),
        ),
      ),
      onChanged: (value) {
        // Handle search logic here
      },
    );
  }
}
