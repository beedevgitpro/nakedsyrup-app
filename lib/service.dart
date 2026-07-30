import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getT;
import 'package:shared_preferences/shared_preferences.dart';

import 'Resources/AppStrings.dart';
import 'modules/login_flow/login_page.dart';
import 'network_helper.dart';

final Dio dio = Dio(
  BaseOptions(followRedirects: true, extra: {"withCredentials": true}),
);

CancelToken _cancelToken = CancelToken();
bool _isRefreshing = false;
bool _isLoggingOut = false;
bool _sessionActive = false;
bool _sessionExpiredSnackShown = false;
Completer<void>? _refreshCompleter;

const String _sessionExpiredTitle = 'Session expired';
const String _sessionExpiredSubtitle =
    'Please sign in again to continue.';

void _resetCancelToken() {
  _cancelToken = CancelToken();
}

/// Paths that must never trigger refresh or force-logout (login, refresh, public).
bool _isAuthFreePath(String path) {
  const markers = [
    '/login',
    '/refresh-token',
    '/reset-password-request',
    '/states',
    '/countries',
    '/create-customer',
  ];
  return markers.any((m) => path.contains(m));
}

bool _hasValidSessionToken(String? token) =>
    token != null && token.isNotEmpty;

void _logAuth(String message) {
  print('[Auth] $message');
}

void _showSessionExpiredSnackbar() {
  if (_sessionExpiredSnackShown) return;
  _sessionExpiredSnackShown = true;
  getT.Get.snackbar(
    _sessionExpiredTitle,
    _sessionExpiredSubtitle,
    colorText: Colors.red,
    backgroundColor: Colors.white,
    duration: const Duration(seconds: 4),
  );
  _logAuth('session expired snack bar shown');
}

void _resetSessionExpiredSnackbarFlag() {
  _sessionExpiredSnackShown = false;
}

bool _isSessionExpiryError(DioException e) {
  if (e.response?.statusCode == 401) return true;
  if (e.type == DioExceptionType.cancel) {
    final msg = e.message ?? '';
    return msg.contains('Session expired');
  }
  return false;
}

void _clearDioAuthHeader() {
  dio.options.headers.remove('Authorization');
}

Future<void> _markSessionActive(bool active) async {
  _sessionActive = active;
  _logAuth('sessionActive=$active');
}

Future<void> initAuthSessionFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  await _markSessionActive(_hasValidSessionToken(token));
}

void setupDio() {
  initAuthSessionFromPrefs();

  FutureOr<dynamic> refreshToken() async {
    if (_isLoggingOut || !_sessionActive) {
      _logAuth(
        'refresh skipped (loggingOut=$_isLoggingOut sessionActive=$_sessionActive)',
      );
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (!_hasValidSessionToken(token)) {
      _logAuth('refresh skipped (no token in prefs)');
      return null;
    }

    final url = '${AppStrings.baseUrl}refresh-token';
    _logAuth('refresh POST start: $url');

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['token'] != null) {
          await prefs.setString('token', data['token']);
          _logAuth('refresh succeeded, token updated');
        } else {
          _logAuth('refresh response not successful: $data');
        }
        return data;
      }
      _logAuth('refresh unexpected status: ${response.statusCode}');
    } on DioException catch (e) {
      _logAuth(
        'refresh failed status=${e.response?.statusCode} type=${e.type} message=${e.message}',
      );
      if (e.response?.statusCode == 401 &&
          !_isLoggingOut &&
          _sessionActive) {
        await _forceLogout(reason: 'refresh-token returned 401');
      }
    }
    return null;
  }

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final path = options.uri.path;
        final isAuthFree = _isAuthFreePath(path);

        /// Only authenticated traffic shares the session cancel token.
        if (!isAuthFree) {
          options.cancelToken = _cancelToken;
        }

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        options.headers.remove('Authorization');
        if (!isAuthFree && _hasValidSessionToken(token)) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        _logAuth(
          'onRequest ${options.method} $path authFree=$isAuthFree hasToken=${_hasValidSessionToken(token)} sessionActive=$_sessionActive',
        );

        /// ✅ Check REAL internet connection
        final hasInternet = await NetworkHelper.hasInternet();

        if (!hasInternet) {
          /// ✅ Show dialog
          NetworkHelper.showNoInternetDialog();

          /// ❌ Stop API call
          return handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: 'No Internet Connection',
            ),
          );
        }

        /// ✅ Continue request
        return handler.next(options);
      },

      onError: (DioException e, handler) async {
        final path = e.requestOptions.uri.path;
        final isAuthFree = _isAuthFreePath(path);
        final status = e.response?.statusCode;

        _logAuth(
          'onError ${e.requestOptions.method} $path status=$status type=${e.type} authFree=$isAuthFree sessionActive=$_sessionActive',
        );

        if (e.type == DioExceptionType.cancel) {
          _logAuth('request cancelled: ${e.message}');
          return handler.next(e);
        }

        /// 401 on protected routes → logout (never on login/refresh/public).
        if (status == 401 &&
            !_isLoggingOut &&
            _sessionActive &&
            !isAuthFree) {
          await _forceLogout(reason: '401 on $path');
          return;
        }

        /// 403 → refresh only for an active session with a stored token.
        if (status == 403 &&
            !isAuthFree &&
            _sessionActive &&
            !_isLoggingOut) {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (!_hasValidSessionToken(token)) {
            _logAuth('403 refresh skipped (no token)');
            return handler.next(e);
          }

          if (!_isRefreshing) {
            _isRefreshing = true;
            _refreshCompleter = Completer();

            try {
              await refreshToken();
              _refreshCompleter?.complete();
            } catch (err) {
              _refreshCompleter?.completeError(err);
            } finally {
              _isRefreshing = false;
            }
          } else {
            await _refreshCompleter?.future;
          }

          final newToken = (await SharedPreferences.getInstance()).getString(
            'token',
          );

          if (_hasValidSessionToken(newToken) && _sessionActive) {
            _logAuth('retrying after refresh: $path');
            final newRequest = e.requestOptions;
            newRequest.headers['Authorization'] = 'Bearer $newToken';
            return handler.resolve(await dio.fetch(newRequest));
          }
          _logAuth('retry skipped after refresh (no valid token)');
        }

        return handler.next(e);
      },
    ),
  );
}

Future<void> _forceLogout({String reason = 'unknown'}) async {
  if (_isLoggingOut) {
    _logAuth('forceLogout ignored (already in progress) reason=$reason');
    return;
  }
  _isLoggingOut = true;
  await _markSessionActive(false);

  _logAuth('FORCE LOGOUT start → cancel session APIs reason=$reason');

  _showSessionExpiredSnackbar();

  _cancelToken.cancel('Session expired: $reason');

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  _clearDioAuthHeader();
  _resetCancelToken();

  getT.Get.offAll(() => LoginPage());

  _isLoggingOut = false;
  _logAuth('FORCE LOGOUT complete');
}

dynamic afterApiFire(response, apiurl) async {
  if (response.statusCode == 200 || response.statusCode == 201) {
    var decodedResponse = response.data;
    print("$apiurl responce : $decodedResponse");

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
  } else if (response.statusCode == 400) {
    var decodedResponse = response.data;
    print("$apiurl responce with code 400 : $decodedResponse");
  } else if (response.statusCode == 401) {
    _logAuth('afterApiFire 401 on $apiurl (handled by session logout)');
    return null;
  } else if (
  response.statusCode == 400
  ) {
    var decodedResponse =
        response.data;

    print("status code 400 : error msg : ${decodedResponse}");
    getT.Get.snackbar(
      "Technical Error ${response.statusCode}",
      "Error : $decodedResponse",
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  }  else {
    getT.Get.snackbar(
      "Technical Error ${response.statusCode}",
      "",
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
  }
}

// Future<String> buildUserAgent() async {
//   final deviceInfo = DeviceInfoPlugin();
//   String appVersion = AppStrings.version;
//   String appName = "MyFlutterApp";
//
//   if (Platform.isAndroid) {
//     final androidInfo = await deviceInfo.androidInfo;
//     return '$appName/$appVersion (Android ${androidInfo.version.release}; ${androidInfo.model})';
//   } else if (Platform.isIOS) {
//     final iosInfo = await deviceInfo.iosInfo;
//     return '$appName/$appVersion (iOS ${iosInfo.systemVersion}; ${iosInfo.utsname.machine})';
//   } else if (Platform.isMacOS) {
//     final macInfo = await deviceInfo.macOsInfo;
//     return '$appName/$appVersion (macOS ${macInfo.osRelease}; ${macInfo.model})';
//   } else {
//     return '$appName/$appVersion (Unknown Platform)';
//   }
// }

Future<dynamic> dioPostApiCall(String apiurl, dynamic body) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final isLogin = apiurl == 'login';

  // if (apiurl != 'login') {
  //   if (jsonDecode(prefs.getString('woocommerce_session_cookie') ?? "") != "" &&
  //       jsonDecode(prefs.getString('woocommerce_session_cookie') ?? "") !=
  //           false) {
  //     String? cookieHash = prefs.getString('cookie_hash');
  //     final List<dynamic>? cookieList = jsonDecode(
  //       prefs.getString('woocommerce_session_cookie') ?? "",
  //     );
  //     final cookieValue = cookieList?.join('|') ?? '';
  //     final cookieHeader = "wp_woocommerce_session_$cookieHash=$cookieValue";
  //     dio.options.headers['Cookie'] = cookieHeader;
  //   }
  // }
print("token $token");
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': "MyFlutterApp/1.0 (Android)",
    if (!isLogin &&
        apiurl != 'refresh-token' &&
        _hasValidSessionToken(token))
      'Authorization': 'Bearer $token',
  };

  final url =
      apiurl == 'extra-fees'
          ? '${AppStrings.extraFeesUrl}$apiurl'
          : '${AppStrings.baseUrl}$apiurl';
  _logAuth('dioPostApiCall $apiurl (login=$isLogin hasToken=${_hasValidSessionToken(token)})');

  try {
    final response = await dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
    print("$apiurl responce : $response");
    return afterApiFire(response, apiurl);
  } on DioException catch (e) {
    if (_isSessionExpiryError(e) || _isLoggingOut) {
      _logAuth('dioPostApiCall session ended: $apiurl');
      return null;
    }
    _logAuth(
      'dioPostApiCall DioException: $apiurl type=${e.type} status=${e.response?.statusCode}',
    );
    getT.Get.snackbar(
      "Technical Error",
      "",
      colorText: Colors.red,
      backgroundColor: Colors.white,
    );
    return null;
  }
}

Future<Map<String, dynamic>?> dioPaypalPostApiCall(
    String apiurl,
    Map<String, dynamic> body,
    ) async {
  final SharedPreferences prefs =
  await SharedPreferences.getInstance();

  final String? token = prefs.getString('token');
  final String guestToken =
      prefs.getString('guest_token') ?? '';

  final Map<String, dynamic> requestBody =
  Map<String, dynamic>.from(body);

  /*
   * The WordPress backend uses the same guest token that was
   * established for the app cart and checkout.
   */
  if (guestToken.isNotEmpty) {
    requestBody['guest_token'] = guestToken;
  }

  final Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'MyFlutterApp/1.0 (Android)',
  };

  /*
   * The existing Dio interceptor will also apply the token.
   * Setting it here makes the PayPal request explicit and safe
   * even if this helper is called before an interceptor refresh.
   */
  if (_hasValidSessionToken(token)) {
    headers['Authorization'] = 'Bearer $token';
  }

  final String url =
      '${AppStrings.baseUrl}$apiurl';

  _logAuth(
    'dioPaypalPostApiCall $apiurl '
        'hasToken=${_hasValidSessionToken(token)} '
        'hasGuestToken=${guestToken.isNotEmpty}',
  );

  try {
    final Response<dynamic> response =
    await dio
        .post(
      url,
      data: requestBody,
      options: Options(
        headers: headers,

        /*
                 * PayPal endpoints intentionally return responses such as:
                 *
                 * 409 PAYPAL_ORDER_NOT_APPROVED
                 * 409 PAYPAL_CAPTURE_AMOUNT_MISMATCH
                 *
                 * These must reach the controller rather than being
                 * converted into a generic Dio exception.
                 */
        validateStatus: (status) {
          return status != null &&
              status >= 200 &&
              status < 500;
        },
      ),
    )
        .timeout(
      const Duration(seconds: 45),
    );

    final dynamic responseData = response.data;

    Map<String, dynamic> decodedResponse;

    if (responseData is Map<String, dynamic>) {
      decodedResponse =
      Map<String, dynamic>.from(responseData);
    } else if (responseData is Map) {
      decodedResponse =
      Map<String, dynamic>.from(responseData);
    } else if (responseData is String) {
      final dynamic decoded =
      jsonDecode(responseData);

      if (decoded is Map) {
        decodedResponse =
        Map<String, dynamic>.from(decoded);
      } else {
        return {
          'success': false,
          'message':
          'Invalid response from the payment server.',
          'http_status': response.statusCode,
        };
      }
    } else {
      return {
        'success': false,
        'message':
        'Invalid response from the payment server.',
        'http_status': response.statusCode,
      };
    }

    decodedResponse['http_status'] =
        response.statusCode;

    print(
      '$apiurl response: $decodedResponse',
    );

    return decodedResponse;
  } on TimeoutException {
    _logAuth(
      'PayPal request timed out: $apiurl',
    );

    return {
      'success': false,
      'code': 'PAYPAL_REQUEST_TIMEOUT',
      'message':
      'The PayPal request took too long to complete.',
    };
  } on DioException catch (e) {
    if (
    _isSessionExpiryError(e) ||
        _isLoggingOut
    ) {
      _logAuth(
        'PayPal request ended with session expiry: $apiurl',
      );

      return {
        'success': false,
        'code': 'SESSION_EXPIRED',
        'message':
        'Your session has expired. Please sign in again.',
      };
    }

    _logAuth(
      'PayPal DioException: '
          '$apiurl '
          'status=${e.response?.statusCode} '
          'type=${e.type} '
          'message=${e.message}',
    );

    final dynamic errorData =
        e.response?.data;

    if (errorData is Map) {
      final Map<String, dynamic> response =
      Map<String, dynamic>.from(errorData);

      response['success'] =
          response['success'] == true;

      response['http_status'] =
          e.response?.statusCode;

      return response;
    }

    return {
      'success': false,
      'code': 'PAYPAL_CONNECTION_ERROR',
      'message':
      'Unable to connect to the PayPal payment service.',
      'http_status':
      e.response?.statusCode,
    };
  } on FormatException catch (e) {
    _logAuth(
      'PayPal invalid JSON: $apiurl $e',
    );

    return {
      'success': false,
      'code': 'PAYPAL_INVALID_RESPONSE',
      'message':
      'The payment server returned an invalid response.',
    };
  } catch (e) {
    _logAuth(
      'PayPal unexpected error: $apiurl $e',
    );

    return {
      'success': false,
      'code': 'PAYPAL_UNKNOWN_ERROR',
      'message':
      'Unable to process the PayPal request.',
    };
  }
}

FutureOr<dynamic> dioGetApiCall(apiurl) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Connection'] = 'keep-alive';
  dio.options.headers['User-Agent'] = "MyFlutterApp/1.0 (Android)";
  _clearDioAuthHeader();
  if (_hasValidSessionToken(token)) {
    dio.options.headers["Authorization"] = "Bearer $token";
    print("Bearer $token");
  }

  // if (jsonDecode(prefs.getString('woocommerce_session_cookie') ?? "") != "" &&
  //     jsonDecode(prefs.getString('woocommerce_session_cookie') ?? "") !=
  //         false) {
  //   String? cookieHash = prefs.getString('cookie_hash');
  //   final List<dynamic>? cookieList = jsonDecode(
  //     prefs.getString('woocommerce_session_cookie') ?? "",
  //   );
  //   final cookieValue = cookieList?.join('|') ?? '';
  //   final cookieHeader = "wp_woocommerce_session_$cookieHash=$cookieValue";
  //   dio.options.headers['Cookie'] = cookieHeader;
  // }
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
    if (_isSessionExpiryError(e) || _isLoggingOut) {
      _logAuth('dioGetApiCall session ended: $apiurl');
      return null;
    }
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
  ApiClass() {}

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

    if (decodedResponse == null) {
      _logAuth('login aborted (request cancelled or failed)');
      return null;
    }

    if (decodedResponse['success'] == true) {
      await prefs.setString("token", decodedResponse['token']);
      await _markSessionActive(true);
      _resetSessionExpiredSnackbarFlag();
      _logAuth('login succeeded, session marked active');
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
      // if (decodedResponse['woocommerce_session_cookie'] != null &&
      //     decodedResponse['woocommerce_session_cookie'] != false) {
      //   await prefs.setString(
      //     "woocommerce_session_cookie",
      //     jsonEncode(decodedResponse['woocommerce_session_cookie']),
      //   );
      // }
      // if (decodedResponse['cookie_hash'] != null) {
      //   await prefs.setString("cookie_hash", decodedResponse['cookie_hash']);
      // }
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

  Future<dynamic> addToCart(productId, qty, variationId) async {
    Map<String, dynamic> mappp = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    mappp = {
      "product_id": productId,
      "quantity": qty,
      'variation_id': variationId,
    };
    print("Mapp add-to cart :${mappp}");
    String? guestToken = "";
    guestToken = prefs.getString("guest_token");
    mappp.addIf(
      prefs.getString("guest_token") != null &&
          prefs.getString("guest_token")?.isNotEmpty == true,
      'guest_token',
      guestToken,
    );

    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('add-to-cart', formData);

    if (decodedResponse['success'] == true) {
      if ((decodedResponse).containsKey('guest_token') &&
          decodedResponse['guest_token'] != null) {

        await prefs.setString("guest_token", decodedResponse['guest_token']);
        print("Found guest_token");
      }
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? guestToken = "";
    guestToken = prefs.getString("guest_token");
    Map<String, dynamic> mappp = {
      'product_id': productId,
      'quantity': qty,
      'variation_id': variationId,
    };

    if (guestToken != null &&
        guestToken.isNotEmpty) {
      mappp['guest_token'] = guestToken;
    }
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

  Future<Map<String, dynamic>?>
  capturePaypalOrder({
    required int wooCommerceOrderId,
    required String paypalOrderId,
  }) async {
    if (wooCommerceOrderId <= 0) {
      return {
        'success': false,
        'code': 'INVALID_WC_ORDER_ID',
        'message':
        'A valid WooCommerce order ID is required.',
      };
    }

    final String cleanPaypalOrderId =
    paypalOrderId.trim();

    if (cleanPaypalOrderId.isEmpty) {
      return {
        'success': false,
        'code': 'INVALID_PAYPAL_ORDER_ID',
        'message':
        'A valid PayPal order ID is required.',
      };
    }

    final Map<String, dynamic> request = {
      'wc_order_id': wooCommerceOrderId,
      'orderID': cleanPaypalOrderId,
    };

    final Map<String, dynamic>? response =
    await dioPaypalPostApiCall(
      'capture-order',
      request,
    );

    if (response == null) {
      return {
        'success': false,
        'code': 'CAPTURE_NO_RESPONSE',
        'message':
        'No response was received while confirming the PayPal payment.',
      };
    }

    print(
      'capture-order response: $response',
    );

    /*
   * Do not turn backend 409 responses into null.
   *
   * The WebView/controller must inspect:
   *
   * response['success']
   * response['status']
   * response['code']
   * response['message']
   * response['transaction_id']
   * response['already_paid']
   * response['already_captured']
   */
    return response;
  }

  // Future createPaypalOrder(int orderId, String total) async {
  //   final res = await http.post(
  //     Uri.parse("https://nakedsyrups.com.au/wp-json/ns/v1/create-paypal-order"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"order_id": orderId, "total": total}),
  //   );
  //
  //   return jsonDecode(res.body);
  // }

  Future<Map<String, dynamic>?>
  createPaypalOrder(
      int wooCommerceOrderId,
      ) async {
    if (wooCommerceOrderId <= 0) {
      return {
        'success': false,
        'code': 'INVALID_WC_ORDER_ID',
        'message':
        'A valid WooCommerce order ID is required.',
      };
    }

    final Map<String, dynamic> request = {
      'order_id': wooCommerceOrderId,
    };

    final Map<String, dynamic>? response =
    await dioPaypalPostApiCall(
      'create-paypal-order',
      request,
    );

    if (response == null) {
      return {
        'success': false,
        'message':
        'No response was received while creating the PayPal order.',
      };
    }

    print(
      'create-paypal-order response: $response',
    );

    if (response['success'] != true) {
      return response;
    }

    final String paypalOrderId =
        response['orderID']
            ?.toString()
            .trim() ??
            '';

    final String approvalUrl =
        response['approveUrl']
            ?.toString()
            .trim() ??
            '';

    if (
    paypalOrderId.isEmpty ||
        approvalUrl.isEmpty
    ) {
      return {
        ...response,
        'success': false,
        'code': 'PAYPAL_CREATE_RESPONSE_INVALID',
        'message':
        'PayPal did not return a valid order ID and approval URL.',
      };
    }

    return response;
  }
  FutureOr<dynamic> shippingMethods(country, state, postcode, city) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, dynamic> mappp = {};
    mappp = {
      "country": country,
      "state": state,
      "postcode": postcode,
      "city": city,
    };

    print("mapp : ${mappp}");
    if (token == null || token.isEmpty) {
      String? guestToken = "";
      guestToken = prefs.getString("guest_token");
      mappp.addIf(guestToken?.isNotEmpty, 'guest_token', guestToken);
    }
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
    print("form data : ${mapp}");

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

  FutureOr<dynamic> getPriceDetails(Map<String, dynamic> mapp) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      String? guestToken = "";
      guestToken = prefs.getString("guest_token");
      mapp.addIf(guestToken?.isNotEmpty, 'guest_token', guestToken);
    }
    print("fees map  :$mapp ");
    var decodedResponse = await dioPostApiCall('extra-fees', jsonEncode(mapp));
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? guestToken = "";
    guestToken = prefs.getString("guest_token");
    mappp.addIf(
      prefs.getString("guest_token") != null &&
          prefs.getString("guest_token")?.isNotEmpty == true,
      'guest_token',
      guestToken,
    );
    print("Apply Coupon mapp : ${mappp}");
    FormData formData = FormData.fromMap(mappp);
    var decodedResponse = await dioPostApiCall('apply-coupon', formData);

    if (decodedResponse['success'] == true) {
      return decodedResponse;
    } else {
      getT.Get.snackbar(
        decodedResponse.toString().contains('message')  ? "${decodedResponse['message']}":"Error $decodedResponse",
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? guestToken = "";
    guestToken = prefs.getString("guest_token");
    mappp.addIf(
      prefs.getString("guest_token") != null &&
          prefs.getString("guest_token")?.isNotEmpty == true,
      'guest_token',
      guestToken,
    );
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

  FutureOr<dynamic> getCertificate() async {
    var decodedResponse = await dioGetApiCall('certificate-links');

    // if (decodedResponse['success'] == true) {
    //   return decodedResponse;
    // } else {
    //   getT.Get.snackbar(
    //     "Error $decodedResponse",
    //     "",
    //     colorText: Colors.red,
    //     backgroundColor: Colors.white,
    //   );
    return decodedResponse;
    // return null;
    // }
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

  FutureOr<dynamic> notification() async {
    var decodedResponse = await dioGetApiCall('holiday-notification');

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, dynamic> mappp = {};

    if (token == null || token.isEmpty) {
      String? guestToken = "";
      guestToken = prefs.getString("guest_token");
      mappp = {'guest_token': guestToken};
      print("Found guest_token : $guestToken");
    }
    FormData formData = FormData.fromMap(mappp);
    print("Mapp : ${mappp.isNotEmpty}");
    var decodedResponse = await dioPostApiCall(
      'get-cart',
      mappp.isNotEmpty ? formData : {},
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
      print("verify URL::$url :: $token");
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
