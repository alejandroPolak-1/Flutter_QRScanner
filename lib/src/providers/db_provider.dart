/* ====================
  Encargado de manejar Base de Datos 
 ====================== */
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

//clase patron singleton
class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    //Directory de Dart:io
    //con el uso del pack de path porque en IOs y Android es distinto.
    Directory documensDirectory = await getApplicationDocumentsDirectory();

    // join del paquete /path.dart
    final path = join(documensDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
          await db.execute(
            'CREATE TABLE Scans ('
            ' id INTEGER PRIMARY KEY,'
            ' tipo TEXT,'
            ' valor TEXT'
            ' )'
          );
      }
    );
  }
}
