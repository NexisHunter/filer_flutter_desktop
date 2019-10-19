import 'dart:io';

import 'package:filer_flutter_desktop/custom_icons_icons.dart';
import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilesView extends StatefulWidget {
  _FilesViewState createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  @override
  Widget build(BuildContext context) {
    Offset _tapPos;
    var overlay;
    return Consumer4<Files, DirChanger, Settings, Favs>(
        builder: (context, files, dir, prefs, favs, child) {
      final grid = SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 60 * prefs.scale * 1.25,
          mainAxisSpacing: 4,
          crossAxisSpacing: 16 * prefs.scale);
      _updateTapPos(TapDownDetails details) {
        _tapPos = details.globalPosition;
      }

      files.updateFiles(Directory(dir.pwd), prefs.showHidden);

      return GestureDetector(
          onTapDown: (details) {
            overlay = Overlay.of(context).context.findRenderObject();
            _updateTapPos(details);
          },
          onLongPress: () {
            return showMenu(
                position: _getPostion(_tapPos, overlay),
                context: context,
                items: [
                  PopupMenuItem(
                    value: 'TXT',
                    enabled: true,
                    child: Text('Create new text file'),
                  ),
                  PopupMenuItem(
                    value: 'FOLDER',
                    enabled: true,
                    child: Text('Create new folder'),
                  ),
                  PopupMenuItem(
                    value: 'FILE',
                    enabled: true,
                    child: Text('Create new file'),
                  ),
                  PopupMenuItem(
                    value: 'HTML',
                    enabled: true,
                    child: Text('Create new html file'),
                  ),
                ]).then((value) {
              final doc = 'new document';
              final file = 'new file';
              final web = 'index';
              final folder = 'new folder';
              switch (value) {
                case 'TXT':
                  files.createNew(doc, Type.TXT, dir.pwd);
                  files.updateFiles(dir.root, prefs.showHidden);
                  break;
                case 'HTML':
                  files.createNew(web, Type.HTML, dir.pwd);
                  files.updateFiles(dir.root, prefs.showHidden);
                  break;
                case 'FOLDER':
                  files.createNew(folder, Type.Folder, dir.pwd);
                  files.updateFiles(dir.root, prefs.showHidden);
                  break;
                case 'FILE':
                  files.createNew(file, Type.File, dir.pwd);
                  files.updateFiles(dir.root, prefs.showHidden);
                  break;
              }
            });
          },
          child: GridView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              gridDelegate: grid,
              children: <Widget>[
                for (var item in files.files)
                  Transform.scale(
                      scale: prefs.scale,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: 25 * prefs.scale,
                            maxHeight: 25 * prefs.scale),
                        child: Container(
                          child: InkWell(
                            splashColor: prefs.themeData.splashColor,
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                  _getIcon(item),
                                  Text.rich(
                                    TextSpan(
                                        text: (prefs.showFileExtensions)
                                            ? item.name
                                            : item.fileName),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ])),
                            onTap: () {
                              switch (item.type) {
                                case Type.Folder:
                                  if (item.path == '/storage/emulated' &&
                                      Platform.isAndroid)
                                    dir.root = Directory('/storage/emulated/0');
                                  else
                                    dir.root = Directory(item.path);
                                  files.updateFiles(dir.root, prefs.showHidden);
                                  break;
                                default:
                                  _open(item);
                              }
                            },
                            onTapDown: (details) {
                              overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject();
                              _updateTapPos(details);
                            },
                            onLongPress: () {
                              return showMenu(
                                context: context,
                                items: [
                                  if (_notInFavs(item, favs))
                                    PopupMenuItem(
                                      value: 'Add',
                                      enabled: true,
                                      child: Text('Add to Favourites'),
                                    ),
                                  PopupMenuItem(
                                    value: 'Rename',
                                    enabled: true,
                                    child: Text('Rename'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Delete',
                                    enabled: true,
                                    child: Text('Delete'),
                                  ),
                                ],
                                position: _getPostion(_tapPos, overlay),
                              ).then((value) {
                                switch (value) {
                                  case 'Add':
                                    favs.pin(item);
                                    dir.root = dir.root;
                                    files.updateFiles(
                                        dir.root, prefs.showHidden);
                                    break;
                                  case 'Delete':
                                    // Remove from favourites if present
                                    if (item.type == Type.Folder &&
                                        !_notInFavs(item, favs))
                                      favs.unpin(item);
                                    files.removeFile(item);
                                    files.updateFiles(
                                        dir.root, prefs.showHidden);
                                    break;
                                  case 'Rename':
                                    // Display a dialog that takes the new name of the file
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) =>
                                            _renameDialog(item));
                                    break;
                                }
                              });
                            },
                          ),
                        ),
                      ))
              ]));
    });
  }

  _open(FileItem item) async {
    // var mimeType = mime(item.name);

    // if(mimeType == null){
    //   // Open options panel
    //   mimeType = "*/*";
    // }

    // final data = Uri.file(item.path,windows: false);
    // print('${data.toString()}, $mimeType');
    // intent.Intent()
    //   ..setAction('Action.ACTION_APPLICATION_PREFERENCES')
    //   ..setType(mimeType)
    //   ..setData(data)
    //   ..startActivity();
    // final intent = AndroidIntent(action: 'action_view',data: data.toString(),arguments: {'type':mimeType});
    // await intent.launch();
  }

  Icon _getIcon(ListItem item) {
    var iconImage;
    switch (item.type) {
      case Type.Folder:
        iconImage = Icons.folder;
        break;
      default:
        var mimeType =
            item.name.substring(item.name.lastIndexOf('.') + 1).toLowerCase();
        switch (mimeType) {
          case 'txt':
          case 'doc':
          case 'docx':
          case 'rtf':
          case 'otd':
            iconImage = CustomIcons.doc;
            break;
          case 'xls':
          case 'xlsx':
            iconImage = CustomIcons.file_excel;
            break;
          case 'ppt':
          case 'pptx':
            iconImage = CustomIcons.file_powerpoint;
            break;
          case 'mp4':
          case 'avi':
          case 'mkv':
            iconImage = CustomIcons.video;
            break;
          case 'apk':
            iconImage = CustomIcons.android;
            break;
          case 'ttf':
          case 'otf':
          case 'wff':
            iconImage = CustomIcons.font;
            break;
          case 'mp3':
          case 'avi':
            iconImage = CustomIcons.music_note;
            break;
          case 'pdf':
            iconImage = CustomIcons.file_pdf;
            break;
          case 'rar':
          case 'zip':
          case 'xz':
          case 'gz':
          case 'tar':
            iconImage = CustomIcons.file_archive;
            break;
          case 'png':
          case 'jpg':
          case 'jpeg':
          case 'gif':
          case 'svg':
            iconImage = Icons.image;
            break;
          default:
            iconImage = CustomIcons.question_circle_o;
            break;
        }
        break;
    }
    return Icon(iconImage);
  }

  bool _notInFavs(ListItem item, Favs favs) {
    if (item.type != Type.Folder) return false;
    return item.type == Type.Folder && favs.contains(item);
  }

  /// Displays a dialog to rename the file.
  _renameDialog(ListItem item) {
    final text = TextEditingController();
    return Dialog(
      elevation: 2.0,
      child: Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text('Please Enter New Name: '),
            TextField(
              controller: text,
            ),
            RaisedButton(
              child: Text('Ok'),
              onPressed: () {
                item.rename(text.text);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  _getPostion(_tapPos, overlay) =>
      RelativeRect.fromRect(_tapPos & Size(40, 40), Offset.zero & overlay.size);
}
