/*--------------------
Para que se recarge la info al escanear
Con esta estructura para tener una sola instancia del ScanBloc.
--------------------*/

import 'dart:async';

import 'package:flutter_qr_scanner/src/providers/db_provider.dart';

//patron Singleton
class ScansBloc {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //Obtener Scans de la Base de Datos
    obtenerScans();
  }

  //Stream.. Flujo de datos que atravezará la info.
  //StreamController de la libreria dart;async
  final _scansController = StreamController<List<ScanModel>>.broadcast();

  //Para escuchar la información que fluye por el mismo. Todos donde escuchen el scansStrean seran notificados
  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  //cerramos el stream, el ? por si no tiene nada, para que no falle
  dispose() {
    _scansController?.close();
  }

   //Obtener toda la info de los scan, se dispara cuando se larga el constructor
  obtenerScans() async {
    //inicio de todo el flujo de info.
    _scansController.sink.add(await DBProvider.db.getAllScan());
  }

 //Agregar nuevo Scan. Asincrono para evitar problemas
  addScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan); //inserto en basede dato
    obtenerScans();   //paara avisar que hay nuevo registo
  }

  //Borrar scan
  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans(); //leer los scans que quedorrarScanAll() async {
    DBProvider.db.deleteAll(); //purga toda la info
    //Dos maneras de ahcerlo
    //obtenerScans();  //otra manera
    _scansController.sink.add([]); //porque ya esta vacio el registro
  }
}
