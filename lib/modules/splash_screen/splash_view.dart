import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/Resources/app_colors.dart';

import 'splash_controller.dart';

// ignore: must_be_immutable
class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pink.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5), // <-- Adjust opacity here
              BlendMode.darken, // <-- Darken effect
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.11,
                    height: MediaQuery.of(context).size.width * 0.11,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      color: AppColors.nakedSyrup,
                      // color: AppColors.greenColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
