/// This file acts as a runner of the test suite.

import './state/device_bloc_test.dart' as device_bloc;
import './state/dir_changer_bloc_test.dart' as dir_changer_bloc;
import './state/favs_bloc_test.dart' as favs_bloc;
import './state/file_bloc_test.dart' as files_bloc;
import './state/settings_bloc_test.dart' as settings_bloc;

void main() {
  device_bloc.main();
  dir_changer_bloc.main();
  favs_bloc.main();
  files_bloc.main();
  settings_bloc.main();
}