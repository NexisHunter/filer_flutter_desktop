import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';

/// Represents the list of favourited directories.
///
/// [Favs] - Contains the list of favourited directories as well as a preferred way to
class Favs extends ChangeNotifier {
  /// The basic constructor that build the default list of favourites.
  Favs()
      : _favs = [
          for (var fav in <String>[
            'Documents',
            'Downloads',
            'Music',
            'Pictures',
            'Videos'
          ])
            DirectoryItem(
                root: Directory(
                    '${Platform.environment['HOME']}${Platform.pathSeparator}$fav'))
        ];

  /// Builds the favourites list based off of the user's saved preferences.
  Favs.fromMap(Map<String, dynamic> json) {
    for (var key in json.keys) {
      _favs.add(DirectoryItem(root: Directory(json[key])));
    }
  }

  /// The list of favourites created by the user.
  ///
  /// [favs] - The list of currently favourited directories on/off of the
  /// filesystem.
  List<DirectoryItem> _favs = [];
  List<DirectoryItem> get favs => _favs;
  set favs(List<DirectoryItem> nfvs) {
    _favs = nfvs;
    notifyListeners();
  }

  /// Unpins a given directory from the favourites list.
  ///
  /// [item] - The folder that is to be removed from the list of favourites.
  /// Sorted by the preferred method.
  void unpin(DirectoryItem item) {
    final newFavs = <DirectoryItem>[];

    for (var fav in _favs) {
      if (fav.path == item.path) continue;
      newFavs.add(fav);
    }
    _favs = newFavs;
    sort();
  }

  /// Pins a directory to the favourites list.
  ///
  /// [fav] - The directory to be added to the favourites list.
  /// Sorted by the preferred method.
  void pin(DirectoryItem fav) {
    _favs.add(fav);
    sort();
  }

  /// Sorts the favourites list based off of the preferred sort setting.
  ///
  /// [sort] - Sorts the directories based off of the preferred setting.
  /// Default -> Alphabetically.
  void sort() {
    // TODO: Add other methods of sorting.
    _favs.sort((a, b) => a.compareTo(b));
    notifyListeners();
  }

  /// Checks to see if the given directory is in the favourites list.
  ///
  /// [folder] - The folder to look for in the list of favourites.
  bool contains(DirectoryItem folder) {
    for (var fav in _favs) {
      if (fav.compareTo(folder) == 0) return true;
    }
    return false;
  }

  /// Formats the object into a json object.
  ///
  /// [toMap] - Parse the object into json compatible format to be used to save
  /// the user preferred favourites.
  Map<String, dynamic> toMap() {
    final mappedFavs = <String, String>{};
    for (final fav in _favs) {
      mappedFavs.addAll({'${fav.name}': '${fav.path}'});
    }
    return {"favourites": mappedFavs};
  }

  @override
  operator ==(other) {
    if (favs.length != other.favs.length) return false;
    final length = favs.length;
    for (var i = 0; i < length; i++) {
      if (favs[i].path != other.favs[i].path) return false;
    }
    return true;
  }

  @override
  int get hashCode => super.hashCode;
}
