import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:group_expense_management/app_texts.dart';
import 'package:group_expense_management/models/pair.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Đăng nhập bằng Google
  Future<User?> signInWithGoogle() async {
    try {
      // Mở hộp thoại đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Người dùng hủy đăng nhập

      // Lấy thông tin xác thực từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      return null;
    }
  }

  // 0: success, 1: email already in use, 2: fail
  Future<int> signUpAndVerifyEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          print('✅ Email xác nhận đã được gửi. Vui lòng kiểm tra hộp thư đến.');
          return 0;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('⛔ Email này đã được sử dụng. Kiểm tra nếu chưa xác nhận.');
        return 1;
        // Kiểm tra nếu tài khoản đã tồn tại nhưng chưa xác nhận email
        // User? existingUser = FirebaseAuth.instance.currentUser;
        //
        // if (existingUser != null && !existingUser.emailVerified) {
        //   print('🔄 Tài khoản chưa xác nhận. Gửi lại email xác nhận.');
        //   await existingUser.sendEmailVerification();
        // } else {
        //   print('⛔ Email đã đăng ký và xác nhận. Vui lòng đăng nhập.');
        // }
      } else {
        print('❌ Lỗi đăng ký: ${e.message}');
      }
    }
    return 2;
  }

  Future<Pair<User?, String>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!(userCredential.user?.emailVerified ?? false)) {
        await FirebaseAuth.instance.signOut();
        return Pair(null, AppText.textPleaseVerify.text);
        // return 'Vui lòng xác nhận email trước khi đăng nhập.';
      }

      return Pair(
          userCredential.user, ""); // Đăng nhập thành công, không có lỗi
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Pair(null, AppText.textEmailNoSignUp.text);
      } else if (e.code == 'wrong-password') {
        return Pair(null, AppText.textPasswordIncorrect.text);
      } else if (e.code == 'too-many-requests') {
        return Pair(null, AppText.textNoSpamAndTryAgain.text);
      } else {
        return Pair(null, 'Đăng nhập thất bại: ${e.message}');
      }
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AppText.textEmailNoSignUp.text;
      } else {
        return 'Lỗi: ${e.message}';
      }
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
