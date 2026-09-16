import 'package:little_kids_ai/core/common_imports.dart';
import 'package:fluttertoast/fluttertoast.dart';


class CustomToast {
  static void showToast({
    required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 1,
    Color backgroundColor = Colors.orange,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    bool isSuccess = false,
  }) {
    if (message == "null" || message.isEmpty) {
      return;
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void showSuccessToast({required String msg}) {
    showToast(
      message: msg,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      isSuccess: true,
    );
  }

  static void showErrorToast({required String msg}) {
    showToast(
      message: msg,
      backgroundColor: const Color(0xFFE53935),
      textColor: Colors.white,
      isSuccess: false,
    );
  }
}
