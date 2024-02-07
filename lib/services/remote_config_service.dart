import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  final _remoteConfigSettings = RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(milliseconds: 0),
  );

  Future<RemoteConfigService> init() async {
    await _remoteConfig.setConfigSettings(_remoteConfigSettings);
    try {
      await _remoteConfig.fetchAndActivate();
    } on Exception catch (e) {
      log('Failed to fetch remote config - $e');
      FirebaseCrashlytics.instance
          .recordError('Failed to fetch remote config - $e', null);
    }
    return this;
  }

  String getString(ConfigKey key) => _remoteConfig.getString(key.name);

  bool getBool(ConfigKey key) => _remoteConfig.getBool(key.name);
}

enum ConfigKey {
  privacyLink,
  cryptoApiKey,
  newsApiKey,
}