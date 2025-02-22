enum AppText {
  textRouteLogin,
  textRouteChat,
  textRouteOverview,
  textRouteProfile,

  textLogin,
  textNoAccount,
  textCreateAccountNow,
  textForgotPassword,
  textSignInWithGG,

  textHintUsername,
  textHintPassword,

}

Map<AppText, String> texts = {
  AppText.textRouteLogin: "/login",
  AppText.textRouteChat: "/chat",
  AppText.textRouteOverview: "/overview",
  AppText.textRouteProfile: "/profile",

  AppText.textLogin: "Đăng nhập",
  AppText.textNoAccount: "Bạn chưa có tài khoản? ",
  AppText.textCreateAccountNow: "Đăng ký ngay!",
  AppText.textForgotPassword: "Quên mật khẩu",
  AppText.textSignInWithGG: "Đăng nhập với tài khoản google",

  AppText.textHintUsername: "Nhập email đăng nhập",
  AppText.textHintPassword: "Nhập mật khẩu",
};

extension AppTexts on AppText {
  static String getStringValue(String value) {
    return value;
  }

  String get text => texts[this] ?? '--TextNotFound--';
}