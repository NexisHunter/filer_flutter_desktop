import 'dart:io';

import 'package:filer_flutter_desktop/utils.dart';

//----------------------- File System ---------------------------------------\\
/// Builds a general file typing to allow for the combination of both files and
/// direcotries in a single list.
class ListItem extends Comparable<ListItem> {
  /// Default contructor to build the base item so that it can be assigned into
  /// a list.
  ListItem(this.name, this.type, this.path) : this.fileName = name;

  /// Uses a json object to build the list item.
  ListItem.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    fileName = json['name'];
    type = Type.values[json['type'] as int];
    path = json['path'];
  }

  String name = "";
  String fileName = "";
  Type type = Type.File;
  String path = "";

  int compareTo(other) {
    return path.compareTo(other.path);
  }

  /// Parses the object into a json compatible object.
  Map<String, String> toMap() {
    return {
      "name": name,
      "fileName": fileName,
      "type": type.index.toString(),
      "path": path
    };
  }

  /// Renames the current item to a new name.
  ///
  /// [_name] - The new name to be assigned.
  void rename(String _name) {
    var lastIndex = path.lastIndexOf(Platform.pathSeparator);
    path = path.substring(0, (lastIndex + 1));
    path = '$path$_name';
    name = _name;
  }

  operator ==(other) => path == other.path;

  int get hashCode => super.hashCode;
}

/// The File implementation of the [ListItem] so that it has a common base
/// class.
class FileItem extends ListItem {
  File file = File("");
  FileItem({this.file}) : super(getName(file: file), Type.File, file.path);
  FileItem.fromMap(Map<String, dynamic> json)
      : super(getName(filePath: json['file']), Type.File, json['file']) {
    file = File(json['file']);
  }

  @override
  toMap() {
    final mapped = super.toMap();
    mapped.addAll({"file": file.path});
    return mapped;
  }

  @override
  rename(String _name) {
    super.rename(_name);
    file.renameSync(path);
  }
}

/// The directory implementaion of [ListItem], so that it has a common class
/// with the file.
class DirectoryItem extends ListItem {
  Directory root = Directory("");
  DirectoryItem({this.root})
      : super(getName(filePath: root.path), Type.Folder, root.path);

  DirectoryItem.fromMap(Map<String, dynamic> json)
      : super(json['name'], Type.Folder, json['path']) {
    root = Directory(json['path']);
  }

  @override
  Map<String, String> toMap() {
    return {'root': root.path};
  }

  @override
  rename(String _name) async {
    super.rename(_name);
    if (!await root.exists()) await Directory(path).create();
    root.renameSync(path);
  }
}

enum Type { Folder, File, TXT, HTML }

// ------------------------ Device ------------------------------------------\\
/// Represents the volumes mounted/attached to the current device.
class Device {
  // Directory root = Directory("");
  String path = "";
  String name = "";
  DeviceState state = DeviceState.Mounted;
  DeviceType type = DeviceType.External;
  bool canUnmount = true;

  Device({this.path, this.type, this.state, this.canUnmount})
      : name = getName(filePath: path);

  Device.fromMap(Map<String, dynamic> json) {
    path = json['root'];
    name = json['name'];
    state = DeviceState.values[json['state']];
    type = DeviceType.values[json['type']];
    canUnmount = json['canUnmount'];
  }

  toMap() {
    return {
      "root": path,
      "name": name,
      "state": state.index,
      "type": type.index,
      "canUnmount": canUnmount
    };
  }

  // ignore: hash_and_equals
  operator ==(other) => path == other.path;

  int compareTo(other) {
    return path.compareTo(other.path);
  }
}

enum DeviceState {
  Mounted, // Attached as a file system.
  Unmounted // Attached but not mounted.
}

enum DeviceType {
  Interal, // The disk/ partition on the disk
  External // Ex. USB
}
