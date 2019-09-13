// import 'package:flutter_filer/blocs/favs_bloc.dart';
// import 'package:flutter_filer/blocs/settings_bloc.dart';
// import 'package:sqflite/sqflite.dart';

// class UserData {
//   UserData._();
//   static final userData = UserData._();
//   Database _db;

//   /// Creates a new [Database] where all the user preferences are stored.
//   create(String table, Map prefs, Map favs) async {
//     if (!prefs.isCreated) {
//       _db = await openDatabase(await getDatabasesPath() + "$table.db",
//           version: 1, onCreate: (Database db, int version) async {
//         await db.execute('''
//           create table if not exists $table (
//             id TEXT primary key,
//             items BLOB not null
//           )
//           ''');
//       });
//       _db.insert(table, prefs,
//           conflictAlgorithm: ConflictAlgorithm.replace);
//       _db.insert(table, favs.toMap(),
//           conflictAlgorithm: ConflictAlgorithm.replace);
//       prefs.isCreated = true;
//     }
//   }

//   update(String table, SettingsBloc prefs, FavsBloc favs) async {
//     if (prefs != null) {
//       if (favs != null) {
//         await _db.update(table, prefs.toMap(),
//             where: 'id = ?',
//             whereArgs: ['settings'],
//             conflictAlgorithm: ConflictAlgorithm.replace);
//         await _db.update(table, favs.toMap(),
//             where: 'id = ?',
//             whereArgs: ['favourites'],
//             conflictAlgorithm: ConflictAlgorithm.replace);
//       } else {
//         await _db.update(table, prefs.toMap(),
//             where: 'id = ?',
//             whereArgs: ['favourites'],
//             conflictAlgorithm: ConflictAlgorithm.replace);
//       }
//     } else if (favs != null) {
//       await _db.update(table, {'favourites': favs.toMap()},
//           where: 'id = ?',
//           whereArgs: ['favouritez'],
//           conflictAlgorithm: ConflictAlgorithm.replace);
//     }
//   }

//   getTable(String table) async {
//     if (_db != null) {
//       final results = await _db.query(table);
//       return results;
//     }
//   }

//   // Closes db permanently use with caution
//   close() async {
//     await _db.close();
//   }
// }
