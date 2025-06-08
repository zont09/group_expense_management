import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FunctionUtils {
  static String getIdDb(String collection) {
    return FirebaseFirestore.instance.collection(collection).doc().id;
  }

  String normalizeVietnamese(String input) {
    const vietnameseMap = {
      'a': 'áàảãạâấầẩẫậăắằẳẵặ',
      'e': 'éèẻẽẹêếềểễệ',
      'i': 'íìỉĩị',
      'o': 'óòỏõọôốồổỗộơớờởỡợ',
      'u': 'úùủũụưứừửữự',
      'y': 'ýỳỷỹỵ',
      'd': 'đ',
    };

    String output = input.toLowerCase().trim();

    vietnameseMap.forEach((nonAccent, accents) {
      for (var accent in accents.split('')) {
        output = output.replaceAll(accent, nonAccent);
      }
    });

    // Xoá khoảng trắng dư
    output = output.replaceAll(RegExp(r'\s+'), ' ');

    return output;
  }

  static String formatVND(double amount) {
    return NumberFormat.currency(
        locale: 'vi_VN', symbol: 'đ')
        .format(amount);
  }

  static int getDaysInMonth(int year, int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    return lastDayOfMonth.day;
  }

  static String shortMoney(double number) {
    if (number <= 999) return number.toString();
    if (number <= 999999) return (number / 1000).floor().toString() + "K";
    if (number <= 999999999) {
      if ((number / 1000000).floor() >= 100)
        return (number / 1000000).floor().toString() + "M";
      else
        return (
            (number / 1000000).floor().toString() +
                "," +
                ((number % 1000000) / 100000).floor().toString() +
                "M"
        );
    }
    if (number <= 999999999999) {
      if ((number / 1000000000).floor() >= 100)
        return (number / 1000000000).floor().toString() + "B";
      else
        return (
            (number / 1000000000).floor().toString() +
                "," +
                ((number % 1000000000) / 100000000).floor().toString() +
                "B"
        );
    }
    if (number <= 999999999999999) {
      if ((number / 1000000000000).floor() >= 100)
        return (number / 1000000000000).floor().toString() + "T";
      else
        return (
            (number / 1000000000000).floor().toString() +
                "," +
                ((number % 1000000000000) / 100000000000).floor().toString() +
                "T"
        );
    }
    return "NaN";
  }

}
