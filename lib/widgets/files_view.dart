import 'dart:io';

import 'package:filer_flutter_desktop/custom_icons_icons.dart';
import 'package:filer_flutter_desktop/state/dir_changer.dart';
import 'package:filer_flutter_desktop/state/favs.dart';
import 'package:filer_flutter_desktop/state/files.dart';
import 'package:filer_flutter_desktop/state/settings.dart';
import 'package:filer_flutter_desktop/list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Renders the list of files in the current directory.
///
/// [FilesView] renders the list of files within the current directory.
/// It handles the file functionality in the UI.
class FilesView extends StatefulWidget {
  _FilesViewState createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  Offset _tapPos;

  @override
  Widget build(BuildContext context) {
    var overlay;
    return Consumer4<Files, DirChanger, Settings, Favs>(
      builder: (context, files, dir, prefs, favs, child) {
        files.updateFiles(Directory(dir.pwd), prefs.showHidden);
        return GestureDetector(
          onTapDown: (details) {
            overlay = Overlay.of(context).context.findRenderObject();
            _updateTapPos(details);
          },
          onLongPress: () =>
              _showWindowContextMenu(overlay, files, prefs, dir, context),
          child: _renderFiles(prefs, files, dir, favs, overlay),
        );
      },
    );
  }

  /// Builds the grid and displays the files within the current directory.
  ///
  /// [prefs] -  The user settings to be applied to the files.
  /// [files] - The current list of files to be displayed.
  /// [dir] - The current working directory.
  /// [favs] - The current list of favourites.
  /// [overlay] - Used for context menus. TODO: Refine me
  Widget _renderFiles(
      Settings prefs, Files files, DirChanger dir, Favs favs, dynamic overlay) {
    final grid = SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 60 * prefs.scale * 1.25,
        mainAxisSpacing: 4,
        crossAxisSpacing: 16 * prefs.scale);

    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: grid,
      children: <Widget>[
        for (var item in files.files)
          _displayFile(item, prefs, dir, files, favs, overlay),
      ],
    );
  }

  /// Creates a pop up context menu on an item within the grid.
  ///
  /// [item] - The item that is to be displayed.
  /// [prefs] - The user preferences for display.
  /// [dir] - Handles user interaction for navigation.
  /// [files] - The current set of files to be updated.
  /// [favs] - The current list of favourites.
  /// [overlay] - Used for context menus. TODO: Refine me
  void _showFileContextMenu(Favs favs, ListItem item, DirChanger dir,
      Settings prefs, Files files, dynamic overlay) async {
    return await showMenu(
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
      position: _getPostion(overlay),
    ).then((value) {
      switch (value) {
        case 'Add':
          favs.pin(item);
          dir.root = dir.root;
          files.updateFiles(dir.root, prefs.showHidden);
          break;
        case 'Delete':
          // Remove from favourites if present
          if (item.type == Type.Folder && !_notInFavs(item, favs))
            favs.unpin(item);
          files.removeFile(item);
          files.updateFiles(dir.root, prefs.showHidden);
          break;
        case 'Rename':
          // Display a dialog that takes the new name of the file
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => _renameDialog(item));
          break;
      }
    });
  }

  /// Displays an interactable and scalable file.
  ///
  /// [item] - The item that is to be displayed.
  /// [prefs] - The user preferences for display.
  /// [dir] - Handles user interaction for navigation.
  /// [files] - The current set of files to be updated.
  /// [favs] - The current list of favourites.
  /// [overlay] - Used for context menus. TODO: Refine me
  Widget _displayFile(ListItem item, Settings prefs, DirChanger dir,
      Files files, Favs favs, dynamic overlay) {
    return Transform.scale(
      scale: prefs.scale,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: 25 * prefs.scale, maxHeight: 25 * prefs.scale),
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
                  if (item.path == '/storage/emulated' && Platform.isAndroid)
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
              overlay = Overlay.of(context).context.findRenderObject();
              _updateTapPos(details);
            },
            onLongPress: () =>
                _showFileContextMenu(favs, item, dir, prefs, files, overlay),
          ),
        ),
      ),
    );
  }

  /// Triggers the display of the context menu for the main window.
  ///
  /// [overlay] - Used for context menus. TODO: Refine me
  /// [files] - The current list of files.
  /// [prefs] - The user settings to apply.
  /// [dir] - The current directory.
  /// [context] - The context to create the menu in.
  void _showWindowContextMenu(dynamic overlay, Files files, Settings prefs,
      DirChanger dir, BuildContext context) async {
    return await showMenu(
      position: _getPostion(overlay),
      context: context,
      items: [
        for (var item in ['txt', 'folder', 'file', 'html'])
          _createMenuItem(item),
      ],
    ).then(
      (value) {
        final doc = 'new document';
        final file = 'new file';
        final web = 'index';
        final folder = 'new folder';
        switch (value) {
          case 'TXT':
            _createFile(
                doc, Type.TXT, dir.pwd, dir.root, prefs.showHidden, files);

            break;
          case 'HTML':
            _createFile(
                web, Type.HTML, dir.pwd, dir.root, prefs.showHidden, files);

            break;
          case 'FOLDER':
            _createFile(folder, Type.Folder, dir.pwd, dir.root,
                prefs.showHidden, files);

            break;
          case 'FILE':
            _createFile(
                file, Type.File, dir.pwd, dir.root, prefs.showHidden, files);

            break;
        }
      },
    );
  }

  /// Creates the popup menu item.
  ///
  /// [item] -  The item type to create.
  PopupMenuItem _createMenuItem(String item) => PopupMenuItem(
        value: item.toUpperCase(),
        enabled: true,
        child: Text(
          'Create New ${(item == 'FILE') ? '' : (item == 'FOLDER') ? 'folder' : '$item file'}',
        ),
      );

  /// Updates the tapPosition to build pop-up.
  ///
  /// [details] - The details of the tap within the window.
  void _updateTapPos(TapDownDetails details) {
    _tapPos = details.globalPosition;
  }

  /// Opens the item requested.
  ///
  /// [item] - The item to be opened.
  void _open(FileItem item) async {
    // TODO: Implement me.
  }

  /// Fetches the icon of the given file type.
  ///
  /// [item] - The file to apply the icon to.
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

  /// Checks the favourites list for the item.
  ///
  /// [item] - The item to find within the list.
  /// [favs] - The favourites list to check in.
  bool _notInFavs(ListItem item, Favs favs) {
    if (item.type != Type.Folder) return false;
    return item.type == Type.Folder && !favs.contains(item);
  }

  /// Displays a dialog to rename the given file.
  ///
  /// [item] - The item to be renamed.
  Widget _renameDialog(ListItem item) {
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

  /// Creates the given file and updates the list of current files.
  ///
  /// [doc] - The name of the document to be created.
  /// [type] - The type of document to be created.
  /// [pwd] - The directory to be created in.
  /// [root] - The root to refresh
  /// [showHidden] - A flag that indicates whether or not to show hidden files.
  /// [files] - The list of files to update.
  void _createFile(String doc, Type type, String pwd, Directory root,
      bool showHidden, Files files) {
    // Create the new file.
    files.createNew(doc, type, pwd);
    // Refresh the current files list.
    files.updateFiles(root, showHidden);
  }

  /// Fetch the position of where to display the context menu.
  ///
  /// [overlay] - Used for context menus. TODO: Refine me
  RelativeRect _getPostion(overlay) => RelativeRect.fromRect(
        _tapPos & Size(40, 40),
        Offset.zero & overlay.size,
      );
}
