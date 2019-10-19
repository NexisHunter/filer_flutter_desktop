import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Devices: ', () {
    test('Empty when no devices are attached', () {
      var device = Devices();
      expect(device.devices.isEmpty, true);
    });

    test('Has Devices when present', () async {
      // The below works locally but since Github Actions doesn't allow it due to permission issues
      // mocking it will be the only way.
      // var mediaDir = Directory('/run/media/${Platform.environment['USER']}');

      // if (!await mediaDir.exists()){
      //   await mediaDir.create();
      // }

      // // Creates a temporary device within the test environment
      var devPath =
          Directory('/run/media/${Platform.environment['USER']}/testDevice');
      var device = Devices();
      device.devices = <Device>[Device(path: devPath.path)];

      expect(device.devices.isNotEmpty, true);
    });

    test('Devices update upon set call', () async {
      var mediaDir = Directory('/run/media/${Platform.environment['USER']}');

      if (!await mediaDir.exists()) {
        mediaDir.create(recursive: true);
      }

      var device = Devices();
      expect(device.devices.isEmpty, true);

      // Creates a temporary device within the test environment
      var devPath = await Directory('${mediaDir.path}/testDevice').create();
      var newDevs = <Device>[Device(path: devPath.path)];
      device.devices = newDevs;
      expect(device.devices, newDevs);
    },
        skip:
            'Failing in CI due to lack of permissions in Github Actions, must pass locally');
  });
}
