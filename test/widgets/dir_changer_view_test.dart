import 'dart:io';

import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:filer_flutter_desktop/widgets/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DirChanger ', () {
    // DirChanger changer;
    var myApp;
    setUpAll(() {
      myApp = MyApp(Settings(), Favs());
    });
    testWidgets('Home in Address Bar Upon Start', (tester) async {
      await tester.pumpWidget(myApp);

      expect(find.text(Platform.environment['HOME']), findsOneWidget);
    });
    testWidgets('Remove the back button at root of device', (tester) async {
      await tester.pumpWidget(myApp);

      var icon = Icons.navigate_before;
      // Navigate to Root
      await tester.tap(find.byIcon(icon));
      await tester.pump();
      await tester.tap(find.byIcon(icon));
      await tester.pump();

      expect(find.text('/'), findsOneWidget);
      expect(find.byIcon(icon), findsNothing);
    });
    testWidgets(
        'Clicking the forward button without changing the directory does nothing.',
        (tester) async {
      await tester.pumpWidget(myApp);
      var icon = Icons.navigate_next;

      // Click the next button
      await tester.tap(find.byIcon(icon));
      await tester.pump();

      expect(find.text(Platform.environment['HOME']), findsOneWidget);
    });
  });
}
