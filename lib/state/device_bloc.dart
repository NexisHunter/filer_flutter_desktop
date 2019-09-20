import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';

class DeviceBloc extends ChangeNotifier {
  static final _mediaPath = '/run/media/${Platform.environment['USER']}';
  List<Device> _devices = [
    if (Directory(_mediaPath).existsSync()) 
      for (var device in Directory(_mediaPath).listSync())
        Device(path: device.path),

    // Temporarily disable partions listing until it can be moved elsewhere
    // for (var device in Directory('/dev/').listSync().where((file) {
    //   if (FileSystemEntity.typeSync(file.path) == FileSystemEntityType.file)
    //     return false;
    //   final last = file.path.lastIndexOf('sd');
    //   final s = file.path.substring((last == -1) ? 0 : last);
    //   if (s == file.path) return false;
    //   print(s);
    //   return true;
    // }))
    //   Device(path: device.path),
  ];
  
  List<Device> get devices => _devices;
  set devices(List<Device> devs) {
    for (var device in devs) {
      if (device.name == '0') device.name = 'This';
    }
    devs.sort();
    _devices = devs;
    notifyListeners();
  }

  eject(Device drive) {
    // TODO Implement umount

    final devices = <Device>[];
    // Remove drive from devices list
    for (var device in _devices) {
      if (device.path == drive.path) continue;
      devices.add(device);
    }

    _devices = devices;
    notifyListeners();
  }
}
