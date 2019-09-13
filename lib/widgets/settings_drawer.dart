import 'dart:convert';
import 'dart:io';

import 'package:filer_flutter_desktop/state/dir_changer_bloc.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_filer/blocs/dir_changer_bloc.dart';
// import 'package:flutter_filer/blocs/favs_bloc.dart';
// import 'package:flutter_filer/blocs/file_bloc.dart';
// import 'package:flutter_filer/blocs/settings_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:sqflite/sqflite.dart' as sqflite;
// import 'package:sembast/sembast_io.dart';

class SettingsDrawer extends StatefulWidget {
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<SettingsBloc, FilesBloc, DirChangerBloc, FavsBloc>(
        builder: (context, prefs, files, dir, favs, child) => ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 100,
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
                ),
                ListTile(
                  title: Text('Show Hidden Files'),
                  trailing: Switch(
                    value: prefs.showHidden,
                    onChanged: (value) {
                      prefs.showHidden = value;
                      files.updateFiles(dir.root, prefs.showHidden);
                    },
                  ),
                ),
                ListTile(
                  title: Text('Show File Extensions'),
                  trailing: Switch(
                    value: prefs.showFileExtensions,
                    onChanged: (value) {
                      prefs.showFileExtensions = value;
                      files.updateFiles(dir.root, prefs.showHidden);
                    },
                  ),
                ),
                ListTile(
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
                            min: 0.75,
                            max: 2.5,
                            onChanged: (value) {
                              prefs.scale = value;
                            },
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Text('${prefs.scale.toStringAsFixed(2)}')),
                      ],
                    ),
                  ),
                ),
                ExpansionTile(
                    title: Container(
                      child: Text('Theme Setup'),
                      width: 80,
                    ),
                    children: <Widget>[
                      ExpansionTile(
                        title: Text.rich(TextSpan(
                          text: 'Primary Color',
                        )),
                        children: <Widget>[
                          MaterialColorPicker(
                            circleSize: 75 * (prefs.scale),
                            onColorChange: (color) {
                              prefs.themeData = ThemeData(
                                  primaryColor: color,
                                  primarySwatch: _toSwatch(color.value));
                            },
                            onMainColorChange: (ColorSwatch color) {
                              prefs.themeData = ThemeData(
                                  primaryColor: color, primarySwatch: color);
                            },
                            selectedColor: prefs.themeData.primaryColor,
                          )
                        ],
                        trailing: CircleColor(
                          color: prefs.themeData.primaryColor,
                          circleSize: 25 * (prefs.scale / 2),
                        ),
                      ),
                      ExpansionTile(
                        title: Text('Accent Color'),
                        children: <Widget>[
                          MaterialColorPicker(
                            circleSize: 75 * (prefs.scale),
                            onColorChange: (Color color) {
                              prefs.themeData = ThemeData(
                                  primaryColor: prefs.themeData.primaryColor,
                                  accentColor: color,
                                  primarySwatch: _toSwatch(
                                      prefs.themeData.primaryColor.value));
                            },
                            onMainColorChange: (ColorSwatch color) {
                              prefs.themeData = ThemeData(
                                  primaryColor: prefs.themeData.primaryColor,
                                  accentColor: color,
                                  primarySwatch: _toSwatch(
                                      prefs.themeData.primaryColor.value));
                            },
                            selectedColor: prefs.themeData.accentColor,
                          )
                        ],
                        trailing: CircleColor(
                          color: prefs.themeData.accentColor,
                          circleSize: 25 * (prefs.scale / 2),
                        ),
                      ),
                      ExpansionTile(
                        title: Text('Splash Color'),
                        children: <Widget>[
                          MaterialColorPicker(
                            circleSize: 75 * (prefs.scale),
                            onColorChange: (Color color) {
                              prefs.themeData = ThemeData(
                                  primaryColor: prefs.themeData.primaryColor,
                                  accentColor: prefs.themeData.accentColor,
                                  splashColor: color,
                                  primarySwatch: _toSwatch(
                                      prefs.themeData.primaryColor.value));
                            },
                            onMainColorChange: (ColorSwatch color) {
                              prefs.themeData = ThemeData(
                                  primaryColor: prefs.themeData.primaryColor,
                                  accentColor: prefs.themeData.accentColor,
                                  splashColor: color,
                                  primarySwatch: _toSwatch(
                                      prefs.themeData.primaryColor.value));
                            },
                            selectedColor: prefs.themeData.splashColor,
                          )
                        ],
                        trailing: CircleColor(
                          color: prefs.themeData.splashColor,
                          circleSize: 25 * (prefs.scale / 2),
                        ),
                      ),
                    ])
              ],
            ));
  }

  _save(FavsBloc favs, SettingsBloc prefs) async {
    final file =
        File('${Platform.environment['HOME']}/.flutter_filer_desktop.json');
    final toUse = await file.create();

    await toUse.writeAsString('{ "prefs" : ${json.encode(prefs.toMap())}, "favs" : ${json.encode(favs.toMap())} }');
    // final dbPath = await sqflite.getDatabasesPath() + 'user_prefs.db';
    // Database db = await databaseFactoryIo.openDatabase(dbPath);
    // // Single write
    // await db.transaction((write) async {
    //   await write.put(prefs.toMap(), 'settings');
    //   await write.put(favs.toMap(), 'favourites');
    // });
  }

  _toSwatch(int color) {
    final c = Color(color);
    return MaterialColor(color, {
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
    });
  }
}
