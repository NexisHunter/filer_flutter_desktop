import 'dart:io';

import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:filer_flutter_desktop/utils.dart';

/// Displays the UI that will allow for navigation of the filesystem.
///
/// [DirChangerView] - The view that contains the ability to navigate the
/// filesystem.
class DirChangerView extends StatefulWidget {
  _DirChangeState createState() => _DirChangeState();
}

class _DirChangeState extends State<DirChangerView> {
  final dirField = TextEditingController();
  var textFlex = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer2<DirChanger, Settings>(
        builder: (context, dir, prefs, child) {
      dirField.text = dir.pwd;
      return Expanded(
        flex: textFlex,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              if (dir.root != null &&
                  ((dir.root.path != '/storage' && Platform.isAndroid) ||
                      dir.root.path != '/'))
                _createNavButton(
                    Icons.navigate_before, true, dir, prefs.showHidden),
              _createAddressBar(),
              _createNavButton(
                  Icons.navigate_next, false, dir, prefs.showHidden),
            ],
          ),
        ),
      );
    });
  }

  /// Checks if the path is the short hand for the parent directory.
  ///
  /// [nwd] - The path to check.
  bool _isParent(String nwd) {
    return nwd == '..${Platform.pathSeparator}';
  }

  /// Change the current working directory.
  ///
  /// [nwd] - The directory to change into.
  /// [root] - The current working directory.
  Directory _cwd(String nwd, Directory root) {
    String path;
    if (_isParent(nwd)) {
      return root.parent;
    } else if (nwd.startsWith('.${Platform.pathSeparator}')) {
      path = nwd.substring(1);
      return Directory('${root.path}$path');
    } else if (nwd.startsWith('..${Platform.pathSeparator}')) {
      path = nwd.substring(2);
      return Directory('${root.parent.path}${Platform.pathSeparator}$path');
    } else {
      return Directory(nwd);
    }
  }

  /// Creates a navigation button to click on.
  ///
  /// [navigation] -  Which way to navigate, either to the previous working
  /// directory or the parent directory, or to procceed into the new
  /// destination directory.
  /// [checkRoot] - Flag to check for root directory.
  /// [showHidden] - The flag whether or not to show hidden files.
  Widget _createNavButton(
      IconData navigation, bool checkRoot, DirChanger dir, bool showHidden) {
    return Consumer<Files>(
      builder: (context, files, child) => IconButton(
        icon: Icon(
          navigation,
        ),
        onPressed: () =>
            _updatePath(dir, context, files, showHidden, checkRoot),
      ),
    );
  }

  /// Update the path from the interation.
  ///
  /// [dir] - The current working directory handler.
  /// [context] -
  /// [files] - The current list of files.
  /// [showHidden] - The flag whether or not to show hidden files.
  /// [checkRoot] - Used to verify that the navigation does not go past the root directory
  void _updatePath(DirChanger dir, BuildContext context, Files files,
      bool showHidden, bool checkRoot) {
    final curr = dir.root;

    if (checkRoot) {
      // Handle nav back to parent.
      if (curr.path == dirField.text) {
        if (curr.parent != null) {
          if (dir.previous.path == curr.path || dir.previous == null) {
            dir.root = curr.parent;
            dir.previous = curr;
          } else {
            print(dir.previous.path);
            dir.root = dir.previous;
            dir.previous = curr;
          }
        }
      }
    } else {
      dir.root = _cwd(dirField.text, curr);
    }

    files.updateFiles(dir.root, showHidden);
    dirField.text = dir.pwd;
    textFlex = 1;
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Creates the address bar that will display the current working directory.
  Widget _createAddressBar() {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.multiline,
        controller: dirField,
        onTap: () => setState(() {
          if (Platform.isAndroid) textFlex = 2;
          dirField.setCursor(
            dirField.text,
            dirField.text.length - 1,
          );
          // Used to allow for a large view when using mobile devices
          // or on smaller tablets that don't have much screen
          // realestate
        }),
      ),
    );
  }
}
