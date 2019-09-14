
import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  group('Setting up: ', (){
    test('Default setup',(){
      var favsBloc = FavsBloc();
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
      
      expect(favsBloc.favs, favs);
    });
  });
}