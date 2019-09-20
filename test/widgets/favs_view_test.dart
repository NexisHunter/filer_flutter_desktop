import 'package:filer_flutter_desktop/main.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavsView ', () {
    var myApp = MyApp(SettingsBloc(), FavsBloc());
    testWidgets('is not empty with default settings', (tester) async {
      await tester.pumpWidget(myApp);
      expect(find.byType(Card), findsWidgets);
    });
    testWidgets('long press removes favourite', (tester) async {
      await tester.pumpWidget(myApp);

      var originalSize = myApp.favs.favs.length;
      var widget = find.byType(Card).first;
      await tester.longPress(widget);
      await tester.pump();

      var newSize = myApp.favs.favs.length;
      expect(newSize, originalSize - 1);
    });
  });
}
