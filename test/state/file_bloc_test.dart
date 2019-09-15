
import 'package:filer_flutter_desktop/state/file_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Setting up FilesBloc', (){
    FilesBloc files;
    test('Default Setup is files empty',(){
      files = FilesBloc();
      expect(files.files, []);
    });
  });
}