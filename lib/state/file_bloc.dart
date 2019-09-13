import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class FilesBloc with ChangeNotifier {
  List<ListItem> _files = [];
  List<ListItem> get files => _files;

  /// Updates the list of files to match the [nwd].
  ///
  /// [nwd] new working directory.
  /// [showHidden] if true shows files starting with "."
  Future<void> updateFiles(Directory nwd, bool showHidden) async {
    var folders = <DirectoryItem>[];

    final items = nwd.listSync();
    for (var item in items) {
      if (await FileSystemEntity.type(item.path) !=
          FileSystemEntityType.directory) continue;
        // Fetch the directories in the given directory
        // final folders = await FileManager.listDirectories(nwd);
        final dir = DirectoryItem(root: item as Directory);
        if (dir.root.path == '/storage/self' && Platform.isAndroid) continue;
        if (!showHidden && dir.name.startsWith('.')) continue;
        folders.add(dir);
    }

    folders.sort((a, b) => a.compareTo(b));

    var fList = <FileItem>[];

    for (var item in items) {
      if (await FileSystemEntity.type(item.path) != FileSystemEntityType.file)
        continue;
      // Fetch the files in the given directory
      // final files = await FileManager.listFiles(nwd.path);
      final nF = FileItem(file: item as File);
      if (!showHidden && nF.name.startsWith('.')) continue;
      final lastIndex = nF.name.lastIndexOf('.');
      nF.fileName =
          nF.name.substring(0, (lastIndex != 0 && lastIndex != -1) ? lastIndex : nF.name.length);
      fList.add(nF);
    }

    fList.sort((a, b) => a.compareTo(b));

    _files = <ListItem>[] + folders + fList;
    notifyListeners();
  }

  /// Deletes [item] from the current directory.
  void removeFile(ListItem item) {
    switch (item.type) {
      case Type.Folder:
        (item as DirectoryItem).root.deleteSync();
        break;
      default:
        (item as FileItem).file.deleteSync();
        break;
    }
    _files.remove(item);
    notifyListeners();
  }

  /// Handles the creation of a new fie of [type] with [name] in current [path].
  ///
  createNew(String name, Type type, String path) {
    switch (type) {
      case Type.File:
        final count = _getOccurrances(name);
        _createFile('$path/$name', '', count);
        notifyListeners();
        break;
      case Type.TXT:
        final count = _getOccurrances(name);
        _createFile('$path/$name', '.txt', count);
        notifyListeners();
        break;
      case Type.HTML:
        final count = _getOccurrances(name);
        _createFile('$path/$name', '.html', count);
        notifyListeners();
        break;
      case Type.Folder:
        final count = _getOccurrances(name);
        _createDir('$path/$name', count);
        notifyListeners();
        break;
    }
  }

  /// Helper method to create a new file of [type] in the current directory.
  ///
  _createFile(String path, String type, int count) {
    final file = File('$path${(count == 0) ? "" : count}$type');
    file.createSync();
    _files.add(FileItem(file: file));
    sort();
  }

  _createDir(String path, int count) {
    final dir = Directory('$path${(count == 0) ? "" : count}');
    dir.createSync();
    _files.add(DirectoryItem(root: dir));
    sort();
  }

  /// Retrieves the number of occurrences of the file with the [name] in the
  /// current directory.
  ///
  _getOccurrances(String name) {
    var count = 0;
    for (var file in _files) {
      if (file.fileName.startsWith(name)) count++;
    }
    return count;
  }

  /// A custom sort to prioritize folders first.
  ///
  sort() {
    final folders = <DirectoryItem>[];
    final files = <FileItem>[];

    for (var file in _files) {
      if (file.type == Type.Folder)
        folders.add(file);
      else
        files.add(file);
    }

    // Use default sort on the 2 sub lists as is preferred sort type
    folders.sort();
    files.sort();

    // Merge sorted lists
    _files = <ListItem>[] + folders + files;
    notifyListeners();
  }
}
