import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/device.dart';
import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeviceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<Files, Devices, DirChanger, Settings>(
        builder: (context, files, devices, dir, prefs, child) {
      return Column(
        children: <Widget>[
          for (var device in _getDevices(devices.devices))
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
    devices.sort((a, b) => a.compareTo(b));
    return devices;
  }
}
