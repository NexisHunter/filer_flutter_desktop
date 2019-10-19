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
                                primarySwatch: MaterialColor(
                                  color.value,
                                  toSwatch(color.value),
                                ),
                              );
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
                                primarySwatch: MaterialColor(
                                  color.value,
                                  toSwatch(color.value),
                                ),
                              );
                            },
                            onMainColorChange: (ColorSwatch color) {
                              prefs.themeData = ThemeData(
                                primaryColor: prefs.themeData.primaryColor,
                                accentColor: color,
                                primarySwatch: MaterialColor(
                                  color.value,
                                  toSwatch(color.value),
                                ),
                              );
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
                                primarySwatch: MaterialColor(
                                  color.value,
                                  toSwatch(color.value),
                                ),
                              );
                            },
                            onMainColorChange: (ColorSwatch color) {
                              prefs.themeData = ThemeData(
                                primaryColor: prefs.themeData.primaryColor,
                                accentColor: prefs.themeData.accentColor,
                                splashColor: color,
                                primarySwatch: MaterialColor(
                                  color.value,
                                  toSwatch(color.value),
                                ),
                              );
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

  _save(Favs favs, Settings prefs) async {
    final file = File('${prefs.home}.flutter_filer_desktop.json');
    final toUse = await file.create();

    await toUse.writeAsString(
        '{ "prefs" : ${json.encode(prefs.toMap())}, "favs" : ${json.encode(favs.toMap())} }');
  }
}
