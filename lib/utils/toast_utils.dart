import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_expense_management/configs/color_configs.dart';
import 'package:group_expense_management/utils/resizable_utils.dart';

class ToastUtils {
  static message(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showBottomToast(BuildContext context, String text, {int duration = 2}) {
    final fToast = FToast()..init(context);
    Widget toast = Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.size(context, 10),
            vertical: Resizable.size(context, 5)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.white,
            color: Colors.white),
        child: Row(mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              size: Resizable.size(context, 30),
              color: ColorConfig.primary2,
            ),
            SizedBox(width: Resizable.size(context, 5)),
            Flexible(
              child: Text(
                text,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: Resizable.size(context, 15),
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: duration),
    );
  }
}
