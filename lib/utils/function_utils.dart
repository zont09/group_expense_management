import 'package:cloud_firestore/cloud_firestore.dart';

class FunctionUtils {
  static String getIdDb(String collection) {
    return FirebaseFirestore.instance.collection(collection).doc().id;
  }
}
