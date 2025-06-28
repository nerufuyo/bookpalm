import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../localization/localization_service.dart';

class ConnectionService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  final RxBool _isConnected = false.obs;
  final RxBool _hasEverBeenConnected = false.obs;

  bool get isConnected => _isConnected.value;
  bool get hasEverBeenConnected => _hasEverBeenConnected.value;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      _updateConnectionStatus(connectivityResult);
    } catch (e) {
      _isConnected.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final isConnected = !connectivityResults.contains(ConnectivityResult.none);

    if (isConnected && !_hasEverBeenConnected.value) {
      _hasEverBeenConnected.value = true;
    }

    if (_isConnected.value != isConnected) {
      _isConnected.value = isConnected;

      // Show snackbar when connection status changes
      if (isConnected) {
        Get.showSnackbar(
          GetSnackBar(
            message: LocalizationService.instance.translate(
              'snackbars.connectionRestored',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            icon: const Icon(Icons.wifi, color: Colors.white),
          ),
        );
      } else {
        Get.showSnackbar(
          GetSnackBar(
            message: LocalizationService.instance.translate(
              'snackbars.noConnection',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.wifi_off, color: Colors.white),
          ),
        );
      }
    }
  }

  // Manual check for connection
  Future<bool> checkConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
