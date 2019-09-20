import 'dart:io';

import 'package:filer_flutter_desktop/state/dir_changer_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dir Changer Bloc: ', () {
    DirChangerBloc changer;
    group('Default Set Up ', () {
      test('Root is equal to \$HOME variable', () {
        changer = DirChangerBloc();
        expect(changer.root.path, Platform.environment['HOME']);
      });
      test('Present Working Directory is equal to \$HOME variable', () {
        changer = DirChangerBloc();
        expect(changer.pwd, Platform.environment['HOME']);
      });
      test('Previous Directory is equal to \$HOME variable', () {
        changer = DirChangerBloc();
        expect(changer.previous.path, Platform.environment['HOME']);
      });

    });
  });
}
