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
        expect(item == ListItem('Home', Type.Folder, home), isTrue);
      });
      test('Rename', () async {
        var path =
            "${Platform.environment['HOME']}${Platform.pathSeparator}nexis";
        var folder = Directory(path);
        if (!await folder.exists()) {
          await folder.create();
        }
        var newName = 'HelloWorld';
        var item = ListItem('nexis', Type.Folder, path);
        item.rename(newName);
        var rename =
            '${Platform.environment['HOME']}${Platform.pathSeparator}$newName';
        expect(item.path, rename);
      });
    });
    group('FileItem ', () {
      test('FromMap', () async {
        var json = <String, dynamic>{
          'file':
              '${Platform.environment['HOME']}${Platform.pathSeparator}hello_world.txt'
        };
        var file = FileItem.fromMap(json);
        (await File(json['file']).exists())
            ? print('File Exists')
            : await File(json['file']).create();
        expect(file == FileItem(file: File(json['file'])), isTrue);
      });
      test('Rename', () async {
        var path =
            '${Platform.environment['HOME']}${Platform.pathSeparator}helloWorld.txt';

        (await File(path).exists())
            ? print('File Exists')
            : await File(path).create();

        var file = FileItem(file: File('$path'));
        print(file.fileName);
        var newName = 'OldWorld.txt';
        var newPath =
            '${Platform.environment['HOME']}${Platform.pathSeparator}$newName';

        file.rename(newName);
        expect(file.path, newPath);
      });
    });
    group('DirectoyItem ', () {
      test('FromMap', () async {
        var json = <String, dynamic>{
          'name': 'hello_world',
          'path':
              '${Platform.environment['HOME']}${Platform.pathSeparator}hello_world'
        };
        var file = DirectoryItem.fromMap(json);
        (await Directory(json['path']).exists())
            ? print('Directory Exists')
            : await Directory(json['path']).create();
        expect(file == DirectoryItem(root: Directory(json['path'])), isTrue);
      });
      test('Rename', () async {
        var path =
            '${Platform.environment['HOME']}${Platform.pathSeparator}helloWorld';

        var root = await Directory(path).create();
        var file = DirectoryItem(root: root);

        var newName = 'OldWorld';
        var newPath =
            '${Platform.environment['HOME']}${Platform.pathSeparator}$newName';

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
        expect(Device.fromMap(map) == device, isTrue);
      });
    });
  });
}
