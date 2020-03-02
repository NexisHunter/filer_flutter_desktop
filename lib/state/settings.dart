import 'dart:io';

import 'package:flutter/material.dart';

import 'package:filer_flutter_desktop/utils.dart';

/// The application's settings, including user preferences.
///
/// [Settings] - Hosts all of the user tweaked settings as well as some useful
/// environment variables/platform related nicities.
class Settings extends ChangeNotifier {
  /// The default constructor.
  Settings();

  /// A factory constructor used to build a [Settings] object from a json file.
  Settings.fromMap(Map<String, dynamic> prefs) {
    final primary = prefs['primaryColor'] as int;
    final swatch = prefs['primarySwatch'] as int;
    final accent = prefs['accentColor'] as int;
    final button = prefs['buttonColor'] as int;
    final splash = prefs['splashColor'] as int;
    final colors = <int>[primary, swatch, accent, button, splash];
    _themeData =
        createThemeData(colors, prefs['fontFamily'], prefs['darkMode']);

    // Remainder of the user settings
    _showHidden = prefs['showHidden'] as bool;
    _showFileExtensions = prefs['showFileExtensions'] as bool;
    _scale = prefs['scale'] as double;
    _defaultView = prefs['defaultView'] as bool;
  }

  /// The theme to be applied to the application.
  ///
  /// [themeData] - The theme that is applied to the application.
  static ThemeData _themeData = ThemeData(
    primarySwatch: Colors.green,
    fontFamily: 'Roboto',
  );
  ThemeData get themeData => _themeData;
  set themeData(ThemeData themedata) {
    _themeData = themedata;
    _colors[0] = themeData.primaryColor;
    _colors[1] = themeData.accentColor;
    _colors[2] = themeData.splashColor;
    notifyListeners();
  }

  List<Color> _colors = [
    _themeData.primaryColor,
    _themeData.accentColor,
    _themeData.splashColor
  ];
  List<Color> get colors => _colors;

  /// When enabled displays the hidden files.
  ///
  /// [showHidden] - A flag that when enabled it displays all of the files
  /// beginning with [.].
  bool _showHidden = false;
  bool get showHidden => _showHidden;
  set showHidden(bool hide) {
    _showHidden = hide;
    notifyListeners();
  }

  /// The current brightness of the application.
  ///
  /// [darkMode] - Used to handle the user interaction changes within the settings menu.
  bool get darkMode => _themeData.brightness == Brightness.dark;
  set darkMode(bool darkMode) {
    Brightness _brightness;
    (darkMode) ? _brightness = Brightness.dark : _brightness = Brightness.light;
    themeData = ThemeData(
      primaryColor: _themeData.primaryColor,
      brightness: _brightness,
      primarySwatch: MaterialColor(
        _themeData.primaryColor.value,
        toSwatch(_themeData.primaryColor.value),
      ),
      accentColor: _themeData.accentColor,
      accentColorBrightness: _themeData.accentColorBrightness,
      splashColor: _themeData.splashColor,
      fontFamily: 'Roboto',
    );
  }

  /// When enabled display the file extensions.
  ///
  /// [showFileExtensions] - The flag that determines whether or not to show
  /// the file extensions of the files in the files view.
  bool _showFileExtensions = false;
  bool get showFileExtensions => _showFileExtensions;
  set showFileExtensions(bool showFileExtensions) {
    _showFileExtensions = showFileExtensions;
    notifyListeners();
  }

  /// The size at which things are displayed.
  ///
  /// [scale] - The scalar to tranform the size of the displayed icons within
  /// the files view.
  double _scale = 1.0;
  double get scale => _scale;
  set scale(double scale) {
    _scale = scale;
    notifyListeners();
  }

  /// The default display style.
  ///
  /// [view] - The default is icon view
  bool _defaultView = true;
  bool get view => _defaultView;
  set view(bool view) {
    // TODO: Set it so that there are more display types, if they are added.
    _defaultView = view;
    notifyListeners();
  }

  /// The current platform being used.
  ///
  /// [os] - The current operating system the user is running.
  String os = Platform.operatingSystem;

  /// The home directory of the user.
  ///
  /// [home] - The path to the home directory of the current user.
  String home = '${Platform.environment['HOME']}${Platform.pathSeparator}';

  /// Parses the object into a json object representing the settings.
  Map<String, dynamic> toMap() {
    return {
      // "ThemeData work around
      "primaryColor": _themeData.primaryColor.value,
      "primarySwatch": _themeData.primaryColor.value,
      "accentColor": _themeData.accentColor.value,
      "buttonColor": _themeData.buttonColor.value,
      "splashColor": _themeData.splashColor.value,
      "darkMode": darkMode,
      "showHidden": _showHidden,
      "showFileExtensions": _showFileExtensions,
      "scale": _scale,
      "defaultView": view,
      'fontFamily':
          'Roboto' // Temporarily set to Roboto until flutter-desktop-embedding is improved to better support other fonts
    };
  }

  bool _equals(Settings other) {
    return this.themeData == other.themeData &&
        this.scale == other.scale &&
        this.showFileExtensions == other.showFileExtensions &&
        this.showHidden == other.showHidden;
  }

  @override
  operator ==(other) => _equals(other);

  @override
  int get hashCode => super.hashCode;
}
