// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';
import 'dart:io';

import 'package:filer_flutter_desktop/state/device_bloc.dart';
import 'package:filer_flutter_desktop/state/dir_changer_bloc.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:filer_flutter_desktop/widgets/device_view.dart';
import 'package:filer_flutter_desktop/widgets/dir_changer.dart';
import 'package:filer_flutter_desktop/widgets/favs_view.dart';
import 'package:filer_flutter_desktop/widgets/files_view.dart';
import 'package:filer_flutter_desktop/widgets/settings_drawer.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final home = Platform.environment['HOME'];
  SettingsBloc prefs = SettingsBloc();
  FavsBloc favs = FavsBloc();
  Map<String, dynamic> userSettings;

  var settingsFile = File('$home/.flutter_filer_desktop.json');
  // If the preferences has been saved load the user adjusted settings.
  if (await settingsFile.exists()) {
    userSettings = json.decode(await settingsFile.readAsString());
    prefs.fromMap(userSettings['prefs']);
    favs.fromMap(userSettings['favs']['favourites']);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsBloc>.value(
          value: prefs,
        ),
        ChangeNotifierProvider<FavsBloc>.value(
          value: favs,
        ),
        ChangeNotifierProvider<FilesBloc>.value(
          value: FilesBloc(),
        ),
        ChangeNotifierProvider<DeviceBloc>.value(
          value: DeviceBloc(),
        ),
        ChangeNotifierProvider<DirChangerBloc>.value(
          value: DirChangerBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsBloc>(
      builder: (context, prefs, child) => MaterialApp(
        title: 'Filer Flutter',
        theme: prefs.themeData,
        home: MyHomePage(title: 'Filer Flutter'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final title;
  MyHomePage({this.title = ""});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _buildLandscape();
  }

  _buildLandscape() {
    return Scaffold(
      appBar: AppBar(title: Text('Filer')),
      drawer: Drawer(
        child: SettingsDrawer(),
      ),
      body: Row(children: <Widget>[
        Expanded(
            flex: 1,
            child: Column(children: <Widget>[
              Expanded(
                  child: ListView(children: [
                FavsView(),
              ])),
              Expanded(
                  child: ListView(children: [
                DeviceView(),
              ])),
            ])),
        Expanded(
          flex: 3,
          child: Column(children: <Widget>[
            DirChanger(),
            Expanded(
              child: FilesView(),
              flex: 6,
            )
          ]),
        )
      ]),
    );
    // return Consumer<SettingsBloc, FilesBloc, FavsBloc, DeviceBloc>(
    //   builder: (context, prefs, child) => //Row(
    //     // // children: <Widget>[
    //     //   // Expanded(
    //     //   //   child: Placeholder(
    //     //   //     color: Colors.brown,
    //     //   //   ),
    //     //   // ),
    //     //   ListView(
    //     //     children: <Widget>[
    //     //       for (var item in Directory(prefs.pwd).listSync())
    //     //         ListTile(
    //     //           title: Text('${item.path}'),
    //     //         )
    //     //     ],
    //     //   )
    //     // ],
    //   // ),
    // );
  }
}
