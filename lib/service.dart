import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getT;
import 'package:shared_preferences/shared_preferences.dart';

import 'Resources/AppStrings.dart';

class ApiClass {
  FutureOr<dynamic> loginApi(email, password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> mappp = {};
      mappp = {"username": email, "password": password};
      String url = '${AppStrings.baseUrl}login';
      print("Login URL::$url");
      print("Login URL:: $mappp::");
      FormData formData = FormData.fromMap(mappp);
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );
      print("status code : ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("login api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          await prefs.setString("token", decodedResponse['token']);
          await prefs.setString("name", decodedResponse['user']['name']);
          await prefs.setInt("user_id", decodedResponse['user']['id']);
          await prefs.setString(
            "pay_by_account",
            decodedResponse['user']['pay_by_account'],
          );
        }
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> addToCart(productId, qty, variationId) async {
    try {
      Map<String, dynamic> mappp = {};
      mappp = {
        "product_id": productId,
        "quantity": qty,
        'variation_id': variationId,
      };
      String url = '${AppStrings.baseUrl}add-to-cart';
      print("Add to cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('token') ?? " ";
      print("token : $token");
      print("Add to cart URL:: $mappp::");
      FormData formData = FormData.fromMap(mappp);
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("add to cart api responce : $decodedResponse");

        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> accessPay() async {
    try {
      String url = '${AppStrings.baseUrl}pay-by-account-access';
      print("pay-by-account-access::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String token = prefs.getString('token') ?? " ";
      print("token : $token");
      final response = await Dio().post(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("pay-by-account-access responce : $decodedResponse");

        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> updateQuantity(productId, qty, variationId) async {
    try {
      Map<String, dynamic> mappp = {};
      mappp = {
        "product_id": productId,
        "quantity": qty,
        'variation_id': variationId,
      };
      // https://nakedsyrups.com.au/wp-json/ns/v1/add-to-cart
      String url = '${AppStrings.baseUrl}cart/update';
      print("Add to cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");
      print("update quantity URL:: $mappp::");
      FormData formData = FormData.fromMap(mappp);
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      print("update quantitit : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("update quantity api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> shippingMethods(country, state, postcode, city) async {
    try {
      Map<String, dynamic> mappp = {};
      mappp = {
        "country": country,
        "state": state,
        "postcode": postcode,
        "city": city,
      };
      String url = '${AppStrings.baseUrl}shipping-methods';
      print("Add to cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      print("token : $token");
      print("update quantity URL:: $mappp::");
      final response = await Dio().post(
        url,
        data: mappp,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      print("update quantity : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("update quantity api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr verifyCaptchaToken(String token) async {
    try {
      String url = 'https://www.nakedsyrups.com.au/verify-recaptcha.php';
      print("verify captch URL::$url :: $token");
      FormData formData = FormData.fromMap({'token': token});
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );
      print("verify captch : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("checkout api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      print("$e");
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> orderPlaced(mapp) async {
    try {
      String url = '${AppStrings.baseUrl}checkout';
      print("Add to cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      print("token : $token");
      print("checkout URL:: $mapp::");
      final response = await Dio().post(
        url,
        data: mapp,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      print("checkout : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("checkout api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> applyCoupon(coupon) async {
    try {
      String url = '${AppStrings.baseUrl}apply-coupon';
      print("Add to cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      FormData formData = FormData.fromMap({'coupon_code': coupon});
      print("checkout URL:: $coupon::");
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      print("checkout : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("checkout api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e $e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> removeCoupon(coupon) async {
    try {
      String url = '${AppStrings.baseUrl}remove-coupon';
      print("Add to cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? "";
      FormData formData = FormData.fromMap({'coupon_code': coupon});
      print("checkout URL:: $coupon::");
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      print("checkout : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("checkout api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e $e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> customerCreate(mapp) async {
    try {
      String url = '${AppStrings.baseUrl}create-customer';
      print("Add to cart URL::$url");

      print("checkout URL:: $mapp::");
      final response = await Dio().post(
        url,
        data: mapp,
        options: Options(headers: {"Accept": "application/json"}),
      );
      print("checkout : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("checkout api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      print("$e");
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> deleteItems(productId) async {
    try {
      Map<String, dynamic> mappp = {};
      mappp = {"product_id": productId};
      String url = '${AppStrings.baseUrl}cart/delete';
      print("delete cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");
      print("delete cart URL:: $mappp::");
      FormData formData = FormData.fromMap(mappp);
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("delete cart api responce : $decodedResponse");
        return decodedResponse;
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> getCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String url = '${AppStrings.baseUrl}categories';
      print("Category URL::$url");
      final response = await Dio().get(
        url,
        options: Options(headers: {"Accept": "application/json"}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("Category api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> mostViewedProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String url = '${AppStrings.baseUrl}most-viewed-products?limit=10&page=1';
      print("most viewed URL::$url");
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("most viewed api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> getCart() async {
    try {
      String url = '${AppStrings.baseUrl}get-cart';
      print("get cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");

      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("get cart api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> getBillingDetails() async {
    try {
      String url = '${AppStrings.baseUrl}billing-details';
      print("get cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");

      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("get cart api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> getCountry() async {
    try {
      String url = '${AppStrings.baseUrl}countries';
      print("get cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");

      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            // 'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("get cart api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> getState(code) async {
    try {
      String url = '${AppStrings.baseUrl}states?country=$code';
      print("get cart URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");

      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            // 'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("get cart api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  Future<void> verifyCaptcha(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await Dio().post(
      "https://www.nakedsyrups.com.au/verify-recaptcha.php",
      options: Options(
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      ),
      data: {'token': token},
    );

    if (response.statusCode == 200) {
      final json = response.data;
      if (json['success']) {
        print("CAPTCHA verified ✅");
      } else {
        print("CAPTCHA failed ❌");
      }
    } else {
      print("Server error");
    }
  }

  FutureOr<dynamic> getOrderHistory() async {
    try {
      String url = '${AppStrings.baseUrl}order-history';
      print("order history URL::$url");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? " ";
      print("token : $token");

      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer ${prefs.getString('token')}',
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("order history api responce : $decodedResponse");
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print(e);
      getT.Get.snackbar(
        "SocketException",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  FutureOr<dynamic> getProductFromCategory(slug) async {
    try {
      String url = '${AppStrings.baseUrl}products?category=$slug';
      print("Category URL::$url");
      final response = await Dio().get(
        url,
        options: Options(headers: {"Accept": "application/json"}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        if (decodedResponse['success'] == true) {
          return decodedResponse;
        }
      } else {
        getT.Get.snackbar(
          "Technical Error",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
    } on TimeoutException catch (_) {
      getT.Get.snackbar(
        "No Internet Connection",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on SocketException catch (e) {
      print("SocketException $e");
      getT.Get.snackbar(
        "SocketException ",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    } on DioException catch (e) {
      getT.Get.snackbar(
        "Technical Error $e",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );

      print("DioError:e $e");
    } on Exception catch (e) {
      print("Error : $e");
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }
}
