import 'dart:convert';
import 'dart:io';

import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

import 'package:filer_flutter_desktop/utils.dart';

/// Builds the [Settings] drawer.
class SettingsDrawer extends StatefulWidget {
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<Settings, Files, DirChanger, Favs>(
      builder: (context, prefs, files, dir, favs, child) => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _menuHeader(prefs, favs),
          _switchShowFlag('Show Hidden Files', 'h', files, dir, prefs, true),
          _switchShowFlag('Show File Extensions', 'f', files, dir, prefs, true),
          _switchShowFlag('Dark Mode', 'd', files, dir, prefs, false),
          _switchShowFlag('Display Mode', 'v', files, dir, prefs, true),
          _showScaling(prefs),
          _themeSetup(prefs),
        ],
      ),
    );
  }

  /// Creates the header of the Settings Panel.
  ///
  /// [prefs] - The current set of user preferences.
  /// [favs] - The current list of favourites.
  _menuHeader(Settings prefs, Favs favs) {
    return Container(
      height: 80,
      child: DrawerHeader(
        margin: const EdgeInsets.only(bottom: 0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Text(
                  'Settings',
                  textAlign: TextAlign.center,
                )),
            RaisedButton(
              child: Text('Save'),
              color: prefs.themeData.buttonColor,
              elevation: 4,
              shape: StadiumBorder(),
              onPressed: () {
                _save(favs, prefs);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: prefs.themeData.primaryColor,
        ),
      ),
    );
  }

  /// Displays the display scaling widget combo.
  ///
  /// [prefs] - The current user preferences.
  _showScaling(Settings prefs) {
    return ListTile(
      title: Container(
        child: Text('View Scaling'),
      ),
      trailing: Container(
        width: 180,
        child: Row(
          children: <Widget>[
            Container(
              width: 150,
              child: Slider(
                value: prefs.scale,
                min: 0.8,
                max: 2.0,
                onChanged: (value) {
                  prefs.scale = value;
                },
                activeColor: prefs.colors[1],
              ),
            ),
            Expanded(flex: 2, child: Text('${prefs.scale.toStringAsFixed(2)}')),
          ],
        ),
      ),
    );
  }

  /// Creates a switch tile to trigger a boolean switch.
  ///
  /// [title] - The trigger label.
  /// [switchValue] - a character signifying what type of button.
  /// [files] - The current list of files.
  /// [dir] - The current working directory.
  /// [prefs] - The current user preferences.
  /// [refresh] - Flag whether or not to update the current list of files.
  _switchShowFlag(String title, String switchValue, Files files, DirChanger dir,
      Settings prefs, bool refresh) {
    bool valueShown;
    switch (switchValue) {
      case 'd':
        valueShown = prefs.darkMode;
        break;
      case 'f':
        valueShown = prefs.showFileExtensions;
        break;
      case 'h':
        valueShown = prefs.showHidden;
        break;
      case 'v':
        valueShown = prefs.view;
        break;
      default:
        valueShown = false;
        break;
    }
    return SwitchListTile(
      title: Text(
        (valueShown)
            ? (switchValue == 'v') ? 'Default' : 'On'
            : (switchValue == 'v') ? 'Compact' : 'Off',
        textAlign: TextAlign.end,
      ),
      value: (switchValue == 'd')
          ? prefs.darkMode
          : (switchValue == 'h')
              ? prefs.showHidden
              : (switchValue == 'f')
                  ? prefs.showFileExtensions
                  : (switchValue == 'v') ? prefs.view : true,
      onChanged: (value) {
        switch (switchValue) {
          case 'd':
            prefs.darkMode = value;
            break;
          case 'f':
            prefs.showFileExtensions = value;
            break;
          case 'h':
            prefs.showHidden = value;
            break;
          case 'v':
            prefs.view = value;
            break;
          default:
            break;
        }
        if (refresh) files.updateFiles(dir.root, prefs.showHidden);
      },
      secondary: Text(title),
      activeColor: prefs.colors[1],
    );
  }

  /// Saves the current list of favourites and user settings.
  ///
  /// [favs] - The current list of favourites.
  /// [prefs] - The current user preferences.
  _save(Favs favs, Settings prefs) async {
    final file = File('${prefs.home}.flutter_filer_desktop.json');
    final toUse = await file.create();

    await toUse.writeAsString(
        '{ "prefs" : ${json.encode(prefs.toMap())}, "favs" : ${json.encode(favs.toMap())} }');
  }

  /// Builds the theme customization portion of the panel.
  ///
  /// [prefs] - The current user preferences.
  _themeSetup(Settings prefs) {
    return ExpansionTile(
      title: Container(
        child: Text(
          'Theme Setup',
        ),
        width: 80,
      ),
      children: <Widget>[
        _colorSelector('Primary Color', prefs, 'p'),
        _colorSelector('Accent Color', prefs, 'a'),
        _colorSelector('Splash Color', prefs, 's'),
      ],
    );
  }

  /// Builds the color selection panel to be used for customization of each
  /// custom color choice.
  ///
  /// [title] - The color to be changed.
  /// [prefs] - The current color preferences.
  /// [attr] - The first letter of the attribute to be changed.
  _colorSelector(String title, Settings prefs, String attr) {
    return ExpansionTile(
      title: Text.rich(
        TextSpan(
          text: title,
        ),
      ),
      children: <Widget>[
        ListTile(
          title: _generateColor(_getColor(attr), prefs),
        ),
      ],
      trailing: CircleColor(
        color: prefs.colors[_getColor(attr)],
        circleSize: 25 * (prefs.scale / 2),
      ),
    );
  }

  /// Fetches the positional value based off the given attribute.
  ///
  /// [attr] - The first letter of the attribute to be found.
  _getColor(String attr) {
    switch (attr) {
      case 'p':
        return 0;
      case 'a':
        return 1;
      case 's':
        return 2;
    }
    return 0;
  }

  /// Builds the panel of colors to be chosen from.
  ///
  /// [colorSetting] - Which color attribute is being altered.
  /// [prefs] - The current user preferences.
  _generateColor(int colorSetting, Settings prefs) {
    return MaterialColorPicker(
      allowShades: true,
      circleSize: 75 * (prefs.scale),
      onColorChange: (Color color) {
        prefs.themeData = ThemeData(
            primaryColor: (colorSetting == 0) ? color : prefs.colors[0],
            primarySwatch: (colorSetting == 0)
                ? MaterialColor(
                    color.value,
                    toSwatch(color.value),
                  )
                : MaterialColor(
                    prefs.colors[0].value,
                    toSwatch(prefs.colors[0].value),
                  ),
            brightness: (prefs.darkMode) ? Brightness.dark : Brightness.light,
            accentColor: (colorSetting == 1) ? color : prefs.colors[1],
            accentColorBrightness: prefs.themeData.accentColorBrightness,
            splashColor: (colorSetting == 2) ? color : prefs.colors[2]);
      },
      // onMainColorChange: (ColorSwatch color) {
      //   prefs.themeData = ThemeData(
      //       primaryColor: (colorSetting == 0) ? color : prefs.colors[0],
      //       primarySwatch: (colorSetting == 0)
      //           ? MaterialColor(
      //               color.value,
      //               toSwatch(color.value),
      //             )
      //           : MaterialColor(
      //               prefs.colors[0].value, toSwatch(prefs.colors[0].value)),
      //       brightness: (prefs.darkMode) ? Brightness.dark : Brightness.light,
      //       accentColor: (colorSetting == 1) ? color : prefs.colors[1],
      //       accentColorBrightness: prefs.themeData.accentColorBrightness,
      //       splashColor: (colorSetting == 2) ? color : prefs.colors[2]);
      // },
      selectedColor: prefs.colors[colorSetting],
    );
  }
}
