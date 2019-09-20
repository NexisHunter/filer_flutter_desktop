import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Setting up FavsBloc: ', () {
    FavsBloc favsBloc;
    test('Default setup', () {
      favsBloc = FavsBloc();
      var favs = <DirectoryItem>[
        for (var fav in <String>[
          'Documents',
          'Downloads',
          'Music',
          'Pictures',
          'Videos'
        ])
          DirectoryItem(root: Directory('${Platform.environment['HOME']}/$fav'))
      ];

      expect(favsBloc.equals(otherFavs: favs), true);
    });
    test('From Map', () {
      var favsMap = <String, String>{'Home': Platform.environment['HOME']};
      favsBloc = FavsBloc.fromMap(favsMap);
      expect(favsBloc.favs[0].path, favsMap['Home']);
    });
    test('Default toMap', () {
      favsBloc = FavsBloc();

      var favs = <DirectoryItem>[
        for (var fav in <String>[
          'Documents',
          'Downloads',
          'Music',
          'Pictures',
          'Videos'
        ])
          DirectoryItem(root: Directory('${Platform.environment['HOME']}/$fav'))
      ];

      var favsMap = <String, dynamic>{
        "favourites": {},
      };
      for (var fav in favs) {
        favsMap['favourites'].addAll({fav.name: fav.path});
      }

      expect(favsBloc.toMap(), favsMap);
    });
  });
  group('FavsBloc functionality: ', () {
    FavsBloc favsBloc;
    test('Pin', () {
      favsBloc = FavsBloc();
      var favs = favsBloc.favs;
      var toAdd =
          DirectoryItem(root: Directory('${Platform.environment['HOME']}'));
      favs.add(toAdd);
      favs.sort((a, b) => a.compareTo(b));
      favsBloc.pin(toAdd);
      expect(favsBloc.equals(otherFavs: favs), isTrue);
    });
    test('Unpin', () {
      favsBloc = FavsBloc();
      var favs = favsBloc.favs;
      var toRemove = DirectoryItem(
          root: Directory('${Platform.environment['HOME']}/Documents'));
      favs.remove(toRemove);
      favs.sort((a, b) => a.compareTo(b));
      favsBloc.pin(toRemove);
      expect(favsBloc.equals(otherFavs: favs), isTrue);
    });
    test('Contains', () {
      favsBloc = FavsBloc();
      var toFind = DirectoryItem(
          root: Directory('${Platform.environment['HOME']}/Documents'));
      expect(favsBloc.contains(toFind), 0);
    });
  });
}
