import 'dart:io';

import 'package:flutter/material.dart';

class Settings with ChangeNotifier {
  String pwd = Platform.environment['HOME'];
}
