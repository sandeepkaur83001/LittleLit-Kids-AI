import 'package:little_kids_ai/core/common_imports.dart';
import 'package:little_kids_ai/widgets/common/app_web_view_screen.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppWebViewScreen.open(
          context,
          url: 'https://www.littlelit.ai/privacy-policy',
        );
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: CustomText(
          text: "privacy policy",
          fontSize: 16,
          fontWeight: FontWeight.w500,
          align: TextAlign.center,
          textColor: AppColors.whiteColor,
          isUnderline: true,
        ),
      ),
    );
  }
}
