import 'package:flutter/material.dart';
import 'package:flutter_qr_scanner/src/providers/db_provider.dart';

class MapaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScanModel>>(
      future: DBProvider.db.getAllScan(),
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); //como un loading
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(
            child: Text('No hay información para mostrar'),
          );
        }

        return ListView.builder( 
          itemCount:scans.length, //Contar numeros de scan
          itemBuilder: (context, i) => ListTile(
            leading: Icon( Icons.cloud_queue, color: Theme.of(context).primaryColor),
            title: Text( scans[i].valor),
            trailing: Icon( Icons.keyboard_arrow_right, color: Colors.grey), // Indicar que se puede abrir
          ) 
        );
      },
    );
  }
}
