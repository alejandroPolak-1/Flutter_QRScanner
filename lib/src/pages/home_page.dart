import 'package:flutter/material.dart';
//import 'dart:io';

// import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_qr_scanner/src/bloc/scans_bloc.dart';
import 'package:flutter_qr_scanner/src/models/scan_model.dart';

import 'package:flutter_qr_scanner/src/pages/directions_page.dart';
import 'package:flutter_qr_scanner/src/pages/mapa_page.dart';

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
        onPressed: _scanQR,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR() async {
    //Tipos de datos:
    // https://google.com
    // geo:40.724233047051705,-74.00731459101564

    String futureString = 'https://google.com';

    // String futureString = '';
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
      final scan = ScanModel(valor: futureString);
      //DBProvider.db.nuevoScan(scan); //NO usar directamente DB provider, mejor con el scanBLoc

      scansBloc.addScan(scan);
    }
  }

  _callPage(int actualPage) {
    switch (actualPage) {
      case 0:
        return MapaPage();
      case 1:
        return DireccionesPage();

      default:
        return MapaPage();
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
