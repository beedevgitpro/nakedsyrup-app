import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naked_syrups/modules/cart/cart_page.dart';
import 'package:naked_syrups/modules/order_history/order_history_page.dart';
import 'package:naked_syrups/web_view_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Resources/AppColors.dart';
import '../utility/responsive_text.dart';
import 'Resources/AppStrings.dart';
import 'modules/dashboard_flow/dashboard.dart';
import 'modules/login_flow/login_page.dart';
import 'modules/login_flow/loginflow_controller.dart';

class NakedSyrupsDrawer extends StatefulWidget {
  NakedSyrupsDrawer({super.key});

  @override
  State<NakedSyrupsDrawer> createState() => _BIADrawerState();
}

class _BIADrawerState extends State<NakedSyrupsDrawer> {
  LoginFlowController loginFlowController = Get.put(LoginFlowController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget newBookings() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(Icons.list_alt, color: AppColors.greenColor, size: 28),
          title: Text(
            "Jobs",
            style: TextStyle(fontSize: getFontSize(context, 1)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.lightColor.withOpacity(0.5),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt,
                color: AppColors.greenColor,
                size: 28,
              ),
              title: Text(
                'Active Jobs',
                style: TextStyle(fontSize: getFontSize(context, 1)),
              ),
              onTap: () async {
                Get.back();
                Get.toNamed('/managebooking');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.lightColor.withOpacity(0.5),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt,
                color: AppColors.greenColor,
                size: 28,
              ),
              title: Text(
                'Completed Jobs',
                style: TextStyle(fontSize: getFontSize(context, 1)),
              ),
              onTap: () async {
                Get.back();
                Get.toNamed('/completejobs');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: AppColors.lightColor.withOpacity(0.5),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt,
                color: AppColors.greenColor,
                size: 28,
              ),
              title: Text(
                'Cancelled Jobs',
                style: TextStyle(fontSize: getFontSize(context, 1)),
              ),
              onTap: () async {
                Get.back();
                Get.toNamed('/canceljob');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget manageInspector() {
    if (loginFlowController.role.value != 3) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(
              Icons.list_alt,
              color: AppColors.greenColor,
              size: 28,
            ),
            title: Text(
              "Manage Inspectors",
              style: TextStyle(fontSize: getFontSize(context, 1)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: AppColors.lightColor.withOpacity(0.5),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: AppColors.greenColor,
                  size: 28,
                ),
                title: Text(
                  'Add',
                  style: TextStyle(fontSize: getFontSize(context, 1)),
                ),
                onTap: () async {
                  Get.back();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: AppColors.lightColor.withOpacity(0.5),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.list_alt,
                  color: AppColors.greenColor,
                  size: 28,
                ),
                title: Text(
                  'List',
                  style: TextStyle(fontSize: getFontSize(context, 1)),
                ),
                onTap: () async {
                  Get.back();
                  Get.toNamed('/inspectorlist');
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: Get.width > 700 ? Get.width * 0.5 : Get.width - 100,
        height: Get.height,
        child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 20),
            Center(
              child: SizedBox(
                width:
                    Get.width -
                    ((Get.width > 700 ? Get.width * 0.7 : Get.width - 100) -
                        120),
                child: Image.asset("assets/images/Logo.png"),
              ),
            ),
            const SizedBox(height: 50),
            drawersRow(
              context,
              Icons.dashboard_outlined,
              'Dashboard',
              () async {
                Get.back();
                Get.offAll(const DashboardPage());
              },
              true,
            ),
            Column(
              children: [
                drawersRow(
                  context,
                  Icons.shopping_cart_outlined,
                  'Cart',
                  () async {
                    Get.to(CartPage());
                  },
                  false,
                ),
                drawersRow(context, Icons.history, 'Order History', () async {
                  Get.to(OrderHistoryPage());
                }, false),
              ],
            ),
            drawersRow(
              context,
              Icons.document_scanner_outlined,
              'Vegan Australia Certified',
              () async {
                Get.to(
                  WebViewApp(
                    name: 'Vegan Australia Certified',
                    url:
                        'https://nakedsyrups.com.au/wp-content/uploads/2025/07/Vegan-Australia-Certificate-Naked-Syrups-2025.pdf',
                  ),
                );
              },
              false,
            ),
            drawersRow(
              context,
              Icons.document_scanner_outlined,
              'HACCP Certification',
              () async {
                Get.to(
                  WebViewApp(
                    name: 'HACCP Certification',
                    url:
                        'https://nakedsyrups.com.au/wp-content/uploads/2024/11/Naked-Syrups-HACCP-Certificate-Exp-2025-11-08a.pdf',
                  ),
                );
              },
              false,
            ),
            drawersRow(
              context,
              Icons.document_scanner_outlined,
              'HALAL Certification',
              () async {
                Get.to(
                  WebViewApp(
                    name: 'HALAL Certification',
                    url:
                        'https://nakedsyrups.com.au/wp-content/uploads/2025/08/Halal-Certificate-2024.pdf',
                  ),
                );
              },
              false,
            ),
            drawersRow(
              context,
              Icons.document_scanner_outlined,
              'Privacy Policy',
              () async {
                Get.to(
                  WebViewApp(
                    name: 'Privacy Policy',
                    url: 'https://nakedsyrups.com.au/privacy-policy/',
                  ),
                );
              },
              false,
            ),
            drawersRow(
              context,
              Icons.document_scanner_outlined,
              'Deliveries and Returns',
              () async {
                Get.to(
                  WebViewApp(
                    name: 'Deliveries and Returns',
                    url: 'https://nakedsyrups.com.au/deliveries-returns/',
                  ),
                );
              },
              false,
            ),
            drawersRow(context, Icons.logout, 'Logout', () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              Get.back();
              prefs.clear();
              Get.offAll(LoginPage());
            }, false),

            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Text(
                    AppStrings.version,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  drawersRow(context, icon, text, function, isFirst) {
    return Column(
      children: [
        isFirst
            ? const SizedBox()
            : Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Container(
                height: 1,
                width: 500,
                decoration: BoxDecoration(
                  color: AppColors.lightColor.withOpacity(0.5),
                ),
              ),
            ),
        Padding(
          padding: const EdgeInsets.only(top: 0, left: 10),
          child: ListTile(
            leading: Icon(icon, color: AppColors.nakedSyrup, size: 28),
            title: Text(
              text,
              style: TextStyle(fontSize: getFontSize(context, 1)),
            ),
            onTap: function,
          ),
        ),
      ],
    );
  }
}
