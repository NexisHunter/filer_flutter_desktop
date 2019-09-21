import 'dart:io';

//----------------------- File System ---------------------------------------\\
class ListItem extends Comparable<ListItem> {
  String name;
  String fileName;
  Type type;
  String path;
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
    type = Type.values[json['type'] as int];
    path = json['path'];
  }
  rename(String _name) {
    path.replaceAll(fileName, _name);
    name.replaceAll(fileName, _name);
  }

  equals(ListItem other) {
    return path == other.path;
  }
}

class FileItem extends ListItem {
  File file = File("");
  FileItem({this.file}) : super(_getName(file: file), Type.File, file.path);
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
    file.rename(path.replaceAll(fileName, _name));
  }
}

class DirectoryItem extends ListItem {
  Directory root = Directory("");
  DirectoryItem({this.root})
      : super(_getName(filePath: root.path), Type.Folder, root.path);
  @override
  Map<String, String> toMap() {
    return {'root': root.path};
  }

  @override
  fromMap(Map<String, dynamic> json) {
    return DirectoryItem(root: Directory(json['root']));
  }

  @override
  rename(String _name) {
    root.rename(path.replaceAll(fileName, _name));
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
class Device {
  // Directory root = Directory("");
  String path = "";
  String name = "";
  DeviceState state = DeviceState.Mounted;
  DeviceType type = DeviceType.External;
  bool canUnmount = true;

  Device({this.path, this.type, this.state, this.canUnmount})
      : name = _getName(filePath: path);

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

enum DeviceState { Mounted, Unmounted }
enum DeviceType {
  Interal, // The disk/ partition on the disk
  External // Ex. USB
}
