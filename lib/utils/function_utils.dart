import 'package:cloud_firestore/cloud_firestore.dart';

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

}
