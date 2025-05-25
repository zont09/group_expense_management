import 'package:flutter/material.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/features/group_detail/bloc/group_detail_cubit.dart';
import 'package:group_expense_management/models/group_model.dart';
import 'package:group_expense_management/models/user_model.dart';
import 'package:group_expense_management/services/group_service.dart';
import 'package:group_expense_management/utils/dialog_utils.dart';
import 'package:group_expense_management/widgets/avatar_item.dart';
import 'package:group_expense_management/widgets/z_button.dart';
import 'package:group_expense_management/widgets/z_space.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member, required this.cubitGD});

  final UserModel member;
  final GroupDetailCubit cubitGD;

  @override
  Widget build(BuildContext context) {
    debugPrint("===> cehck current member ${cubitGD.userCurrent.roleInGroup}");
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: ColorConfig.border))),
      child: Row(children: [
        AvatarItem(member.avatar, size: 24),
        const ZSpace(w: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.textColor,
                      letterSpacing: -0.41,
                      overflow: TextOverflow.ellipsis)),
              Text(_getMemberRole(member.roleInGroup),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorConfig.hintText,
                      letterSpacing: -0.41,
                      overflow: TextOverflow.ellipsis))
            ],
          ),
        ),
        const ZSpace(w: 9),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            size: 24,
            color: ColorConfig.textColor,
          ),
          onSelected: (String choice) async {
            if (choice == 'edit') {
              DialogUtils.showAlertDialog(context,
                  child: EditMemberPopup(
                    member: member,
                    cubitGD: cubitGD,
                  ));
            } else if (choice == 'delete') {
              final bool ok = await DialogUtils.showConfirmDialog(
                  context,
                  "Xác nhận xoá",
                  "Bạn có chắc chắn muốn xoá ${member.name} ra khỏi nhóm?");
              if(ok) {
                GroupModel updGroup = cubitGD.group.copyWith();
                updGroup = updGroup.copyWith(
                    members: updGroup.members
                        .where((e) => e != member.id)
                        .toList(),
                    managers: updGroup.managers
                        .where((e) => e != member.id)
                        .toList());

                cubitGD.updateGroup(updGroup);
                GroupService.instance.updateGroup(updGroup);
              }
            }
          },
          itemBuilder: (BuildContext context) => [
            if (cubitGD.userCurrent.roleInGroup <= 1 &&
                member.roleInGroup > cubitGD.userCurrent.roleInGroup)
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Sửa'),
              ),
            if (cubitGD.userCurrent.roleInGroup <= 1 &&
                member.roleInGroup > cubitGD.userCurrent.roleInGroup)
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Xoá'),
              ),
          ],
        )
      ]),
    );
  }

  _getMemberRole(int role) {
    switch (role) {
      case 0:
        return "Người tạo";
      case 1:
        return "Quản lý";
      case 2:
        return "Thành viên";
      default:
        return "";
    }
  }
}

class EditMemberPopup extends StatefulWidget {
  const EditMemberPopup(
      {super.key, required this.member, required this.cubitGD});

  final UserModel member;
  final GroupDetailCubit cubitGD;

  @override
  State<EditMemberPopup> createState() => _EditMemberPopupState();
}

class _EditMemberPopupState extends State<EditMemberPopup> {
  int role = 1;

  @override
  void initState() {
    role = widget.member.roleInGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RoleDropdown(
                initData:
                    widget.member.roleInGroup == 1 ? "Quản lý" : "Thành viên",
                onChanged: (v) {
                  setState(() {
                    if (v == 'Quản lý') {
                      role = 1;
                    } else {
                      role = 2;
                    }
                  });
                }),
            const ZSpace(h: 12),
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
                  title: "Xác nhận",
                  onPressed: () async {
                    GroupModel updGroup = widget.cubitGD.group.copyWith();
                    updGroup = updGroup.copyWith(
                        members: updGroup.members
                            .where((e) => e != widget.member.id)
                            .toList(),
                        managers: updGroup.managers
                            .where((e) => e != widget.member.id)
                            .toList());
                    if (role == 1) {
                      updGroup.managers.add(widget.member.id);
                    } else {
                      updGroup.members.add(widget.member.id);
                    }
                    widget.cubitGD.updateGroup(updGroup);
                    GroupService.instance.updateGroup(updGroup);
                    Navigator.of(context).pop();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoleDropdown extends StatefulWidget {
  final String initData;
  final void Function(String) onChanged;

  const RoleDropdown({
    super.key,
    required this.initData,
    required this.onChanged,
  });

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.initData;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedRole,
      items: <String>['Thành viên', 'Quản lý']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedRole = newValue;
          });
          widget.onChanged(newValue);
        }
      },
    );
  }
}
