import 'package:filer_flutter_desktop/main.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FilesView ', () {
    var myApp = MyApp(SettingsBloc(), FavsBloc());
    // Assumes home folder has something in it, which is generally the case.
    testWidgets('is not empty upon startup', (tester) async {
      await tester.pumpWidget(myApp);
      // InkWell represents the clickable area of the file.
      expect(find.byType(InkWell), findsWidgets);
    });
  });
}
