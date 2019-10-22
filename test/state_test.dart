/// This file acts as a runner of the test suite.

import './state/device_test.dart' as device;
import './state/dir_changer_test.dart' as dir_changer;
import './state/favs_test.dart' as favs;
import './state/file_test.dart' as files;
import './state/settings_test.dart' as settings;

void main() {
  device.main();
  dir_changer.main();
  favs.main();
  files.main();
  settings.main();
}
