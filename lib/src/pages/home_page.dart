import 'package:flutter/material.dart';
//import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter_qr_scanner/src/pages/directions_page.dart';
import 'package:flutter_qr_scanner/src/pages/mapa_page.dart';
import 'package:flutter_qr_scanner/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
            },
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
    // geo:40.724233047051705,-74.00731459101564

    // String futureString = '';
    // String futureString = '';

    try {
      // LECTOR QR;
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    // print('future String: $futureString');

    if (futureString != null) {
      // print("Leyendo Info");
      //LLamando proceso de inserción
      final scan = ScanModel(valor: futureString);
      DBProvider.db.nuevoScan(scan);
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
