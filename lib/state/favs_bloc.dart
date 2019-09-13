import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';

class FavsBloc extends ChangeNotifier {
  FavsBloc();
  List<DirectoryItem> _favs = [
    for (var fav in <String>[
      'Documents',
      'Downloads',
      'Music',
      'Pictures',
      'Videos'
    ])
      DirectoryItem(root: Directory('${Platform.environment['HOME']}/$fav'))
  ];
  List<DirectoryItem> get favs => _favs;
  set favs(List<DirectoryItem> nfvs) {
    _favs = nfvs;
    notifyListeners();
  }

  unpin(DirectoryItem item) {
    final newFavs = <DirectoryItem>[];

    for (var fav in _favs) {
      if (fav.path == item.path) continue;
      newFavs.add(fav);
    }
    _favs = newFavs;
    sort();
  }

  pin(DirectoryItem fav) {
    _favs.add(fav);
    sort();
  }

  sort() {
    _favs.sort((a, b) => a.compareTo(b));
    notifyListeners();
  }

  contains(DirectoryItem folder) {
    for (var fav in _favs) {
      if (fav.compareTo(folder) == 0) return 0;
    }
    return -1;
  }

  toMap() {
    final mappedFavs = <String, String>{};
    for (final fav in _favs) {
      mappedFavs.addAll({'${fav.name}': '${fav.path}'});
    }
    return {"favourites": mappedFavs};
  }

  fromMap(Map<String, dynamic> favs) {
    final newFavs = <DirectoryItem>[];
    for (final key in favs.keys) {
      newFavs.add(DirectoryItem(root: Directory(favs[key])));
    }
    _favs = newFavs;
    notifyListeners();
  }
}
