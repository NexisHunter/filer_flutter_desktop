import 'package:filer_flutter_desktop/state/dir_changer_bloc.dart';
import 'package:filer_flutter_desktop/state/favs_bloc.dart';
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_filer/blocs/dir_changer_bloc.dart';
// import 'package:flutter_filer/blocs/favs_bloc.dart';
// import 'package:flutter_filer/blocs/file_bloc.dart';
// import 'package:flutter_filer/blocs/settings_bloc.dart';
import 'package:provider/provider.dart';

class FavsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer4<FilesBloc, DirChangerBloc, SettingsBloc, FavsBloc>(
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
