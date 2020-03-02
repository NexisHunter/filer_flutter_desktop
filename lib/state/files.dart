import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';

/// Represents the list of files and directories of the current directory.
///
/// [Files] contains the list of files and directories within the current
/// working directory, it also houses the ability to create new files and
/// directories on the filesystem.
class Files with ChangeNotifier {
  /// The list of current files in the working directory.
  ///
  /// [files] - The list of files and directories in the current working
  /// directory.
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
      final nF = FileItem(file: item as File);
      if (!showHidden && nF.name.startsWith('.')) continue;
      final lastIndex = nF.name.lastIndexOf('.');
      nF.fileName = nF.name.substring(
          0, (lastIndex != 0 && lastIndex != -1) ? lastIndex : nF.name.length);
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
  /// [name] - The name of the document to be created.
  /// [type] - What kind of document is being created.
  /// [path] - The path to the document to be created.
  createNew(String name, Type type, String path) {
    switch (type) {
      case Type.File:
        final count = _getOccurrances(name);
        _createFile('$path${Platform.pathSeparator}$name', '', count);
        notifyListeners();
        break;
      case Type.TXT:
        final count = _getOccurrances(name);
        _createFile('$path${Platform.pathSeparator}$name', '.txt', count);
        notifyListeners();
        break;
      case Type.HTML:
        final count = _getOccurrances(name);
        _createFile('$path${Platform.pathSeparator}$name', '.html', count);
        notifyListeners();
        break;
      case Type.Folder:
        final count = _getOccurrances(name);
        _createDir('$path${Platform.pathSeparator}$name', count);
        notifyListeners();
        break;
      default:
        // TODO: Parse out file . to get file type and assign that as file extension
        // TODO: Parse out name.
        notifyListeners();
        break;
    }
  }

  /// Helper method to create a new file of [type] in the current directory.
  ///
  /// [path] - The path to the given file.
  /// [extensionType] - The file extension.
  /// [count] - The number of occurrences of the document.
  _createFile(String path, String extensionType, int count) {
    final file = File('$path${(count == 0) ? "" : "($count)"}$extensionType');
    file.createSync();
    _files.add(FileItem(file: file));
    sort();
  }

  /// Helper method to create a new child directory.
  ///
  /// [path] - The path of the child directory.
  /// [count] - The number of occurrences of the folder.
  _createDir(String path, int count) {
    final dir = Directory('$path${(count == 0) ? "" : "($count)"}');
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

  /// Sorts the files and folders based of a preset defaults to alphabetically.
  sort() {
    final folders = <DirectoryItem>[];
    final files = <FileItem>[];

    for (var file in _files) {
      if (file.type == Type.Folder)
        folders.add(file);
      else
        files.add(file);
    }

    // TODO: Handle sorting methods.
    // Use default sort on the 2 sub lists as is preferred sort type
    folders.sort();
    files.sort();

    // Merge sorted lists
    _files = <ListItem>[] + folders + files;
    notifyListeners();
  }

  /// How the files and directories are sorted.
  ///
  /// [sortType] - How to sort the files, etc.
  /// Default -> Folders first, alphabetically.
  /// Reverse -> Folders first, reverse alphabetically.
  /// FilesFirst -> Files first, alphabetically.
  /// FilesReverse -> Files first, reverse alphabetically.
  String _sortType = 'Default';
  String get sortType => _sortType;
  set sortType(String type) {
    _sortType = type;
    notifyListeners();
  }
}
