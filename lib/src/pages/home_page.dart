import 'dart:io';

import 'package:flutter/material.dart';
//import 'dart:io';

// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_qr_scanner/src/bloc/scans_bloc.dart';
import 'package:flutter_qr_scanner/src/models/scan_model.dart';

import 'package:flutter_qr_scanner/src/pages/directions_page.dart';
import 'package:flutter_qr_scanner/src/pages/mapas_page.dart';
import 'package:flutter_qr_scanner/src/utils/scanUtils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: 'Delete',
            onPressed: scansBloc.borrarScanAll, // handle the press
          ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    //Funciona sin el Build context, pero para asegurarnos lo ponemos
    
    //Tipos de datos:
    // https://google.com
    // geo:40.724233047051705,-74.00731459101564

    String futureString = 'https://fernando-herrera.com';

    // String futureString = '';
    try {
      // LECTOR QR;
      // futureString = await BarcodeScanner.scan(); /// PARA QUE LEA QR
      futureString = futureString;
    } catch (e) {
      futureString = e.toString();
    }

    // print('future String: $futureString');

    if (futureString != null) {
      // print("Leyendo Info");

      //LLamando proceso de inserción
      //final scan = DBProvider.db.nuevoScan(scan); //NO usar directamente DB provider, mejor con el scanBLoc
      final scan = ScanModel(valor: futureString);
      scansBloc.addScan(scan);

      final scan2 =
          ScanModel(valor: 'geo:40.724233047051705,-74.00731459101564');
      scansBloc.addScan(scan2);
      
      ///[Importante para IOs]
      //info envia rapido y aun no se cierra el Lector QR.
      //hay que esperar 750 mils por es lo que se demora en cerrar la animación de lector QR
      //Platform es de Dart:io
      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () => utils.abrirScan(context, scan) );
      } else{
          utils.abrirScan(context, scan);
      }

    }
  }

  _callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();

      default:
        return MapasPage();
    }
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Mapa'),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions), label: 'Directions'),
      ],
    );
  }
}
