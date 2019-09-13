import 'dart:io';

import 'package:flutter/material.dart';

class DirChangerBloc extends ChangeNotifier {
  String _pwd = Platform.environment['HOME'];
  String get pwd => _pwd;
  set pwd(String nwd) {
    _pwd = nwd;
    notifyListeners();
  }

  Directory _root = Directory(Platform.environment['HOME']);
  Directory get root => _root;
  set root(Directory nRoot) {
    _root = nRoot;
    pwd = nRoot.path;
    notifyListeners();
  }

  Directory _previous = Directory(Platform.environment['HOME']);
  Directory get previous => _previous;
  set previous(Directory prev) {
    _previous = prev;
    notifyListeners();
  }
}
