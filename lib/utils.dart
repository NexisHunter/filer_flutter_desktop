import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Map<int, Color> toSwatch(int color) {
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

ThemeData createThemeData(List<int> colors, String font, bool darkMode) {
  return ThemeData(
    primaryColor: Color(colors[0]),
    primarySwatch: MaterialColor(colors[1], toSwatch(colors[1])),
    accentColor: Color(colors[2]),
    buttonColor: Color(colors[3]),
    splashColor: Color(colors[4]),
    fontFamily: font,
    brightness: (darkMode) ? Brightness.dark : Brightness.light,
  );
}

String getName({File file, Directory dir, String filePath}) {
  var path = file?.path ?? dir?.path ?? filePath;
  return path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
}

String getExtension(String name) => (name.startsWith('.'))
    ? name
    : name.substring(0, name.lastIndexOf('.') + 1);

extension TextController on TextEditingController {
  void setCursor(String text, int pos) {
    value = value.copyWith(
      text: text,
      selection: TextSelection.collapsed(
        offset: pos,
      ),
      composing: TextRange(
        start: pos,
        end: pos,
      ),
    );
  }
}
