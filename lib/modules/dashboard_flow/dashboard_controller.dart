import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:naked_syrups/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Resources/AppColors.dart';
import '../../model/category_model.dart';
import '../../model/dashboard_list.dart';
import '../../model/order_history_model.dart';
import '../../model/product_model.dart';
import '../../model/shipping_methods_model.dart';
import '../../service.dart';
import '../cart/cart_page.dart';
import '../login_flow/login_page.dart';
import 'dashboard.dart';

class DashboardController extends GetxController {
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> shippingAddressFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerationForm = GlobalKey<FormState>();
  RxBool getData = false.obs;
  RxBool placeOrder = false.obs;
  RxBool getProduct = false.obs;
  RxInt cartCount = 0.obs;
  RxDouble recaptchaHeight = 500.0.obs;
  RxBool getCart = false.obs;
  RxBool isCaptchaVerified = false.obs;
  RxBool isVerifying = false.obs;
  RxBool isImageChallengeLikelyVisible = false.obs;
  RxBool getShipping = false.obs;
  RxBool getCheckOut = false.obs;
  RxBool differentAddress = false.obs;
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
  CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  Rx<DashboardList> dashboardList = DashboardList().obs;
  RxMap<String, dynamic> countryMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> stateMap = <String, dynamic>{}.obs;
  RxMap<String, dynamic> stateMapDiff = <String, dynamic>{}.obs;
  List newsletter = ['Distributor/Roaster', 'Café/Restaurant', 'Home'];
  Rx<ProductModel> productModel = ProductModel().obs;
  Rx<CartModel> cartModel = CartModel().obs;
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

  getShippingMethods() async {
    getShipping.value = true;
    var shipping;
    if (differentAddress.value) {
      shipping = await ApiClass().shippingMethods(
        selectedCountryDiff.value,
        selectedStateDiff.value,
        postCodeDiffController.text,
        townDiffController.text,
      );
    } else {
      shipping = await ApiClass().shippingMethods(
        selectedCountry.value,
        selectedState.value,
        postCodeController.text,
        townController.text,
      );
    }
    if (shipping != null) {
      if (shipping['success'] == true) {
        shippingMethodsModel.value = ShippingMethodsModel.fromJson(shipping);
        // Get.to(ShippingDetailsPage());
        getShipping.value = false;
      } else {
        getShipping.value = false;
        Get.snackbar(
          shipping['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      getShipping.value = false;
      Get.snackbar(
        "Quantity update error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  placeOrderApi() async {
    placeOrder.value = true;
    // print(
    //   "addressFormKey validation : ${addressFormKey.currentState?.validate()}",
    // );
    // print(
    //   "addressFormKey validation : ${shippingAddressFormKey.currentState?.validate()}",
    // );
    Map<String, dynamic> mapp = {};
    if (differentAddress.value) {
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
          "po_number": postCodeController.text,
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
        "payment_method": "cod",
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
          "po_number": postCodeController.text,
        },
        "use_shipping": "no",
        "payment_method": "cod",
        "shipping_method": shippingMethods.value,
        "order_notes": orderNotesController.text,
      };
    }

    var shipping = await ApiClass().orderPlaced(mapp);
    if (shipping != null) {
      if (shipping['success'] == true) {
        Get.snackbar(
          shipping['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
        showDialog<void>(
          context: Get.context!,
          barrierDismissible: false,
          // user must tap button!
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(
                    "Thank you for your order!",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  content: const SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      "Your order has been successfully placed. We’ll notify you once it’s on the way.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
                        Get.offAll(const DashboardPage());
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
        // Get.to(OrderHistoryPage());
        placeOrder.value = false;
      } else {
        placeOrder.value = false;
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
    name.value = prefs.getString('name') ?? "";
  }

  Widget cartUI() {
    return Obx(
      () => Stack(
        children: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, size: 30),
            onPressed: () {
              Get.to(CartPage()); // Navigate to cart page
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
      ),
    );
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
    var respose = await ApiClass().getState(code);

    Map<String, dynamic> jsonResponse = respose;
    Map<String, String> parsedCountries = {};
    if (jsonResponse['states'] == false) {
    } else {
      if (jsonResponse['states'].isNotEmpty) {
        parsedCountries = (jsonResponse['states'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value.toString()),
        );
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
    }
    getCheckOut.value = false;
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

    var history = await ApiClass().getOrderHistory();
    if (history != null) {
      orderHistoryModel.value = OrderHistoryModel.fromJson(history);
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

  addToCart(productId, qty, variationId) async {
    addToBasket.value = true;
    var addedd = await ApiClass().addToCart(productId, qty, variationId);
    if (addedd != null) {
      if (addedd['success'] == true) {
        // Get.to(CartPage());
        findCart();
        addToBasket.value = false;
      } else {
        addToBasket.value = false;
        Get.snackbar(
          addedd['message'],
          '',
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } else {
      addToBasket.value = false;
      Get.snackbar(
        "Error..",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit

    getName();
    super.onInit();
  }
}
