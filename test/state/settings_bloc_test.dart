
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('Set up Settings:', () {
    test('Defaults', (){
      var settings = SettingsBloc();
      expect(settings.equals(SettingsBloc()), isTrue);
    });

    test('Custom Preferences from Map', () {
      var themeData = ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto');
      var showHidden = true;
      var showFileExtensions = true;
      var scale = 2.0;
      var isCreated = true;

      var map = {
        "primaryColor": themeData.primaryColor.value,
        "primarySwatch": themeData.primaryColor.value,
        "accentColor": themeData.accentColor.value,
        "buttonColor": themeData.buttonColor.value,
        "splashColor": themeData.splashColor.value,
        "showHidden": showHidden,
        "showFileExtensions": showFileExtensions,
        "scale": scale,
        "isCreated": isCreated,
        'fontFamily': 'Roboto'
      }; 

      var settings = new SettingsBloc();
      settings.fromMap(map);

      expect(settings.toMap(),map);
    });
  });
}