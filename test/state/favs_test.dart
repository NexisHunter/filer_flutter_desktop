import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Setting up Favs: ', () {
    Favs favs;
    test('Default setup', () {
      favs = Favs();

      var defaults = <String>[
        'Documents',
        'Downloads',
        'Music',
        'Pictures',
        'Videos'
      ];
      var favsList = <DirectoryItem>[
        for (var fav in defaults)
          DirectoryItem(
            root: Directory(
                '${Platform.environment['HOME']}${Platform.pathSeparator}$fav'),
          ),
      ];
      var favs2 = Favs()..favs = favsList;
      expect(favs == favs2, isTrue);
    });
    test('From Map', () {
      var favsMap = <String, String>{'Home': Platform.environment['HOME']};
      favs = Favs.fromMap(favsMap);
      expect(favs.favs[0].path, favsMap['Home']);
    });
    test('Default toMap', () {
      favs = Favs();

      var favsList = <DirectoryItem>[
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

      var favsMap = <String, dynamic>{
        "favourites": {},
      };
      for (var fav in favsList) {
        favsMap['favourites'].addAll({fav.name: fav.path});
      }

      expect(favs.toMap(), favsMap);
    });
  });
  group('Favs functionality: ', () {
    Favs favs;
    test('Pin', () {
      favs = Favs();
      var favList = favs.favs;
      var toAdd =
          DirectoryItem(root: Directory('${Platform.environment['HOME']}'));
      favList.add(toAdd);
      favList.sort((a, b) => a.compareTo(b));
      favs.pin(toAdd);
      expect(favs.favs == favList, isTrue);
    });
    test('Unpin', () {
      favs = Favs();
      var favsList = favs.favs;
      var toRemove = DirectoryItem(
          root: Directory(
              '${Platform.environment['HOME']}${Platform.pathSeparator}Documents'));
      favsList.remove(toRemove);
      favsList.sort((a, b) => a.compareTo(b));
      favs.unpin(toRemove);
      expect(favs.favs == favsList, isTrue);
    });
    test('Contains', () {
      favs = Favs();
      var toFind = DirectoryItem(
          root: Directory(
              '${Platform.environment['HOME']}${Platform.pathSeparator}Documents'));
      expect(favs.contains(toFind), isTrue);
    });
  });
}
