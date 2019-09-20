import 'package:flutter/material.dart';

class SettingsBloc extends ChangeNotifier {
  SettingsBloc();
  SettingsBloc.fromMap(Map<String, dynamic> prefs) {
    // ThemeData work around
    _toSwatch(int color) {
      final c = Color(color);
      return {
        50: Color.fromRGBO(c.red, c.green, c.blue, .1),
        100: Color.fromRGBO(c.red, c.green, c.blue, .2),
        200: Color.fromRGBO(c.red, c.green, c.blue, .3),
        300: Color.fromRGBO(c.red, c.green, c.blue, .4),
        400: Color.fromRGBO(c.red, c.green, c.blue, .5),
        500: Color.fromRGBO(c.red, c.green, c.blue, .6),
        600: Color.fromRGBO(c.red, c.green, c.blue, .7),
        700: Color.fromRGBO(c.red, c.green, c.blue, .8),
        800: Color.fromRGBO(c.red, c.green, c.blue, .9),
        900: Color.fromRGBO(c.red, c.green, c.blue, 1)
      };
    }

    _createThemeData(List<int> colors) {
      return ThemeData(
        primaryColor: Color(colors[0]),
        primarySwatch: MaterialColor(colors[1], _toSwatch(colors[1])),
        accentColor: Color(colors[2]),
        buttonColor: Color(colors[3]),
        splashColor: Color(colors[4]),
        fontFamily: prefs['fontFamily'],
      );
    }

    final primary = prefs['primaryColor'] as int;
    final swatch = prefs['primarySwatch'] as int;
    final accent = prefs['accentColor'] as int;
    final button = prefs['buttonColor'] as int;
    final splash = prefs['splashColor'] as int;
    final colors = <int>[primary, swatch, accent, button, splash];
    _themeData = _createThemeData(colors);

    // Remainder of the user settings
    _showHidden = prefs['showHidden'] as bool;
    _showFileExtensions = prefs['showFileExtensions'] as bool;
    _scale = prefs['scale'] as double;
    _isCreated = prefs['isCreated'] as bool;
  }

  ThemeData _themeData = ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto');
  ThemeData get themeData => _themeData;
  set themeData(ThemeData themedata) {
    _themeData = themedata;
    notifyListeners();
  }

  bool _showHidden = false;
  bool get showHidden => _showHidden;
  set showHidden(bool hide) {
    _showHidden = hide;
    notifyListeners();
  }

  bool _showFileExtensions = false;
  bool get showFileExtensions => _showFileExtensions;
  set showFileExtensions(bool showFileExtensions) {
    _showFileExtensions = showFileExtensions;
    notifyListeners();
  }

  double _scale = 1.0;
  double get scale => _scale;
  set scale(double scale) {
    _scale = scale;
    notifyListeners();
  }

  bool _isCreated = false;
  bool get isCreated => _isCreated;
  set isCreated(bool isCreated) {
    _isCreated = isCreated;
    notifyListeners();
  }

  toMap() {
    return {
      // "ThemeData work around
      "primaryColor": _themeData.primaryColor.value,
      "primarySwatch": _themeData.primaryColor.value,
      "accentColor": _themeData.accentColor.value,
      "buttonColor": _themeData.buttonColor.value,
      "splashColor": _themeData.splashColor.value,
      "showHidden": _showHidden,
      "showFileExtensions": _showFileExtensions,
      "scale": _scale,
      "isCreated": _isCreated,
      'fontFamily': 'Roboto' // Temporarily set to Roboto until flutter-desktop-embedding is improved to better support other fonts
    };
  }

  fromMap(Map<String, dynamic> prefs) {
    // ThemeData work around
    _toSwatch(int color) {
      final c = Color(color);
      return {
        50: Color.fromRGBO(c.red, c.green, c.blue, .1),
        100: Color.fromRGBO(c.red, c.green, c.blue, .2),
        200: Color.fromRGBO(c.red, c.green, c.blue, .3),
        300: Color.fromRGBO(c.red, c.green, c.blue, .4),
        400: Color.fromRGBO(c.red, c.green, c.blue, .5),
        500: Color.fromRGBO(c.red, c.green, c.blue, .6),
        600: Color.fromRGBO(c.red, c.green, c.blue, .7),
        700: Color.fromRGBO(c.red, c.green, c.blue, .8),
        800: Color.fromRGBO(c.red, c.green, c.blue, .9),
        900: Color.fromRGBO(c.red, c.green, c.blue, 1)
      };
    }

    _createThemeData(List<int> colors) {
      return ThemeData(
        primaryColor: Color(colors[0]),
        primarySwatch: MaterialColor(colors[1], _toSwatch(colors[1])),
        accentColor: Color(colors[2]),
        buttonColor: Color(colors[3]),
        splashColor: Color(colors[4]),
        fontFamily: prefs['fontFamily'],
      );
    }

    final primary = prefs['primaryColor'] as int;
    final swatch = prefs['primarySwatch'] as int;
    final accent = prefs['accentColor'] as int;
    final button = prefs['buttonColor'] as int;
    final splash = prefs['splashColor'] as int;
    final colors = <int>[primary, swatch, accent, button, splash];
    _themeData = _createThemeData(colors);

    // Remainder of the user settings
    _showHidden = prefs['showHidden'] as bool;
    _showFileExtensions = prefs['showFileExtensions'] as bool;
    _scale = prefs['scale'] as double;
    _isCreated = prefs['isCreated'] as bool;
    notifyListeners();
  }

  equals(SettingsBloc other){
    return 
      this.themeData == other.themeData && 
      this.scale == other.scale && 
      this.isCreated == other.isCreated &&
      this.showFileExtensions == other.showFileExtensions && 
      this.showHidden == other.showHidden;
  }
}
