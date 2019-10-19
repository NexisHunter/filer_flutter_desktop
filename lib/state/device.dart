import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';

/// Represents the list of connected devices, be it external or internal.
///
/// [Devices] - A list that represents the mounted devices and partitions
/// attached to the host device.
class Devices extends ChangeNotifier {
  Devices({String os})
      : _devices = [
          if (Directory(_getMediaPath(os)).existsSync())
            for (var device in Directory(_getMediaPath(os)).listSync())
              Device(path: device.path),
        ];

  /// THe currently attached devices.
  ///
  /// [devices] - Represents the list of currently attached partitions and
  /// external devices to read from.
  List<Device> _devices;
  List<Device> get devices => _devices;
  set devices(List<Device> devs) {
    for (var device in devs) {
      if (device.name == '0') device.name = 'This';
    }
    devs.sort();
    _devices = devs;
    notifyListeners();
  }

  /// Ejects the given [drive] from the host.
  ///
  /// [drive] - The device to remove from the list of mounted devices, and the
  /// device to have the operating system unmount.
  void eject(Device drive) {
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

  /// Fetches the media mount point for the given operating system.
  ///
  /// [os] - The current operating system, maybe null. If null query the
  /// platform and use that to fetch the devices.
  static String _getMediaPath(String os) {
    // Determine if the os is null
    os = os ?? Platform.operatingSystem;

    switch (os) {
      // TODO: Determine where windows houses the device mount points.
      case 'Windows':
        return '';
      case 'Android':
        return '/emulated/';
      case 'Linux':
        return '/run/media/${Platform.environment['HOME']}';

      // TODO: Get full path for macOS and iOS.
      case 'MacOs':
        return '/Volumes/';
      case 'iOS':
        return '/Volumes/';

      // TODO: Get fuchsia device mount point.
      case 'Fuchsia':
        return '';
    }

    return '';
  }
}
