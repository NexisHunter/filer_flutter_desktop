import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Type ', () {
    group('ListIem ', () {
      test('fromMap', () {
        var home = Platform.environment['Home'];
        var map = <String, dynamic>{"name": "Home", "type": 0, "path": home};
        var item = ListItem.fromMap(map);
        expect(item.equals(ListItem('Home', Type.Folder, home)), isTrue);
      });
    });
    group('FileItem ', () {});
  });
}
