
import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/device_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('Devices: ', (){
    test('Empty when no devices are attached',(){
      var device = DeviceBloc();
      expect(device.devices.isEmpty, true);
    });

    test('Has Devices when present', () async{
      var mediaDir = Directory('/run/media/${Platform.environment['USER']}');

      if (!await mediaDir.exists()){
        await mediaDir.create();
      }

      // Creates a temporary device within the test environment
      var devPath = await Directory('${mediaDir.path}/testDevice').create();
      var device = DeviceBloc();

      expect(device.devices, <Device>[Device(path: devPath.path)]);
    });

    test('Devices update upon set call',() async {
      var mediaDir = Directory('/run/media/${Platform.environment['USER']}');

      if (!await mediaDir.exists()){
        mediaDir.create(recursive: true);
      }

      var device = DeviceBloc();
      expect(device.devices.isEmpty, true);
      
      // Creates a temporary device within the test environment
      var devPath = await Directory('${mediaDir.path}/testDevice').create();
      var newDevs = <Device>[Device(path: devPath.path)];
      device.devices = newDevs;
      expect(device.devices, newDevs);
    });


  });
}