import 'dart:io';

import 'package:filer_flutter_desktop/state/dir_changer_bloc.dart';
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:filer_flutter_desktop/state/settings_bloc.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_filer/blocs/dir_changer_bloc.dart';
// import 'package:flutter_filer/blocs/file_bloc.dart';
// import 'package:flutter_filer/blocs/settings_bloc.dart';
import 'package:provider/provider.dart';

class DirChanger extends StatefulWidget {
  _DirChangeState createState() => _DirChangeState();
}

class _DirChangeState extends State<DirChanger> {
  final dirField = TextEditingController();
  var textFlex = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<DirChangerBloc>(builder: (context, dir, child) {
      dirField.text = dir.pwd;
      return Expanded(
        flex: textFlex,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              if (dir.root != null && ((dir.root.path != '/storage' && Platform.isAndroid) ||
                  dir.root.path != '/'))
                Consumer2<FilesBloc, SettingsBloc>(
                    builder: (context, files, prefs, child) => IconButton(
                          icon: Icon(Icons.navigate_before),
                          onPressed: () {
                            print(dir.root.parent.path);
                            print(dir.root.parent.parent.path);
                            // if (dirField.text != '/storage/emulated/0')
                            dir.previous = dir.root;
                            dir.root = dir.root.parent;
                            // else
                            //   dir.root = Directory('/storage');
                            files.updateFiles(dir.root, prefs.showHidden);
                            dirField.text = dir.pwd;
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                        )),
              Expanded(
                child: TextField(
                  controller: dirField,
                  onTap: () => setState(() {
                    textFlex =
                        4; // Used to allow for a large view when using mobile devices or on smaller tablets that don't have much screen realestate
                  }),
                ),
              ),
              Consumer2<FilesBloc, SettingsBloc>(
                  builder: (conetxt, files, prefs, child) => IconButton(
                        icon: Icon(Icons.navigate_next),
                        onPressed: () {
                          if (dir.root != null &&
                              dirField.text == dir.root.path &&
                              (dir.previous != dir.root ||
                                  dir.previous != null)) {
                            final oldRoot = dir.root;
                            dir.root = dir.previous;
                            dir.previous = oldRoot;
                          } else {
                            dir.root = _cwd(dirField.text, dir.root);
                          }
                          files.updateFiles(dir.root, prefs.showHidden);
                          dirField.text = dir.pwd;
                          textFlex = 1;
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      ))
            ],
          ),
        ),
      );
    });
  }

  bool _parent(String nwd) {
    return nwd == '..${Platform.pathSeparator}';
  }

  Directory _cwd(String nwd, Directory root) {
    String path;
    if (_parent(nwd)) {
      return root.parent;
    } else if (nwd.startsWith('./')) {
      path = nwd.substring(1);
      return Directory('${root.path}$path');
    } else if (nwd.startsWith('../')) {
      path = nwd.substring(2);
      return Directory('${root.path}/$path');
    } else {
      return Directory(nwd);
    }
  }
}
