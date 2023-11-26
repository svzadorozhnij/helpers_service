import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

enum FireRemoteKey { remoteData }

class FirebaseRemoteService {

  static final _singleton = FirebaseRemoteService._internal();

  factory FirebaseRemoteService() => _singleton;

  FirebaseRemoteService._internal();

  late FirebaseRemoteConfig _remoteConfig;

  Future<void> init() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  Future<Map<String, dynamic>?> getDataFromFirebase(
      {required FireRemoteKey firebaseRemote}) async {
    try {
      String key = firebaseRemote.name;
      await _remoteConfig.fetchAndActivate();
      final dataFromFirebase = _remoteConfig.getString(key);
      if (dataFromFirebase.isNotEmpty) {
        return jsonDecode(dataFromFirebase);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
