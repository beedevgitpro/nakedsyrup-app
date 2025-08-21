import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getT;
import 'package:shared_preferences/shared_preferences.dart';

import 'Resources/AppStrings.dart';

final Dio dio = Dio();
bool _isRefreshing = false;
Completer<void>? _refreshCompleter;

void setupDio() {
  FutureOr<dynamic> refreshToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var decodedResponse = await dioPostApiCall('refresh-token', {});

    if (decodedResponse['success'] == true) {
      if (decodedResponse['token'] != null) {
        await prefs.setString('token', decodedResponse['token']);
      }
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Always attach token before every request
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final requestPath = options.path;
        const excludedPaths = [
          '/wp-json/ns/v1/states',
          '/wp-json/ns/v1/countries',
          '/wp-json/ns/v1/create-customer',
          '/wp-json/ns/v1/login',
        ];
        // Skip token for excluded paths
        final isExcluded = excludedPaths.any(
          (prefix) => requestPath.startsWith(prefix),
        );

        if (!isExcluded && token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        final requestPath = e.requestOptions.path;
        const excludedPaths = [
          '/wp-json/ns/v1/states',
          '/wp-json/ns/v1/countries',
          '/wp-json/ns/v1/create-customer',
          '/wp-json/ns/v1/login',
        ];
        if (e.response?.statusCode == 403 &&
            !excludedPaths.contains(requestPath)) {
          // Token might be invalid

          // Prevent multiple refreshes
          if (!_isRefreshing) {
            _isRefreshing = true;
            _refreshCompleter = Completer();

            try {
              await refreshToken(); // custom refresh function
              _refreshCompleter?.complete();
            } catch (e) {
              _refreshCompleter?.completeError(e);
            } finally {
              _isRefreshing = false;
            }
          } else {
            // Wait for token refresh to complete
            await _refreshCompleter?.future;
          }

          // Retry the original request with new token
          final token = (await SharedPreferences.getInstance()).getString(
            'token',
          );
          final newRequest = e.requestOptions;
          newRequest.headers['Authorization'] = 'Bearer $token';

          final cloneReq = await dio.fetch(newRequest);
          return handler.resolve(cloneReq);
        }

        return handler.next(e);
      },
    ),
  );
}

dynamic afterApiFire(response, apiurl) {
  if (response.statusCode == 200 || response.statusCode == 201) {
    var decodedResponse = response.data;
    print("$apiurl responce : $decodedResponse");
    // if (apiurl == 'get-cart') {
    //   print("$apiurl responce header: ${decodedResponse['headers']['cookie']}");
    //   print("$apiurl responce cokkie: ${decodedResponse['cookies']}");
    // }
    if (decodedResponse != null) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Could not get a valid response.",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  } else {
    getT.Get.snackbar(
      "Technical Error ${response.statusCode}",
      "",
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  }
}

FutureOr<dynamic> dioPostApiCall(apiurl, formData) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    String? token = prefs.getString('token');
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Connection'] = 'keep-alive';
    if (token != null && token.isNotEmpty && apiurl != 'refresh-token') {
      dio.options.headers["Authorization"] = "Bearer $token";
      print("Bearer $token");
    }
    String url = '${AppStrings.baseUrl}$apiurl';
    print("$apiurl URL::$url");
    // if (formData.length > 0) {
    //   print("$apiurl map-post data::${formData.fields}");
    // }
    final response = await dio.post(
      url,
      data:
          apiurl == 'refresh-token'
              ? {'token': prefs.getString('token') ?? ""}
              : formData,
      options: Options(headers: {"Accept": "application/json"}),
    );
    return afterApiFire(response, apiurl);
  } on TimeoutException catch (_) {
    getT.Get.snackbar(
      " TimeoutException or No Internet Connection ",
      '',
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  } on SocketException catch (e) {
    print("SocketException $apiurl $e");
    getT.Get.snackbar(
      "SocketException",
      '',
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  } on DioException catch (e) {
    print("DioException $apiurl $e");
    if (e.type == DioExceptionType.connectionError ||
        e.error.toString().contains("Connection reset")) {
      await Future.delayed(Duration(seconds: 1));
      final retryResponse = await dio.post(
        '${AppStrings.baseUrl}$apiurl',
        data:
            apiurl == 'refresh-token'
                ? {'token': prefs.getString('token') ?? ""}
                : formData,
        options: Options(headers: {"Accept": "application/json"}),
      );
      return afterApiFire(retryResponse, apiurl);
    } else {
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  } on Exception catch (e) {
    print("Exception : $apiurl $e");
    getT.Get.snackbar(
      "Error",
      '',
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  }
}

FutureOr<dynamic> dioGetApiCall(apiurl) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Connection'] = 'keep-alive';
  if (token != null && token.isNotEmpty) {
    dio.options.headers["Authorization"] = "Bearer $token";
    print("Bearer $token");
  }
  try {
    String url = '${AppStrings.baseUrl}$apiurl';

    print("$apiurl URL::$url");
    final response = await dio.get(
      url,
      options: Options(headers: {"Accept": "application/json"}),
    );
    return afterApiFire(response, apiurl);
  } on TimeoutException catch (_) {
    getT.Get.snackbar(
      " TimeoutException or No Internet Connection ",
      '',
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  } on SocketException catch (e) {
    print("SocketException $apiurl $e");
    getT.Get.snackbar(
      "SocketException",
      '',
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  } on DioException catch (e) {
    print("DioException $apiurl $e");
    if (e.type == DioExceptionType.connectionError ||
        e.error.toString().contains("Connection reset")) {
      // Retry once after 1 second
      await Future.delayed(Duration(seconds: 1));
      final retryResponse = await dio.get(
        '${AppStrings.baseUrl}$apiurl',
        options: Options(headers: {"Accept": "application/json"}),
      );
      return afterApiFire(retryResponse, apiurl);
    } else {
      getT.Get.snackbar(
        "Technical Error",
        '',
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
    }
  } on Exception catch (e) {
    print("Exception : $apiurl $e");
    getT.Get.snackbar(
      "Error",
      '',
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  }
}

class ApiClass {
  FutureOr<dynamic> accessPay() async {
    var decodedResponse = await dioPostApiCall('pay-by-account-access', {});

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> resetPass(email) async {
    Map<String, dynamic> mappp = {};
    mappp = {'email': email};
    FormData formData = FormData.fromMap(mappp);

    var decodedResponse = await dioPostApiCall(
      'reset-password-request',
      formData,
    );

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> loginApi(email, password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> mappp = {};
    mappp = {"username": email, "password": password};
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('login', formData);

    if (decodedResponse['success'] == true) {
      await prefs.setString("token", decodedResponse['token']);
      await prefs.setString("name", decodedResponse['user']['name']);
      await prefs.setInt("user_id", decodedResponse['user']['id']);
      await prefs.setString(
        "pay_by_account",
        decodedResponse['user']['pay_by_account'],
      );
      await prefs.setString(
        "has_app_access",
        decodedResponse['user']['has_app_access'],
      );
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error ${decodedResponse['message']}",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> addToCart(productId, qty, variationId) async {
    Map<String, dynamic> mappp = {};
    mappp = {
      "product_id": productId,
      "quantity": qty,
      'variation_id': variationId,
    };
    print("Mapp add-to cart :${mappp}");
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('add-to-cart', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> updateQuantity(productId, qty, variationId) async {
    Map<String, dynamic> mappp = {};
    mappp = {
      "product_id": productId,
      "quantity": qty,
      'variation_id': variationId,
    };
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('cart/update', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> shippingMethods(country, state, postcode, city) async {
    Map<String, dynamic> mappp = {};
    mappp = {
      "country": country,
      "state": state,
      "postcode": postcode,
      "city": city,
    };
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('shipping-methods', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> orderPlaced(mapp) async {
    FormData formData = FormData.fromMap(mapp);
    var decodedResponse = await dioPostApiCall('checkout', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> updateProfile(mapp) async {
    // FormData formData = FormData.fromMap(mapp);
    var decodedResponse = await dioPostApiCall('edit-profile', mapp);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> applyCoupon(coupon) async {
    Map<String, dynamic> mappp = {};
    mappp = {'coupon_code': coupon};
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('apply-coupon', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> removeCoupon(coupon) async {
    Map<String, dynamic> mappp = {};
    mappp = {'coupon_code': coupon};
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('remove-coupon', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> deleteItems(productId) async {
    Map<String, dynamic> mappp = {};
    mappp = {"product_id": productId};
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('cart/delete', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> customerCreate(mapp) async {
    var decodedResponse = await dioPostApiCall('create-customer', mapp);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      if (decodedResponse['message'] != null) {
        getT.Get.snackbar(
          "Error ${decodedResponse['message']}",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      } else {
        getT.Get.snackbar(
          "Error $decodedResponse",
          "",
          colorText: Colors.red,
          backgroundColor: Colors.white,
        );
      }
      return null;
    }
  }

  FutureOr<dynamic> getCategory() async {
    var decodedResponse = await dioGetApiCall('categories');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> mostViewedProduct() async {
    var decodedResponse = await dioGetApiCall(
      'most-viewed-products?limit=10&page=1',
    );

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getCart() async {
    var decodedResponse = await dioPostApiCall('get-cart', {});

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> deleteAccount() async {
    var decodedResponse = await dioPostApiCall('deactivate-account', {});

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getBillingDetails() async {
    var decodedResponse = await dioGetApiCall('billing-details');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getProfileDetails() async {
    var decodedResponse = await dioGetApiCall('get-profile');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getCountry() async {
    var decodedResponse = await dioGetApiCall('countries');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getState(code) async {
    var decodedResponse = await dioGetApiCall('states?country=$code');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getOrderHistory() async {
    var decodedResponse = await dioGetApiCall('order-history');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  FutureOr<dynamic> getProductFromCategory(slug) async {
    var decodedResponse = await dioGetApiCall('products?category=$slug');

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        "Error $decodedResponse",
        "",
        colorText: Colors.red,
        backgroundColor: Colors.white,
      );
      return null;
    }
  }

  Future<void> verifyCaptcha(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await dio.post(
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

  FutureOr verifyCaptchaToken(String token) async {
    try {
      String url = 'https://www.nakedsyrups.com.au/verify-recaptcha.php';
      print("verify captch URL::$url :: $token");
      FormData formData = FormData.fromMap({'token': token});
      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );
      print("verify captcha : ${response}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = response.data;
        print("verify captcha responce : $decodedResponse");
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

      print("DioError:$e");
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
