import 'package:filer_flutter_desktop/state/device.dart';
import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:filer_flutter_desktop/widgets/device_view.dart';
import 'package:filer_flutter_desktop/widgets/dir_changer_view.dart';
import 'package:filer_flutter_desktop/widgets/favs_view.dart';
import 'package:filer_flutter_desktop/widgets/files_view.dart';
import 'package:filer_flutter_desktop/widgets/settings_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  final Settings prefs;
  final Favs favs;
  MyApp(this.prefs, this.favs);
  @override
  Widget build(BuildContext context) {
    return _getProviders();
  }

  _getProviders() {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Settings>.value(
            value: prefs,
          ),
          ChangeNotifierProvider<Favs>.value(
            value: favs,
          ),
          ChangeNotifierProvider<Files>.value(
            value: Files(),
          ),
          ChangeNotifierProvider<Devices>.value(
            value: Devices(),
          ),
          ChangeNotifierProvider<DirChanger>.value(
            value: DirChanger(),
          ),
        ],
        child: Consumer<Settings>(
          builder: (context, prefs, child) => MaterialApp(
            title: 'Filer',
            theme: prefs.themeData,
            home: MainWindow(),
          ),
        ));
  }
}

class MainWindow extends StatefulWidget {
  @override
  _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  @override
  Widget build(BuildContext context) {
    return _buildLandscape();
  }

  _buildLandscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filer'),
      ),
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
            DirChangerView(),
            Expanded(
              child: FilesView(),
              flex: 6,
            ),
          ]),
        )
      ]),
    );
  }
}
