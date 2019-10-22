import 'dart:io';

import 'package:flutter/material.dart';

/// Represents the current/previous directories.
///
/// [DirChanger] - Represent a simplistic history of the navigation, mostly
/// it keeps track of the directory currently being used, and the directory
/// that was just navigated from.
class DirChanger extends ChangeNotifier {
  /// The present working directory.
  ///
  /// [pwd] - The path to the current directory being worked in.
  String _pwd = Platform.environment['HOME'];
  String get pwd => _pwd;
  set pwd(String nwd) {
    _pwd = nwd;
    notifyListeners();
  }

  /// The root of the current directory.
  ///
  /// [root] - The root directory of the current directory being viewed.
  Directory _root = Directory(Platform.environment['HOME']);
  Directory get root => _root;
  set root(Directory nRoot) {
    _root = nRoot;
    pwd = nRoot.path;
    notifyListeners();
  }

  /// The previously accessed directory.
  ///
  /// [previous] - The previously accessed directory, defaults to home.
  Directory _previous = Directory(Platform.environment['HOME']);
  Directory get previous => _previous;
  set previous(Directory prev) {
    _previous = prev;
    notifyListeners();
  }
}
