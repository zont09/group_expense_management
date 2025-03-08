import 'package:flutter/material.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class AvatarItem extends StatelessWidget {
  final String avatar;
  final double size;
  final bool isShadow;

  const AvatarItem(this.avatar,
      {this.size = 20, this.isShadow = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: isShadow
              ? [
                  BoxShadow(
                    color: const Color(0x59000000),
                    offset: Offset(
                        Resizable.size(context, 3), Resizable.size(context, 2)),
                    blurRadius: Resizable.size(context, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
              color: Colors.white, width: Resizable.size(context, 1))),
      child: CircleAvatar(
          radius: Resizable.size(context, size / 2),
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10000),
            child: Image.network(avatar,
                width: Resizable.size(context, size),
                height: Resizable.size(context, size),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                    );
                  }
                },
                errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/demo_avatar.png',
                    color: Colors.grey.shade400,
                    width: Resizable.size(context, size),
                    height: Resizable.size(context, size))),
          )),
    );
  }
}
