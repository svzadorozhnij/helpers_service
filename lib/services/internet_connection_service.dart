import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:helpers/app.dart';

class InternetConnectionService {
  static InternetConnectionService? _instance;

  static InternetConnectionService get instance {
    _instance ??= InternetConnectionService();
    return _instance!;
  }

  bool _isOnline = true;

  bool get isOnlineState => _isOnline;

  StreamSubscription<ConnectivityResult>? _streamSubscription;
  final List<Function> _onConnectedListeners = [
    () => App.showSnackBar(
          const SnackBar(
            content: Text('Connection restored'),
          ),
        )
  ];
  final List<Function> _onDisconnectedListeners = [
        () => App.showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
      ),
    )
  ];

  List<Function> get onConnectedListeners => _onConnectedListeners;

  List<Function> get onDisconnectedListeners => _onDisconnectedListeners;

  void init() {
    if (_streamSubscription != null) return;
    _streamSubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          if (!_isOnline) {
            _isOnline = true;
            _callListeners(_onConnectedListeners);
          }
        } else if (result == ConnectivityResult.none) {
          if (_isOnline) {
            _isOnline = false;
            _callListeners(_onDisconnectedListeners);
          }
        }
      },
    );
  }

  _callListeners(List<Function> listeners) {
    for (var listener in listeners) {
      try {
        listener();
      } catch (e) {
        log('InternetConnectionService ERROR $e');
      }
    }
  }

  static void addListeners({
    Function? onConnected,
    Function? onDisconnected,
  }) {
    if (onConnected != null) {
      InternetConnectionService.instance.onConnectedListeners.add(onConnected);
    }
    if (onDisconnected != null) {
      InternetConnectionService.instance.onDisconnectedListeners
          .add(onDisconnected);
    }
  }

  static Future<bool> isOnline({bool needFlushBar = true}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      instance._isOnline = false;
      return false;
    }
    return true;
  }
}
