// Copyright 2019 Hunter Breathat

import 'dart:convert';
import 'dart:io';

import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:filer_flutter_desktop/widgets/app.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';

main() async {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  // Set up proper debugging depending on platform.
  if (Platform.isAndroid) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }
  if (Platform.isIOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  }

  // Get the user's home folder
  Settings prefs = Settings();
  Favs favs = Favs();
  Map<String, dynamic> userSettings;

  // var settingsFile = File('${prefs.home}.flutter_filer_desktop.json');
  // // If the preferences has been saved load the user adjusted settings.
  // if (await settingsFile.exists()) {
  //   userSettings = json.decode(await settingsFile.readAsString());
  //   prefs = Settings.fromMap(userSettings['prefs']);
  //   favs = Favs.fromMap(userSettings['favs']['favourites']);
  // }

  runApp(MyApp(prefs, favs));
}
