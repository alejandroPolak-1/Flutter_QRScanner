import 'package:flutter/material.dart';

import 'package:flutter_qr_scanner/src/models/scan_model.dart';

class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //recibimos el argumento enviado por el context
    final ScanModel scan= ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("QR mapa"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Text( scan.valor ),
      ),
    );
  }
}
