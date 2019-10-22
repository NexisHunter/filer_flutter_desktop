import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  _runCommand(String cmd, List<String> args) => Process.run(cmd, args);
  _getName(String file) =>
      file.substring(file.lastIndexOf(Platform.pathSeparator) + 1);

  group('Setting up Files', () {
    Files files;
    test('Default Setup is files empty', () {
      files = Files();
      expect(files.files, []);
    });

    group('Updates files on directory Change with ', () {
      files = Files();
      test('not showing hidden files', () async {
        files = Files();
        var current = Directory.current;
        await files.updateFiles(current, false);

        var pwdList = current.listSync();
        var list = <ListItem>[];

        for (var item in pwdList) {
          if (_getName(item.path).startsWith('.')) continue;
          list.add((await FileSystemEntity.isDirectory(item.path))
              ? DirectoryItem(root: Directory(item.path))
              : FileItem(file: File(item.path)));
        }

        files.files.sort((a, b) => a.compareTo(b));
        list.sort((a, b) => a.compareTo(b));

        var matches = files.files.length == list.length;
        if (matches) {
          for (var i = 0; i < files.files.length; i++) {
            matches = files.files[i].path == list[i].path;
          }
        }
        expect(matches, isTrue);
      });

      test('showing hidden files', () async {
        files = Files();
        var current = Directory.current;
        await files.updateFiles(current, true);

        var pwdList = current.listSync();
        var list = <ListItem>[];

        for (var item in pwdList) {
          // if (_getName(item.path).startsWith('.')) continue;
          list.add((await FileSystemEntity.isDirectory(item.path))
              ? DirectoryItem(root: Directory(item.path))
              : FileItem(file: File(item.path)));
        }

        files.files.sort((a, b) => a.compareTo(b));
        list.sort((a, b) => a.compareTo(b));

        var matches = files.files.length == list.length;
        if (matches) {
          for (var i = 0; i < files.files.length; i++) {
            matches = files.files[i].path == list[i].path;
          }
        }
        expect(matches, isTrue);
      });
    });
  });
}
