import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkHelper {
  static final Connectivity _connectivity = Connectivity();
  static DateTime? _lastDialogTime;

  /// ✅ Only checks internet (NO dialog here)
  static Future<bool> hasInternet() async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity();

      // ❌ No network at all
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // ✅ Verify actual internet
      final result = await InternetAddress.lookup('google.com');
      final hasInternet = await InternetConnection().hasInternetAccess;

      return result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty &&
          hasInternet;
    } on SocketException {
      return false;
    } catch (e) {
      return false;
    }
  }

  /// ✅ Global listener (optional but recommended)
  static void init() {
    _connectivity.onConnectivityChanged.contains((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showNoInternetDialog();
      }
    });
  }

  /// ✅ Dialog logic
  static void showNoInternetDialog() {
    if (Get.isDialogOpen == true) return;

    if (_lastDialogTime != null) {
      final diff = DateTime.now().difference(_lastDialogTime!);
      if (diff.inSeconds < 30) return;
    }

    _lastDialogTime = DateTime.now();

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please check your connection."),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
