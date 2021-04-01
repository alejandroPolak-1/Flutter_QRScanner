/* ====================
  Encargado de manejar Base de Datos 
 ====================== */
import 'dart:io';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_qr_scanner/src/models/scan_model.dart';
//Export para que podamos usar fuera, al llamar el provider y no tener que volver importar el model
export 'package:flutter_qr_scanner/src/models/scan_model.dart';

//clase patron singleton
class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // si es nula se va a crear la base de datos
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  //Para inicializar la Base de Datos
  initDB() async {
    //Directory de Dart:io
    //con el uso del pack de path porque en IOs y Android es distinto.
    Directory documensDirectory = await getApplicationDocumentsDirectory();

    // join del paquete /path.dart
    final path = join(documensDirectory.path, 'ScansDB.db');

    return await openDatabase(path,
        version: 1, //si cambiamos estructura de base de datos
        onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ' )');
    });
  }

  //CREAR Registros (MODELO QUE NO USAREMOS, OTRA MANERA DE HACER)
  nuevoScanRaw(ScanModel nuevoScan) async {
    //Esperar a la base de dato
    final db  = await database;
    //Para insertar
    final res = await db.rawInsert(
        "INSERT Intro Scans (id, tipo, valor) " //Importante dejar este espacio al final
        "VALUES ( ${nuevoScan.id},'${nuevoScan.tipo}', '${nuevoScan.valor}' )"); //string deben mmandarse entre comillas
    return res;
  }

  //CREAR Registros (QUE USAREMOS) manera maás facil que la anterior
  nuevoScan(ScanModel nuevoScan) async {
    final db  = await database;
    //to Json.. transforma el modelo, lo definimos en el ScanModel
    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }

  //SELECT - Obtener información
  Future<ScanModel> getScanId(int id) async {
    final db  = await database;
    //retorna un mapa, pero deberia retornar un scan model
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [
      id
    ]); // scans solo, trae todos los datos, ? un argumento, cada un su whereArgs

    //ScanModel.fromJson para retornar nueva instancia de ScanModel
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  //Para traer Todos los Scans
  Future<List<ScanModel>> getAllScan() async {
    final db  = await database;

    //retorna un mapa, pero deberia retornar un scan model
    final res = await db.query('Scans');

    //ScanModel.fromJson para retornar nueva instancia de ScanModel
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  //para ver los tipos, si http o geolocation
  //Para traer Todos los Scans
  Future<List<ScanModel>> getScanForTypes(String tipo) async {
    final db  = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    //ScanModel.fromJson para retornar nueva instancia de ScanModel
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  //Actualizar Registros, retorna un entero si actualiza
  Future<int> updateScan(ScanModel nuevoScan) async {
    
    final db  = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?',
        whereArgs: [nuevoScan.id]); //Sin ARGUMENTOS, Escanea todo

    return res;
  }

  //Borrar Registros
  Future<int> deleteScan(int id) async {
    final db  = await database;
    final res = await db.delete('Scans', where: 'id = ', whereArgs: [id]);

    return res;
  }

  //Borrar Todos los  Registros
  Future<int> deleteAll(int id) async {
    final db  = await database;
    final res = await db.rawDelete('DELETE FROM Scans');  //lo mismo que delete('Scans');

    return res;
  }
}
