class AppConstants {
  static const String FIREBASE_API_KEY = "AIzaSyA35LWSQcFDJWy1ozBzkx566dk63z1xyns";
  static const String FIREBASE_APP_ID = "1:245890758657:android:9923957083e24068c6e800";
  static const String FIREBASE_MESSAGING_SENDER_ID = "245890758657";
  static const String FIREBASE_PROJECT_ID = "hungely-dating-app";
  static const String FIREBASE_PROJECT_NUMBER = "245890758657";
  static const String FIREBASE_STORAGE_BUCKET = "hungely-dating-app.firebasestorage.app";
  static const String FIREBASE_GOOGLE_CLIENT_ID_ANDROID = "245890758657-6kdhdcr1aue9thbur0f7088i1dpp6gs9.apps.googleusercontent.com";
  static const String FIREBASE_GOOGLE_CLIENT_ID_IOS = "245890758657-1m0d6n54cpag9vdjcvpqh1vknl1lf3i1.apps.googleusercontent.com";
  static const String TERMS_URL = "http://162.241.68.61/little_lit/terms";
  static const String PRIVACY_URL = "http://162.241.68.61/little_lit/privacy";
}

class SharedConstants {
  // static const String FACE_AUTHENTICATION = "FACE_AUTHENTICATION";
  static const String LOGIN_MODEL = "LOGIN_MODEL";
  static const String USER_DATA = "USER_DATA";
  static const String ACCESS_TOKEN = "ACCESS_TOKEN";
}

class ApiEndPointConstants {
  // Auth
  static const String socialLogin = "/social-login";
  static const String register = "/register";
  static const String login = "/login";
  static const String forgotPassword = "/forgot-password";
  static const String resetPassword = "/reset-password";
  static const String logout = "/logout";

  // Profile
  static const String user = "/user";
  static const String profile = "/profile";
  static const String moods = "/moods";
  static const String changePassword = "/change-password";

  // Legacy / Other
  static const startVideoCall = "/chat/generateAgoraToken?";
}

class AssetConstants {
  static const visibility_off = "assets/images/visibility_off.png";
  static const visibility = "assets/images/visibility.png";
  static const back_button_icon = "assets/images/back_button_icon.png";


}
