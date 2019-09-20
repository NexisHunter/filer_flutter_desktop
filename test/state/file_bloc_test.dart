import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  _runCommand(String cmd, List<String> args) => Process.run(cmd, args);
  _getName(String file) => file.substring(file.lastIndexOf('/') + 1);

  group('Setting up FilesBloc', () {
    FilesBloc files;
    test('Default Setup is files empty', () {
      files = FilesBloc();
      expect(files.files, []);
    });

    group('Updates files on directory Change with ', () {
      files = FilesBloc();
      test('not showing hidden files', () async {
        files = FilesBloc();
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
        files = FilesBloc();
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
