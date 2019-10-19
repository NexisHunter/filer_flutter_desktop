import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<Files, DirChanger, Settings, Favs>(
        builder: (context, files, dir, prefs, favs, child) => Container(
                child: Column(
              children: <Widget>[
                for (var item in favs.favs)
                  Card(
                      child: InkWell(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              item.name,
                              textAlign: TextAlign.center,
                            ))
                          ],
                        )),
                    onTap: () {
                      dir.root = item.root;
                      files.updateFiles(dir.root, prefs.showHidden);
                    },
                    onLongPress: () => favs.unpin(item),
                  ))
              ],
            )));
  }
}
