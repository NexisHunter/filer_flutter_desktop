import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Set up Settings:', () {
    test('Defaults', () {
      var settings = Settings();
      expect(settings == Settings(), isTrue);
    });

    test('Custom Preferences from Map', () {
      var themeData =
          ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto');
      var showHidden = true;
      var showFileExtensions = true;
      var scale = 2.0;
      var darkMode = false;

      var map = {
        "primaryColor": themeData.primaryColor.value,
        "primarySwatch": themeData.primaryColor.value,
        "accentColor": themeData.accentColor.value,
        "buttonColor": themeData.buttonColor.value,
        "splashColor": themeData.splashColor.value,
        "darkMode": darkMode,
        "showHidden": showHidden,
        "showFileExtensions": showFileExtensions,
        "scale": scale,
        'fontFamily': 'Roboto'
      };

      var settings = Settings.fromMap(map);

      expect(settings.toMap(), map);
    });

    test('Dark Mode is changed', () {
      var settings = Settings();

      settings.darkMode = true;

      expect(settings.themeData.brightness, Brightness.dark);
    });
  });
}
