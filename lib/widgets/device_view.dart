import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/device.dart';
import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// THe visual list of all of the currently attached devices on the host.
///
/// [DeviceView] is a visual list of the connected internal and external
/// devices.
class DeviceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<Files, Devices, DirChanger, Settings>(
        builder: (context, files, devices, dir, prefs, child) {
      return Column(
        children: <Widget>[
          for (var device in _getDevices(devices.devices))
            _setUpDevice(
                device, prefs.showHidden, devices.eject, files.updateFiles)
        ],
      );
    });
  }

  /// Gets a sorted list of devices attached to the host.
  ///
  /// [devices] - The list of sorted devices.
  List<Device> _getDevices(List<Device> devices) {
    devices.sort((a, b) => a.compareTo(b));
    return devices;
  }

  /// Build the visual representation of the device for the list for the list
  /// of devices.
  ///
  /// [device] - The device to display.
  /// [showHidden] - Whether or not to show hidden files/directories.
  /// [eject] - Callback function to eject the device.
  /// [onTap] - The onTap callback to be used.
  Widget _setUpDevice(Device device, bool showHidden, void eject(Device device),
      Future<void> onTap(Directory root, bool showHidden)) {
    return Card(
      child: InkWell(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                device.name,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.eject,
                ),
                onPressed: () => eject(device)),
          ],
        ),
        onTap: () => onTap(Directory(device.path), showHidden),
      ),
    );
  }
}
