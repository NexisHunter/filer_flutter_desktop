import 'dart:io';

//----------------------- File System ---------------------------------------\\
/// Builds a general file typing to allow for the combination of both files and
/// direcotries in a single list.
class ListItem extends Comparable<ListItem> {
  String name = "";
  String fileName = "";
  Type type = Type.File;
  String path = "";
  ListItem(this.name, this.type, this.path) : this.fileName = name;

  int compareTo(other) {
    return path.compareTo(other.path);
  }

  Map<String, String> toMap() {
    return {
      "name": name,
      "fileName": fileName,
      "type": type.index.toString(),
      "path": path
    };
  }

  fromMap(Map<String, dynamic> json) {
    return ListItem(
        json['name'], Type.values[json['type'] as int], json['path']);
  }

  ListItem.fromMap(Map<String, dynamic> json) {
    name = json['name'];
    fileName = json['name'];
    type = Type.values[json['type'] as int];
    path = json['path'];
  }
  rename(String _name) {
    var lastIndex = path.lastIndexOf(Platform.pathSeparator);
    path = path.substring(0, (lastIndex + 1));
    path = '$path$_name';
    name = _name;
  }

  equals(ListItem other) {
    return path == other.path;
  }
}

class FileItem extends ListItem {
  File file = File("");
  FileItem({this.file}) : super(_getName(file: file), Type.File, file.path);
  FileItem.fromMap(Map<String, dynamic> json)
      : super(_getName(filePath: json['file']), Type.File, json['file']) {
    file = File(json['file']);
  }

  @override
  toMap() {
    final mapped = super.toMap();
    mapped.addAll({"file": file.path});
    return mapped;
  }

  @override
  fromMap(Map<String, dynamic> json) {
    return FileItem(file: json['file']);
  }

  @override
  rename(String _name) {
    super.rename(_name);
    file.renameSync(path);
  }
}

class DirectoryItem extends ListItem {
  Directory root = Directory("");
  DirectoryItem({this.root})
      : super(_getName(filePath: root.path), Type.Folder, root.path);

  DirectoryItem.fromMap(Map<String, dynamic> json)
      : super(json['name'], Type.Folder, json['path']) {
    root = Directory(json['path']);
  }

  @override
  Map<String, String> toMap() {
    return {'root': root.path};
  }

  @override
  fromMap(Map<String, dynamic> json) {
    return DirectoryItem(root: Directory(json['root']));
  }

  @override
  rename(String _name) async {
    super.rename(_name);
    if (!await root.exists()) await Directory(path).create();
    root.renameSync(path);
  }
}

String _getName({File file, Directory dir, String filePath}) {
  var path = "";
  if (file != null) {
    path = file.path;
  } else if (file != null) {
    path = dir.path;
  } else {
    path = filePath;
  }
  return path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
}

enum Type {
  Folder,
  File,
  TXT,
  HTML
  // TODO: ADD MORE TYPES
}

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
      : name = _getName(filePath: path);

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

  fromMap(Map<String, dynamic> json) => Device(
      path: json['root'],
      type: DeviceType.values[json['type']],
      state: DeviceState.values[json['state']],
      canUnmount: json['canUnmount']);

  equals(Device other) {
    return path == other.path;
  }

  compareTo(other) {
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
