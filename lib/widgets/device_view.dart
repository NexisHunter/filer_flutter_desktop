import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/device_bloc.dart';
import 'package:filer_flutter_desktop/state/dir_changer_bloc.dart';
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_filer/blocs/device_bloc.dart';
// import 'package:flutter_filer/blocs/dir_changer_bloc.dart';
// import 'package:flutter_filer/blocs/file_bloc.dart';
// import 'package:flutter_filer/blocs/settings_bloc.dart';
import 'package:provider/provider.dart';

class DeviceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<FilesBloc, DeviceBloc, DirChangerBloc, SettingsBloc>(
        builder: (context, files, devices, dir, prefs, child) {
      return Column(
        children: <Widget>[
          for (var device in devices.devices)
            Card(
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      device.name,
                      textAlign: TextAlign.center,
                    )),
                    IconButton(
                      icon: Icon(Icons.eject),
                      onPressed: () {
                        // TODO: Set Up to eject device
                      },
                    )
                  ],
                ),
                onTap: () {
                  dir.root = Directory(device.path);
                  files.updateFiles(dir.root, prefs.showHidden);
                },
              ),
            )
        ],
      );
    });
  }

  List<Device> _getDevices(List<Device> devices) {
    devices.sort();
    return devices;
  }
  // Column(
  //   children: <Widget>[
  //     for (var item in devices)
  //       Card(
  //           child: InkWell(
  //         child: Row(
  //           children: <Widget>[
  //             Expanded(child: Text(item.name)),
  //             IconButton(
  //               icon: Icon(Icons.eject),
  //               onPressed: () {},
  //             )
  //           ],
  //         ),
  //       ))
  //   ],
  // );
}
