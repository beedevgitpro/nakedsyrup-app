import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkHelper {
  NetworkHelper._();

  static final Connectivity _connectivity = Connectivity();

  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  static DateTime? _lastDialogTime;

  static bool _dialogScheduled = false;

  static Future<bool> hasInternet() async {
    try {
      final connectivity = await _connectivity.checkConnectivity();

      if (connectivity.isEmpty ||
          connectivity.contains(ConnectivityResult.none)) {
        return false;
      }

      return await InternetConnection().hasInternetAccess;
    } catch (_) {
      return false;
    }
  }

  static void init() {
    _subscription?.cancel();

    _subscription =
        _connectivity.onConnectivityChanged.listen((results) async {
          if (results.isEmpty ||
              results.contains(ConnectivityResult.none)) {
            showNoInternetDialog();
            return;
          }
        });
  }

  static void showNoInternetDialog() {
    if (_dialogScheduled) {
      return;
    }

    if (Get.isDialogOpen == true) {
      return;
    }

    final now = DateTime.now();

    if (_lastDialogTime != null &&
        now.difference(_lastDialogTime!).inSeconds < 10) {
      return;
    }

    if (Get.context == null) {
      return;
    }

    _lastDialogTime = now;
    _dialogScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogScheduled = false;

      if (Get.context == null || Get.isDialogOpen == true) {
        return;
      }

      Get.dialog(
        AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please check your internet connection and try again.',
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text('OK'),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    });
  }

  static Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}