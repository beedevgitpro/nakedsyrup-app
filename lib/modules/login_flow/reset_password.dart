import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';

import '../../Resources/app_colors.dart';
import '../../utility/responsive_text.dart';
import '../../widgets/mandtory_text_lables.dart';
import '../../widgets/text_form_fields.dart';
import 'loginflow_controller.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  LoginFlowController loginFlowController = Get.put(LoginFlowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: (Get.height - 250) * 0.2,
                ),
                child: const SizedBox(
                  // height: loginFlowController.isItTablet.value ? 50 : 0,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: textLabel('Email Address', context, true),
                    ),
                    appTextFormField(
                      controller: loginFlowController.emailController,
                      lable: 'Email',
                      function: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 15,
                        right: 15,
                      ),
                      child: Obx(() {
                        if (loginFlowController.isReset.value) {
                          return Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: AppColors.greenColor,
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(
                                Size(Get.width, 49),
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                AppColors.greenColor,
                              ),
                            ),
                            onPressed: () {
                              loginFlowController.resetValidate();
                            },
                            child: Text(
                              "Reset Password".toUpperCase(),
                              style: TextStyle(
                                fontSize: getFontSize(context, 2),
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
