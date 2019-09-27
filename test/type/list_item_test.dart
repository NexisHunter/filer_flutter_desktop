import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Type ', () {
    group('ListIem ', () {
      test('FromMap', () {
        var home = Platform.environment['Home'];
        var map = <String, dynamic>{"name": "Home", "type": 0, "path": home};
        var item = ListItem.fromMap(map);
        expect(item.equals(ListItem('Home', Type.Folder, home)), isTrue);
      });
      test('Rename', () {
        var newName = 'HelloWorld';
        var item = ListItem('nexis', Type.Folder, Platform.environment['HOME']);
        item.rename(newName);
        var rename = '/home/$newName';
        expect(rename, item.path);
      });
    });
    group('FileItem ', () {
      test('FromMap', () async {
        var json = <String, dynamic>{
          'file': '${Platform.environment['HOME']}/hello_world.txt'
        };
        var file = FileItem.fromMap(json);
        (await File(json['file']).exists())
            ? print('File Exists')
            : await File(json['file']).create();
        expect(file.equals(FileItem(file: File(json['file']))), isTrue);
      });
      test('Rename', () async {
        var path = '${Platform.environment['HOME']}/helloWorld.txt';

        (await File(path).exists())
            ? print('File Exists')
            : await File(path).create();

        var file = FileItem(file: File('$path'));
        print(file.fileName);
        var newName = 'OldWorld.txt';
        var newPath = '${Platform.environment['HOME']}/$newName';

        file.rename(newName);
        expect(file.path, newPath);
      });
    });
    group('DirectoyItem ', () {
      test('FromMap', () async {
        var json = <String, dynamic>{
          'name': 'hello_world',
          'path': '${Platform.environment['HOME']}/hello_world'
        };
        var file = DirectoryItem.fromMap(json);
        (await Directory(json['path']).exists())
            ? print('Directory Exists')
            : await Directory(json['path']).create();
        expect(
            file.equals(DirectoryItem(root: Directory(json['path']))), isTrue);
      });
      test('Rename', () async {
        var path = '${Platform.environment['HOME']}/helloWorld';

        var root = await Directory(path).create();
        var file = DirectoryItem(root: root);

        var newName = 'OldWorld';
        var newPath = '${Platform.environment['HOME']}/$newName';

        file.rename(newName);
        expect(file.path, newPath);
      });
    });
    group('Device ', () {
      test('FromMap', () {
        var map = <String, dynamic>{
          'root': '',
          'name': '',
          'state': DeviceState.Mounted.index,
          'type': DeviceType.External.index,
          'canUnmount': true
        };
        var device = Device(
            path: '',
            type: DeviceType.External,
            state: DeviceState.Mounted,
            canUnmount: true);
        expect(Device.fromMap(map).equals(device), isTrue);
      });
    });
  });
}
