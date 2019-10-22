import 'dart:io';

import 'package:filer_flutter_desktop/list_item.dart';
import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The visual setup of the favourites list.
///
/// [FavsView] represents the visual display of the favourites list.
class FavsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<Files, DirChanger, Settings, Favs>(
      builder: (context, files, dir, prefs, favs, child) => Container(
        child: Column(
          children: <Widget>[
            for (var item in favs.favs)
              _buildFav(
                  item, prefs.showHidden, files.updateFiles, favs.unpin, dir),
          ],
        ),
      ),
    );
  }

  /// Build the visual representation of the favourited iitem.
  ///
  /// [item] - The favourite to be added.
  /// [showHidden] - Flag to show hiddden files.
  /// [onTap] - Void callback to handle the onTap.
  /// [longPress] - Void callback to handle the onLongpress.
  Widget _buildFav(
      DirectoryItem item,
      bool showHidden,
      Future<void> onTap(Directory root, bool showHidden),
      void longPress(DirectoryItem item),
      DirChanger dir) {
    return Card(
        child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                item.name,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        dir.root = item.root;
        onTap(item.root, showHidden);
      },
      onLongPress: () => longPress(item),
    ));
  }
}
