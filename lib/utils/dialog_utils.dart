import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_expense_management/app_texts.dart';

import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';
import 'package:group_expense_management/widgets/z_button.dart';

class DialogUtils {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: ColorConfig.primary1,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> showResultDialog(
      BuildContext context, String title, String message,
      {Color mainColor = ColorConfig.primary2}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Cùng kiểu bo góc
        ),
        contentPadding: EdgeInsets.symmetric(
                vertical: Resizable.size(context, 12),
                horizontal: Resizable.size(context, 12))
            .copyWith(bottom: Resizable.size(context, 12)),
        // Cùng padding
        content: SizedBox(
          width: Resizable.size(context, 436),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 20),
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Resizable.size(context, 8)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 16),
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZButton(
                    title: AppText.btnOk.text,
                    colorBackground: mainColor,
                    // Dùng màu chính
                    colorBorder: mainColor,
                    sizeTitle: 16,
                    icon: "",
                    paddingHor: 25,
                    paddingVer: 4,
                    fontWeight: FontWeight.w500,
                    // Đảm bảo padding giống Confirm
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
        // actionsPadding: EdgeInsets.symmetric(
        //   horizontal: Resizable.size(context, 12),
        //   vertical: Resizable.size(context, 12),
        // ),
        // actions: [
        //
        // ],
      ),
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    Color mainColor = ColorConfig.primary2,
    Color confirmColor = ColorConfig.error,
    Color cancelColor = ColorConfig.primary3,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        contentPadding: EdgeInsets.all(Resizable.size(context, 25)),
        content: SizedBox(
          width: Resizable.size(context, 450),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 24),
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Resizable.size(context, 20)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Resizable.font(context, 18),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(
            horizontal: Resizable.size(context, 25),
            vertical: Resizable.size(context, 25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ZButton(
                title: AppText.btnCancel.text,
                colorBackground: Colors.white,
                colorTitle: cancelColor,
                sizeTitle: 16,
                icon: "",
                paddingHor: 35,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
              SizedBox(width: Resizable.size(context, 20)),
              ZButton(
                title: AppText.btnConfirm.text,
                colorBackground: confirmColor,
                colorBorder: confirmColor,
                sizeTitle: 16,
                icon: "",
                paddingHor: 20,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}

enum DialogState { success, error }
