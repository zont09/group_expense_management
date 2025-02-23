enum AppText {
  textRouteLogin,
  textRouteChat,
  textRouteOverview,
  textRouteProfile,

  textLogin,
  textSignUp,
  textNoAccount,
  textCreateAccountNow,
  textForgotPassword,
  textSignInWithGG,

  textHintUsername,
  textHintPassword,
  textHintReEnterPassword,
  textPleaseDoNotLeaveItBlank,
  textInvalidEmail,
  textRePasswordNotMatch,

  btnConfirm,
  btnCancel,
  btnOk,
}

Map<AppText, String> texts = {
  AppText.textRouteLogin: "/login",
  AppText.textRouteChat: "/chat",
  AppText.textRouteOverview: "/overview",
  AppText.textRouteProfile: "/profile",

  AppText.textLogin: "Đăng nhập",
  AppText.textSignUp: "Đăng ký",
  AppText.textHintReEnterPassword: "Nhập lại mật khẩu",
  AppText.textNoAccount: "Bạn chưa có tài khoản? ",
  AppText.textCreateAccountNow: "Đăng ký ngay!",
  AppText.textForgotPassword: "Quên mật khẩu",
  AppText.textSignInWithGG: "Đăng nhập với tài khoản google",
  AppText.textPleaseDoNotLeaveItBlank: "Vui lòng không để trống",
  AppText.textInvalidEmail: "Email không hợp lệ",
  AppText.textRePasswordNotMatch: "Email nhập lại không trùng khớp",

  AppText.textHintUsername: "Nhập email đăng nhập",
  AppText.textHintPassword: "Nhập mật khẩu",

  AppText.btnConfirm: "Xác nhận",
  AppText.btnCancel: "Huỷ",
  AppText.btnOk: "Ok",
};

extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}