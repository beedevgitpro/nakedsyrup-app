import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:naked_syrups/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Resources/AppColors.dart';
import '../../model/category_model.dart';
import '../../model/dashboard_list.dart';
import '../../model/notification_model.dart';
import '../../model/order_history_model.dart';
import '../../model/price_model.dart';
import '../../model/product_model.dart';
import '../../model/shipping_methods_model.dart';
import '../../service.dart';
import '../cart/cart_page.dart';
import '../cart/paypal_payment.dart';
import '../cart/thankyou_page.dart';
import '../login_flow/login_page.dart';
import 'dashboard.dart';

class DashboardController extends GetxController {
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> shippingAddressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerationForm = GlobalKey<FormState>();
  RxBool getData = false.obs;
  RxBool placeOrder = false.obs;
  RxBool getPriceDetails = false.obs;
  RxBool deleteAccount = false.obs;
  RxBool getProduct = false.obs;
  RxInt selectedd = 0.obs;
  RxInt cartCount = 0.obs;
  RxDouble recaptchaHeight = 500.0.obs;
  RxBool getCart = false.obs;
  RxBool isCaptchaVerified = false.obs;
  RxBool isVerifying = false.obs;
  RxBool isImageChallengeLikelyVisible = false.obs;
  RxBool getShipping = false.obs;
  RxBool getCheckOut = false.obs;
  RxBool isLoading = false.obs;
  RxBool getProfile = false.obs;
  RxBool saveProfile = false.obs;
  RxBool differentAddress = false.obs;
  RxBool createAnAccount = false.obs;
  RxBool getHistory = false.obs;
  RxBool addToBasket = false.obs;
  RxBool showDescription = false.obs;
  RxBool loadWebView = false.obs;
  RxBool isExpanded = false.obs;
  RxBool isOnline = false.obs;
  RxBool callRegisterApi = false.obs;
  RxBool promoCodeFiled = false.obs;
  RxBool saveInvoice = false.obs;
  RxString isPayment = 'no'.obs;
  RxString name = ''.obs;
  RxString token = ''.obs;
  RxString isPayByAcc = ''.obs;
  RxString captchaToken = ''.obs;
  RxString selectedVariance = ''.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedCountryDiff = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedStateDiff = ''.obs;
  RxString selectedNewsLetter = ''.obs;
  RxString shippingMethods = ''.obs;
  RxString selectedPaymentMethods = 'cod'.obs;
  RxBool enableRegistration = false.obs;
  RxBool enableCheckOut = true.obs;
  Rx<Variations> selectedVariations = Variations().obs;
  RxBool isCompleted = false.obs;
  RxBool isCanceled = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isActive = false.obs;
  RxInt selectedGst = 2.obs;
  RxList<Map<String, dynamic>> cartQueue = <Map<String, dynamic>>[].obs;
  bool isProcessing = false;
  CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  Rx<DashboardList> dashboardList = DashboardList().obs;
  RxMap<String, dynamic> countryMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> stateMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> stateMapDiff = <String, dynamic>{}.obs;
  List newsletter = ['Distributor/Roaster', 'Café/Restaurant', 'Home'];
  Rx<ProductModel> productModel = ProductModel().obs;
  Rx<NotificationModel> notificationDetail = NotificationModel().obs;
  Rx<CartModel> cartModel = CartModel().obs;
  Rx<PriceModel> priceModel = PriceModel().obs;
  Rx<OrderHistoryModel> orderHistoryModel = OrderHistoryModel().obs;
  Rx<ShippingMethodsModel> shippingMethodsModel = ShippingMethodsModel().obs;
  final GlobalKey<LiquidPullToRefreshState> refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<LiquidPullToRefreshState> categoryPageRefreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<LiquidPullToRefreshState> productListRefreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<LiquidPullToRefreshState> cartRefreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<LiquidPullToRefreshState> orderHistoryIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<LiquidPullToRefreshState> checkOutRefreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final GlobalKey<FormState> editInvoiceFormKey = GlobalKey<FormState>();
  TextEditingController searchJobController = TextEditingController();
  TextEditingController searchOwnerNameController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController jobType = TextEditingController();
  TextEditingController inspectionCostController = TextEditingController();
  TextEditingController travelController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController firstNormalController = TextEditingController();
  TextEditingController lastNormalController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  TextEditingController firstNameDiffController = TextEditingController();
  TextEditingController orderNotesController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController lastNameDiffController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyNameDiffController = TextEditingController();
  TextEditingController companyName2Controller = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController streetAddressDiffController = TextEditingController();
  TextEditingController streetAddress2Controller = TextEditingController();
  TextEditingController streetAddress2DiffController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController townDiffController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController postCodeDiffController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailNormalController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController pOController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Future<void> handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    getName();
    getPayByAcc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderHistory();
    });

    return completer.future.then<void>((_) {
      Get.snackbar('Refresh complete', "", snackPosition: SnackPosition.BOTTOM);
    });
  }

  Future<void> historyRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    orderHistory();
    return completer.future.then<void>((_) {
      Get.snackbar('Refresh complete', "", snackPosition: SnackPosition.BOTTOM);
    });
  }

  Future<void> dashBoardRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      completer.complete();
    });
    getName();
    viewedProduct();
    holidayNotification();
    return completer.future.then<void>((_) {
      Get.snackbar('Refresh complete', "", snackPosition: SnackPosition.BOTTOM);
    });
  }

  Future<void> cartRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 2), () {
      completer.complete();
    });
    findCart();
    return completer.future.then<void>((_) {
      Get.snackbar('Refresh complete', "", snackPosition: SnackPosition.BOTTOM);
    });
  }

  cartQuantityUpdate(productId, qty, variationId) async {
    getCart.value = true;
    var addedd = await ApiClass().updateQuantity(productId, qty, variationId);
    if (addedd != null) {
      if (addedd['success'] == true) {
        findCart();
        print("quantity update : ${addedd}");
      } else {
        getCart.value = false;
        Get.snackbar(
          addedd['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      getCart.value = false;
      Get.snackbar(
        "Quantity update error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  // getShippingMethods() async {
  //   getShipping.value = true;
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var shipping;
  //   if (prefs.getString("guest_token") != null &&
  //       prefs.getString("guest_token")?.isNotEmpty == true) {
  //     shipping = await ApiClass().shippingMethods(
  //       selectedCountry.value,
  //       selectedState.value,
  //       postCodeController.text,
  //       townController.text,
  //     );
  //   } else if (differentAddress.value) {
  //     shipping = await ApiClass().shippingMethods(
  //       selectedCountryDiff.value,
  //       selectedStateDiff.value,
  //       postCodeDiffController.text,
  //       townDiffController.text,
  //     );
  //   } else {
  //     shipping = await ApiClass().shippingMethods(
  //       selectedCountry.value,
  //       selectedState.value,
  //       postCodeController.text,
  //       townController.text,
  //     );
  //   }
  //   if (shipping != null) {
  //     if (shipping['success'] == true) {
  //       shippingMethodsModel.value = ShippingMethodsModel.fromJson(shipping);
  //       // Get.to(ShippingDetailsPage());
  //       getShipping.value = false;
  //     } else {
  //       getShipping.value = false;
  //       Get.snackbar(
  //         shipping['message'],
  //         '',
  //         colorText: Colors.red,
  //         backgroundColor: Colors.white,
  //       );
  //     }
  //   } else {
  //     getShipping.value = false;
  //   }
  // }

getShippingMethods() async {
    getShipping.value = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isGuest = prefs.getString("guest_token") != null && prefs.getString("guest_token")!.isNotEmpty; String country; String state; String postcode; String town;
    if (isGuest) {
      country = selectedCountry.value;
      state = selectedState.value;
      postcode = postCodeController.text.trim();
      town = townController.text.trim(); } else if (differentAddress.value)
      { country = selectedCountryDiff.value;
        state = selectedStateDiff.value;
        postcode = postCodeDiffController.text.trim();
        town = townDiffController.text.trim(); } else {
      country = selectedCountry.value;
      state = selectedState.value;
      postcode = postCodeController.text.trim();
      town = townController.text.trim(); } /// Validation
if (country.isEmpty || state.isEmpty || postcode.isEmpty || town.isEmpty)
{ getShipping.value = false;
  Get.snackbar( 'Validation Error', 'Please fill all required shipping fields.', colorText: Colors.red, backgroundColor: Colors.white, ); return; }
    final hasInternet = await hasStableInternet();

    if (!hasInternet) {
      Get.defaultDialog(
        title: 'Network Issue',
        middleText:
        'Your internet connection appears to be unstable. Please check your connection and try again.',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
      return;
    }


var shipping = await ApiClass().shippingMethods( country, state, postcode, town, );
if (shipping != null) {
  if (shipping['success'] == true)
  { shippingMethodsModel.value = ShippingMethodsModel.fromJson(shipping); }
  else { Get.snackbar( shipping['message'] ?? 'Error', '', colorText: Colors.red, backgroundColor: Colors.white, ); } }
getShipping.value = false; }

  double calculateShipping() {
    double totalShipping = 0.0;

    final fees = priceModel.value.fees ?? [];

    for (var fee in fees) {
      double value = 0.0;

      if (fee.amount != null) {
        value = double.tryParse(fee.amount.toString()) ?? 0.0;
      } else if (fee.shippingModel != null) {
        value = double.tryParse(fee.shippingModel.toString()) ?? 0.0;
      }

      totalShipping += value;
    }

    return totalShipping;
  }

  List<Map<String, dynamic>> getPaypalItems() {
    final cartItems = cartModel.value.cartItems ?? [];

    return cartItems.map((item) {
      return {
        "name": item.productName ?? "",
        "quantity": int.parse(item.quantity.toString()).toString(),
        "price": double.parse(
          item.currentPrice?.toString() ?? "0",
        ).toStringAsFixed(2),
        "currency": "AUD",
      };
    }).toList();
  }

  double calculatePaypalSubtotal() {
    double total = 0.0;

    final items = getPaypalItems();

    for (var item in items) {
      double price = double.tryParse(item['price']) ?? 0.0;
      int qty = int.tryParse(item['quantity']) ?? 0;

      total += price * qty;
    }

    return total;
  }

  Future<bool> hasStableInternet() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      return false;
    }

    final hasInternet = await InternetConnection().hasInternetAccess;

    return hasInternet;
  }

  placeOrderApi() async {
    if (emailController.text == null || emailController.text.trim().isEmpty) {
      return "Email address is required!";
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      return "Please enter a valid email address!";
    }

    if (phoneController.text.isEmpty) {
      return "Phone number is required!";
    }

    if (phoneController.text.length < 8) {
      return "Please enter a valid phone number!";
    }
    if (postCodeController.text.isEmpty) {
      return "Please add postcode!";
    }

    if (!RegExp(r'^\d{4}$').hasMatch(postCodeController.text)) {
      return "Please enter a valid 4 digit postcode!";
    }
    if (selectedPaymentMethods.value.isEmpty) {
      Get.snackbar(
        'Checkout Error',
        'Please select a payment method.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (shippingMethods.value.isEmpty) {
      Get.snackbar(
        'Checkout Error',
        'Please select a shipping method.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    placeOrder.value = true;
    FocusScope.of(Get.context!).unfocus();
    final hasInternet = await hasStableInternet();

    if (!hasInternet) {
      placeOrder.value = false;
      Get.defaultDialog(
        title: 'Network Issue',
        middleText:
            'Your internet connection appears to be unstable. Please check your connection and try again.',
        textConfirm: 'OK',
        onConfirm: () => Get.back(),
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> mapp = {};
    String? guestToken = prefs.getString("guest_token");

    // -------------------------------
    // BUILD REQUEST MAP (NO CHANGE)
    // -------------------------------
    if (guestToken != null && guestToken.isNotEmpty) {
      addressFormKey.currentState?.save();
      final billingValid = addressFormKey.currentState?.validate() ?? false;

      final shippingValid =
          differentAddress.value
              ? (shippingAddressFormKey.currentState?.validate() ?? false)
              : true;
print("valid: billingValid : $billingValid --- shippingValid : ${shippingValid} differentAddress.value : ${differentAddress.value}");
if(differentAddress.value && token.value.isNotEmpty) {
  if (!billingValid || !shippingValid) {
    Get.snackbar(
      'Checkout Error',
      'Please complete all required checkout fiPlease login to apply this coupoelds.',
      snackPosition: SnackPosition.BOTTOM,
    );
    placeOrder.value= false;
    return;
  }
}else {
  if (!billingValid) {
    Get.snackbar(
      'Checkout Error',
      'Please complete all required checkout fields.',
      snackPosition: SnackPosition.BOTTOM,
    );
    placeOrder.value= false;
    return;
  }
}

      mapp = {
        "billing": {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "company": companyNameController.text,
          "address_1": streetAddressController.text,
          "address_2": streetAddress2Controller.text,
          "city": townController.text,
          "state": selectedState.value,
          "postcode": postCodeController.text,
          "country": selectedCountry.value,
          "email": emailController.text,
          "phone": phoneController.text,
          "po_number": pOController.text,
        },
        "use_shipping": "yes",
        "create_account": createAnAccount.value ? 'yes' : 'no',
        "payment_method": selectedPaymentMethods.value,
        "shipping_method": shippingMethods.value,
        "order_notes": orderNotesController.text,
        "guest_token": guestToken,
      };

      if (createAnAccount.value) {
        mapp.addAll({
          "username": firstNameController.text,
          "password": passwordController.text,
        });
      }
    } else if (differentAddress.value) {
      mapp = {
        "billing": {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "company": companyNameController.text,
          "address_1": streetAddressController.text,
          "address_2": streetAddress2Controller.text,
          "city": townController.text,
          "state": selectedState.value,
          "postcode": postCodeController.text,
          "country": selectedCountry.value,
          "email": emailController.text,
          "phone": phoneController.text,
          "po_number": pOController.text,
        },
        "shipping": {
          "first_name": firstNameDiffController.text,
          "last_name": lastNameDiffController.text,
          "company": companyNameDiffController.text,
          "address_1": streetAddressDiffController.text,
          "address_2": streetAddress2DiffController.text,
          "city": townDiffController.text,
          "state": selectedStateDiff.value,
          "postcode": postCodeDiffController.text,
          "country": selectedCountryDiff.value,
        },
        "use_shipping": "yes",
        "payment_method": selectedPaymentMethods.value,
        "shipping_method": shippingMethods.value,
        "order_notes": orderNotesController.text,
      };
    } else {
      mapp = {
        "billing": {
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "company": companyNameController.text,
          "address_1": streetAddressController.text,
          "address_2": streetAddress2Controller.text,
          "city": townController.text,
          "state": selectedState.value,
          "postcode": postCodeController.text,
          "country": selectedCountry.value,
          "email": emailController.text,
          "phone": phoneController.text,
          "po_number": pOController.text,
        },
        "use_shipping": "no",
        "payment_method": selectedPaymentMethods.value,
        "shipping_method": shippingMethods.value,
        "order_notes": orderNotesController.text,
      };
    }
print("Mapp at orderplace : ${mapp}");
    // -------------------------------
    // API CALL
    // -------------------------------
    var shipping = await ApiClass().orderPlaced(mapp);
print("shipping response of orderPlaced:$shipping ");
    if (shipping == null) {
      placeOrder.value = false;
      Get.snackbar(
        "Error in placing order",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return;
    }

    if (shipping['success'] != true) {
      placeOrder.value = false;
      Get.snackbar(
        shipping['message'],
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return;
    }

    // -------------------------------
    // PAYPAL FLOW
    // -------------------------------
// -------------------------------
// PAYPAL FLOW
// -------------------------------
    if (
    selectedPaymentMethods.value ==
        'ppcp'
    ) {
      final int? wooCommerceOrderId =
      int.tryParse(
        shipping['order_id'].toString(),
      );

      if (wooCommerceOrderId == null) {
        placeOrder.value = false;

        Get.snackbar(
          'PayPal Error',
          'The WooCommerce order ID was not returned.',
          colorText: Colors.red,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      /*
   * The backend calculates the total from the WooCommerce order.
   * Do not send shipping['total'] to PayPal.
   */
      final Map<String, dynamic>? paypal =
      await ApiClass().createPaypalOrder(
        wooCommerceOrderId,
      );

      if (paypal == null) {
        placeOrder.value = false;

        Get.snackbar(
          'PayPal Error',
          'Unable to initialise PayPal payment.',
          colorText: Colors.red,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      if (paypal['success'] != true) {
        placeOrder.value = false;

        Get.snackbar(
          'PayPal Error',
          paypal['message']?.toString() ??
              'PayPal order creation failed.',
          colorText: Colors.red,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      final String approvalUrl =
          paypal['approveUrl']
              ?.toString()
              .trim() ??
              '';

      final String paypalOrderId =
          paypal['orderID']
              ?.toString()
              .trim() ??
              '';

      if (
      approvalUrl.isEmpty ||
          paypalOrderId.isEmpty
      ) {
        placeOrder.value = false;

        Get.snackbar(
          'PayPal Error',
          'PayPal did not return a valid approval URL.',
          colorText: Colors.red,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      final dynamic result =
      await Navigator.of(
        Get.context!,
      ).push(
        MaterialPageRoute(
          builder: (_) => PaypalWebView(
            approvalUrl: approvalUrl,
            paypalOrderId: paypalOrderId,
            wooCommerceOrderId:
            wooCommerceOrderId,
          ),
        ),
      );



      debugPrint(
        'PayPal screen result: $result',
      );

      if (
      result is Map &&
          result['status'] == 'success'
      ) {
        /*
     * Refresh cart and order history after backend payment_complete().
     */
        cartCount.value = 0;
        cartModel.value = CartModel();

        if (token.value.isNotEmpty) {
          await orderHistory();
        }

        if (Get.context == null) {
          return;
        }
        placeOrder.value = false;
        Get.to(ThankYouPage());
        return;
      }

      if (
      result is Map &&
          result['status'] ==
              'review_required'
      ) {
        placeOrder.value = false;
        Get.defaultDialog(
          title: 'Payment received',
          middleText:
          result['message']?.toString() ??
              'Your PayPal payment was received and the order is being reviewed. Please do not submit another payment.',
          textConfirm: 'OK',
          barrierDismissible: false,
          onConfirm: () {
            Get.offAll(
              const DashboardPage(),
            );
          },
        );

        return;
      }

      if (
      result is Map &&
          result['status'] == 'cancelled'
      ) {
        placeOrder.value = false;
        Get.snackbar(
          'Payment cancelled',
          'Your order remains unpaid and your cart has been retained. You can try PayPal again.',
          colorText: Colors.black87,
          backgroundColor: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      if (
      result is Map &&
          result['status'] ==
              'confirmation_unknown'
      ) {
        placeOrder.value = false;
        Get.defaultDialog(
          title:
          'Payment confirmation pending',
          middleText:
          'The PayPal response could not be confirmed. Please check your order history before trying to pay again.',
          textConfirm: 'OK',
          barrierDismissible: false,
          onConfirm: () {
            Get.offAll(
              const DashboardPage(),
            );
          },
        );

        return;
      }

      final String failureMessage =
      result is Map
          ? result['message']?.toString() ??
          'Payment could not be confirmed.'
          : 'Payment could not be confirmed.';

      Get.snackbar(
        'PayPal payment not completed',
        failureMessage,
        colorText: Colors.red,
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }else {
      if(shipping['success'] == true){

        cartCount.value = 0;
        cartModel.value = CartModel();

        if (token.value.isNotEmpty) {
          await orderHistory();
        }

        if (Get.context == null) {
          return;
        }
        placeOrder.value = false;
        Get.to(ThankYouPage());

        return;
      }
    }
    // -------------------------------
    // NON-PAYPAL SUCCESS
    // -------------------------------
    placeOrder.value = false;
  }

  priceDetails() async {
    getPriceDetails.value = true;

    Map<String, dynamic> mapp = {};
    if (token.isEmpty) {
      mapp = {
        "billing": {
          "address_1": streetAddressController.text,
          "city": townController.text,
          "state": selectedState.value,
          "postcode": postCodeController.text,
          "country": selectedCountry.value,
        },
        "payment_method": selectedPaymentMethods.value,
        "shipping_method": shippingMethods.value,
      };
    } else if (differentAddress.value) {
      mapp = {
        "billing": {
          "address_1": streetAddressController.text,
          "city": townController.text,
          "state": selectedState.value,
          "postcode": postCodeController.text,
          "country": selectedCountry.value,
        },
        "shipping": {
          "address_1": streetAddressDiffController.text,
          "city": townDiffController.text,
          "state": selectedStateDiff.value,
          "postcode": postCodeDiffController.text,
          "country": selectedCountryDiff.value,
        },
        "payment_method": selectedPaymentMethods.value,
        "shipping_method": shippingMethods.value,
      };
    } else {
      mapp = {
        "billing": {
          "address_1": streetAddressController.text,
          "city": townController.text,
          "state": selectedState.value,
          "postcode": postCodeController.text,
          "country": selectedCountry.value,
        },
        "payment_method": selectedPaymentMethods.value,
        "shipping_method": shippingMethods.value,
      };
    }

    var shipping = await ApiClass().getPriceDetails(mapp);
    if (shipping != null) {
      if (shipping['success'] == true) {
        // priceModel.value = PriceModel();
        print("shipping : ${shipping is Map}");
        priceModel.value = PriceModel.fromJson(shipping);
        getPriceDetails.value = false;
      } else {
        getPriceDetails.value = false;
        Get.snackbar(
          shipping['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      placeOrder.value = false;
      Get.snackbar(
        "Error in placing order",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  deActiveAcc() {
    showDialog<void>(
      context: Get.context!,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Are you sure, do you want to Delete your account?",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              actions: <Widget>[
                Obx(
                  () =>
                      deleteAccount.value
                          ? Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: AppColors.greenColor,
                              ),
                            ),
                          )
                          : ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(
                                AppColors.nakedSyrup,
                              ),
                              padding: WidgetStateProperty.all(
                                const EdgeInsets.all(8),
                              ),
                            ),
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () async {
                              deleteAccount.value = true;
                              var delete = await ApiClass().deleteAccount();
                              deleteAccount.value = false;
                              if (delete != null) {
                                Get.snackbar(
                                  "Error ${delete['message']}",
                                  "",
                                  colorText: Colors.red,
                                  backgroundColor: Colors.white,
                                );
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                Get.back();
                                prefs.clear();
                                Get.offAll(LoginPage());
                              }
                            },
                          ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      AppColors.lightColor,
                    ),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(8)),
                  ),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  onPressed: () async {
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  updateProfile() async {
    if (addressFormKey.currentState?.validate() == true) {
      saveProfile.value = true;
      print(
        "addressFormKey validation : ${addressFormKey.currentState?.validate()}",
      );
      // print(
      //   "addressFormKey validation : ${shippingAddressFormKey.currentState?.validate()}",
      // );

      Map<String, dynamic> mapp = {};
      mapp = {
        "billing_first_name": firstNameController.text,
        "billing_last_name": lastNameController.text,
        "billing_company": companyNameController.text,
        "billing_address_1": streetAddressController.text,
        "billing_address_2": streetAddress2Controller.text,
        "billing_city": townController.text,
        "billing_state": selectedState.value,
        "billing_postcode": postCodeController.text,
        "billing_country": selectedCountry.value,
        "billing_email": emailController.text,
        "billing_phone": phoneController.text,
        "shipping_first_name": firstNameDiffController.text,
        "shipping_last_name": lastNameDiffController.text,
        "shipping_company": companyNameDiffController.text,
        "shipping_address_1": streetAddressDiffController.text,
        "shipping_address_2": streetAddress2DiffController.text,
        "shipping_city": townDiffController.text,
        "shipping_state": selectedStateDiff.value,
        "shipping_postcode": postCodeDiffController.text,
        "shipping_country": selectedCountryDiff.value,
        'first_name': firstNormalController.text,
        'last_name': lastNormalController.text,
        'display_name': userNameController.text,
        'email': emailNormalController.text,
      };

      var shipping = await ApiClass().updateProfile(mapp);
      if (shipping != null) {
        if (shipping['success'] == true) {
          Get.snackbar(
            shipping['message'],
            '',
            colorText: Colors.black,
            backgroundColor: Colors.white,
          );
          Get.back();
          saveProfile.value = false;
        } else {
          saveProfile.value = false;
          Get.snackbar(
            shipping['message'],
            '',
            colorText: Colors.red,
            backgroundColor: Colors.white,
          );
        }
      } else {
        saveProfile.value = false;
        Get.snackbar(
          "Profile update error",
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Please fill all mandatory fields",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  fillProfileData() async {
    getProfile.value = true;
    var profile = await ApiClass().getProfileDetails();
    if (profile != null) {
      if (profile['success'] == true) {
        firstNormalController.text = profile['data']['first_name'];
        lastNormalController.text = profile['data']['last_name'];
        userNameController.text = profile['data']['display_name'];
        emailNormalController.text = profile['data']['email'];
        print("billing is List : ${profile['data']['billing']}");
        print("shipping is List : ${profile['data']['shipping'] is List}");
        firstNameController.text = profile['data']['billing'][0];
        lastNameController.text = profile['data']['billing'][1];
        companyNameController.text = profile['data']['billing'][2];
        streetAddressController.text = profile['data']['billing'][3];
        streetAddress2Controller.text = profile['data']['billing'][4];
        townController.text = profile['data']['billing'][5];
        postCodeController.text = profile['data']['billing'][6];
        selectedCountry.value = profile['data']['billing'][7];
        if (selectedCountry.value.isNotEmpty) {
          getStateList(selectedCountry.value, false);
        }
        selectedState.value = profile['data']['billing'][8];
        phoneController.text = profile['data']['billing'][9];
        emailController.text = profile['data']['billing'][10];
        firstNameDiffController.text = profile['data']['shipping'][0];
        lastNameDiffController.text = profile['data']['shipping'][1];
        companyNameDiffController.text = profile['data']['shipping'][2];
        streetAddressDiffController.text = profile['data']['shipping'][3];
        streetAddress2DiffController.text = profile['data']['shipping'][4];
        townDiffController.text = profile['data']['shipping'][5];
        postCodeDiffController.text = profile['data']['shipping'][6];
        selectedCountryDiff.value = profile['data']['shipping'][7];
        print(
          "shipping country selectedCountryDiff: ${profile['data']['shipping'][7].isEmpty} ",
        );
        if (selectedCountryDiff.value.isNotEmpty) {
          getStateList(selectedCountryDiff.value, true);
        }
        selectedStateDiff.value = profile['data']['shipping'][8];

        getProfile.value = false;
      } else {
        getProfile.value = false;
        Get.snackbar(
          profile['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      getProfile.value = false;
      Get.snackbar(
        "Quantity update error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  registration() async {
    callRegisterApi.value = true;
    Map<String, dynamic> mapp = {};
    if (registerationForm.currentState?.validate() == true) {
      mapp = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "company": companyNameController.text,
        "address_1": streetAddressController.text,
        "address_2": streetAddress2Controller.text,
        "city": townController.text,
        "state": selectedState.value,
        "postcode": postCodeController.text,
        "country": selectedCountry.value,
        "email": emailController.text,
        "phone": phoneController.text,
        "username": userNameController.text,
        "password": passwordController.text,
      };

      var shipping = await ApiClass().customerCreate(mapp);
      if (shipping != null) {
        if (shipping['success'] == true) {
          Get.snackbar(shipping['message'], '', backgroundColor: Colors.white);
          callRegisterApi.value = false;
          showDialog<void>(
            context: Get.context!,
            barrierDismissible: false,
            // user must tap button!
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text(
                      "Thank you for registration!",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    content: const SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        "Our team will get back to you within 48 hours.",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            AppColors.nakedSyrup,
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(8),
                          ),
                        ),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          Get.back();
                          prefs.clear();
                          Get.offAll(LoginPage());
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        } else {
          callRegisterApi.value = false;
          Get.snackbar(
            shipping['message'],
            '',
            colorText: Colors.red,
            backgroundColor: Colors.white,
          );
        }
      } else {
        callRegisterApi.value = false;
        Get.snackbar(
          "registration error",
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      callRegisterApi.value = false;
      Get.snackbar(
        "Please fill all mandatory fields",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  deleteCartItem(productId) async {
    getCart.value = true;
    var addedd = await ApiClass().deleteItems(productId);
    if (addedd != null) {
      if (addedd['success'] == true) {
        // findCart();
        getCart.value = false;
        cartModel.value = CartModel.fromJson(addedd);
        cartCount.value = cartModel.value.cartItems?.length ?? 0;
        print("quantity update : ${addedd}");
      } else {
        getCart.value = false;
        Get.snackbar(
          addedd['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      getCart.value = false;
      Get.snackbar(
        "Quantity update error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  void loadToken() async {
    SharedPreferences.getInstance().then((prefs) {
      token.value = prefs.getString('token') ?? "";
      if (token.isNotEmpty == true) {
        orderHistory();
        findCart();
      }
    });
  }

  findCategory() async {
    getData.value = true;
    var category = await ApiClass().getCategory();
    if (category != null) {
      categoryModel.value = CategoryModel.fromJson(category);
    }
    getData.value = false;
  }

  getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? "Guest User";
    token.value = prefs.getString('token') ?? "";
  }

  getPayByAcc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isPayByAcc.value = prefs.getString('pay_by_account') ?? "";
  }

  Widget cartUI() {
    return Obx(() {
      return Stack(
        children: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, size: 30),
            onPressed: () {
              Get.to(CartPage());

              // String token = "";
              // SharedPreferences.getInstance().then((prefs) {
              //   token = prefs.getString('token') ?? "";
              //   if (token.isNotEmpty) {
              //     Get.to(CartPage());
              //   } else {
              //     // Trigger dialog AFTER build
              //     showDialog<void>(
              //       context: Get.context!,
              //       barrierDismissible: true,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: Text(
              //             "Please login to add products in cart.",
              //             style: TextStyle(
              //               fontSize: 18,
              //               fontWeight: FontWeight.w800,
              //             ),
              //           ),
              //           actions: <Widget>[
              //             ElevatedButton(
              //               style: ButtonStyle(
              //                 backgroundColor: WidgetStatePropertyAll<Color>(
              //                   AppColors.nakedSyrup,
              //                 ),
              //               ),
              //               child: const Text(
              //                 "Login",
              //                 style: TextStyle(color: Colors.white),
              //               ),
              //               onPressed: () async {
              //                 Get.offAll(LoginPage());
              //               },
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   }
              // });
            },
          ),
          if (cartCount.value > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                child: Center(
                  child: Text(
                    '${cartCount.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  viewedProduct() async {
    getData.value = true;
    var dashboard = await ApiClass().mostViewedProduct();
    print("dashboard : $dashboard");
    if (dashboard != null) {
      dashboardList.value = DashboardList.fromJson(dashboard);
    }
    getData.value = false;
  }

  holidayNotification() async {
    getData.value = true;
    var notification = await ApiClass().notification();
    print("notification : $notification");
    if (notification != null) {
      notificationDetail.value = NotificationModel.fromJson(notification);
    }
    getData.value = false;
  }

  findCart() async {
    getCart.value = true;
    var cart = await ApiClass().getCart();
    if (cart != null) {
      cartModel.value = CartModel.fromJson(cart);
      cartCount.value = cartModel.value.cartItems?.length ?? 0;
    }
    getCart.value = false;
  }

  getCountryList() async {
    getCheckOut.value = true;
    var respose = await ApiClass().getCountry();
    if (respose != null) {
      countryMap.clear();
      Map<String, dynamic> jsonResponse = respose;
      Map<String, String> parsedCountries = (jsonResponse['countries']
              as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString()));
      countryMap.addAll(parsedCountries);
    }
    getCheckOut.value = false;
  }

  getStateList(code, isDiff) async {
    getCheckOut.value = true;
    print("get statess : ${code}");
    if (code.toString().isNotEmpty) {
      var respose = await ApiClass().getState(code);

      Map<String, dynamic> jsonResponse = respose;
      Map<String, String> parsedCountries = {};
      if (jsonResponse['states'] == false) {
        getCheckOut.value= false;

      } else {
        if (jsonResponse['states'].isNotEmpty) {
          parsedCountries = (jsonResponse['states'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString()));
        } else {}
        if (isDiff != null) {
          if (isDiff) {
            stateMapDiff.clear();
            stateMapDiff.addAll(parsedCountries);
          } else {
            stateMap.clear();
            stateMap.addAll(parsedCountries);
          }
        } else {
          stateMap.clear();
          stateMapDiff.clear();
          stateMap.addAll(parsedCountries);
          stateMapDiff.addAll(parsedCountries);
        }
        getCheckOut.value= false;
      }
    } else {
      getCheckOut.value = false;
    }
  }

  getBillingDetails() async {
    getCheckOut.value = true;
    var responce = await ApiClass().getBillingDetails();
    if (responce != null) {
      getStateList(responce['billing_details']['country'] ?? "", null);

      selectedCountry.value = responce['billing_details']['country'] ?? "";
      selectedCountryDiff.value = responce['billing_details']['country'] ?? "";
      firstNameController.text =
          responce['billing_details']['first_name'] ?? "";
      firstNameDiffController.text =
          responce['billing_details']['first_name'] ?? "";
      lastNameController.text = responce['billing_details']['last_name'] ?? "";
      lastNameDiffController.text =
          responce['billing_details']['last_name'] ?? "";
      companyNameController.text = responce['billing_details']['company'] ?? "";
      companyNameDiffController.text =
          responce['billing_details']['company'] ?? "";
      streetAddressController.text =
          responce['billing_details']['address_1'] ?? "";
      streetAddressDiffController.text =
          responce['billing_details']['address_1'] ?? "";
      streetAddress2Controller.text =
          responce['billing_details']['address_2'] ?? "";
      streetAddress2DiffController.text =
          responce['billing_details']['address_2'] ?? "";
      townController.text = responce['billing_details']['city'] ?? "";
      townDiffController.text = responce['billing_details']['city'] ?? "";
      postCodeController.text = responce['billing_details']['postcode'] ?? "";
      postCodeDiffController.text =
          responce['billing_details']['postcode'] ?? "";
      phoneController.text = responce['billing_details']['phone'] ?? "";
      emailController.text = responce['billing_details']['email'] ?? "";

      selectedState.value = responce['billing_details']['state'] ?? "";
      selectedStateDiff.value = responce['billing_details']['state'] ?? "";
      getShippingMethods();
    }
    differentAddress.value = false;
    getCheckOut.value = false;
  }

  orderHistory() async {
    getHistory.value = true;
    getName();
    if(token.isNotEmpty) {
      var history = await ApiClass().getOrderHistory();
      if (history != null) {
        orderHistoryModel.value = OrderHistoryModel.fromJson(history);
      }
    }
    getHistory.value = false;
  }

  fetchDataForTab(slug) async {
    getProduct.value = true;
    var category = await ApiClass().getProductFromCategory(slug);
    if (category != null) {
      productModel.value = ProductModel.fromJson(category);
    }
    getProduct.value = false;
  }

  // addToCart(productId, qty, variationId) async {
  //   addToBasket.value = true;
  //   var addedd = await ApiClass().addToCart(productId, qty, variationId);
  //   if (addedd != null) {
  //     if (addedd['success'] == true) {
  //       findCart();
  //       addToBasket.value = false;
  //     } else {
  //       addToBasket.value = false;
  //       Get.snackbar(
  //         addedd['message'],
  //         '',
  //         colorText: Colors.red,
  //         backgroundColor: Colors.white,
  //       );
  //     }
  //   } else {
  //     addToBasket.value = false;
  //     Get.snackbar(
  //       "Error..",
  //       '',
  //       colorText: Colors.red,
  //       backgroundColor: Colors.white,
  //     );
  //   }
  // }

  Future<void> addToCart(productId, qty, variationId, index) async {
    // If a request is already running, add to queue
    if (isProcessing) {
      cartQueue.add({
        'productId': productId,
        'qty': qty,
        'variationId': variationId,
        'selectedIndex': index,
      });
      return;
    }

    isProcessing = true;
    addToBasket.value = true;
    selectedd.value = index;
    try {
      var added = await ApiClass().addToCart(productId, qty, variationId);

      // if (added == null) {
      //   // No response → requeue
      //   cartQueue.add({
      //     'productId': productId,
      //     'qty': qty,
      //     'variationId': variationId,
      //   });
      // } else

      print("product add response processs: ${added}");
      if (added['success'] != true) {
        addToBasket.value = false;
        // API responded but failed

        Get.snackbar(
          added['message'] ?? "Failed to add to cart",
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      } else {
        print("cart updateddd : ${added['cart_items'].length}");
        cartModel.value = CartModel.fromJson(added);
        print("cartitem length : ${cartModel.value.cartItems?.length}");
        cartCount.value = cartModel.value.cartItems?.length ?? 0;
        addToBasket.value = false;
      }
    } on TimeoutException catch (_) {
      addToBasket.value = false;
      // Timeout → queue it again
      // cartQueue.add({
      //   'productId': productId,
      //   'qty': qty,
      //   'variationId': variationId,
      // });
      // Get.snackbar(
      //   "Network timeout",
      //   "Product added to queue. Will retry automatically.",
      //   colorText: Colors.orange,
      //   backgroundColor: Colors.white,
      // );
    } catch (e) {
      print("Error : $e");
      addToBasket.value = false;
      Get.snackbar(
        "Error",
        "Something went wrong.",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } finally {
      addToBasket.value = false;
      isProcessing = false;

      // ✅ Start queue processing
      await _processQueue();
    }
  }

  Future<void> _processQueue() async {
    // Process all queued items sequentially
    while (cartQueue.isNotEmpty) {
      final item = cartQueue.removeAt(0);
      isProcessing = true;
      try {
        selectedd.value = item['selectedIndex'];
        addToBasket.value = true;
        var added = await ApiClass()
            .addToCart(item['productId'], item['qty'], item['variationId'])
            .timeout(const Duration(seconds: 10));
        print("product add response in processs: ${added}");
        if (added == null || added['success'] != true) {
          addToBasket.value = false;
          Get.snackbar(
            added?['message'] ?? "Retry failed",
            '',
            colorText: Colors.red,
            backgroundColor: Colors.white,
          );
        } else {
          cartModel.value = CartModel.fromJson(added);
          print("cartitem length : ${cartModel.value.cartItems?.length}");
          cartCount.value = cartModel.value.cartItems?.length ?? 0;
        }
      } catch (_) {
        addToBasket.value = false;
        // If even retry fails, you can decide whether to requeue or skip
        continue;
      } finally {
        addToBasket.value = false;
        isProcessing = false;
      }
    }

    // ✅ When queue is completely empty, call findCart() once
    // findCart();
  }

  Widget holidayCard() {
    String? start = notificationDetail.value.startDate;
    String? end = notificationDetail.value.endDate;

    DateTime? startDate = DateTime.tryParse(start ?? "");
    DateTime? endDate = DateTime.tryParse(end ?? "");

    if (startDate == null || endDate == null) {
      return const SizedBox(); // Hide widget or handle UI safely
    }

    DateTime now = DateTime.now();
    bool shouldShow =
        notificationDetail.value.active == true &&
        now.isAfter(startDate) &&
        now.isBefore(endDate);
    if (!shouldShow) {
      return const SizedBox(); // Hidden
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none, // 👈 This stops clipping
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.yellowColor.withOpacity(0.25),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.nakedSyrup, width: 2),
            ),
            child: Center(
              child: Text(
                notificationDetail.value.text.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),

          notificationDetail.value.image != null &&
                  notificationDetail.value.image.toString().isNotEmpty == true
              ? Positioned(
                top: -20,
                right: -15,
                child: Image.network(
                  notificationDetail.value.image.toString(),
                  width: 50,
                ),
              )
              : const SizedBox(),
        ],
      ),
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit

    getName();
    print("name : ${name.value}");
    String token = "";

    SharedPreferences.getInstance().then((prefs) {
      token = prefs.getString('token') ?? "";
    });
    if (token.isNotEmpty) {
      holidayNotification();
    }

    super.onInit();
  }
}
