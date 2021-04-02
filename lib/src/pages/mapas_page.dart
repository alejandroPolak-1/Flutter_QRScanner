import 'package:flutter/material.dart';

import 'package:flutter_qr_scanner/src/bloc/scans_bloc.dart';
import 'package:flutter_qr_scanner/src/models/scan_model.dart';
import 'package:flutter_qr_scanner/src/utils/scanUtils.dart' as utils;

// import 'package:flutter_qr_scanner/src/providers/db_provider.dart'; //Ya no

class MapasPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanModel>>(
      //
      // return FutureBuilder<List<ScanModel>>( //ya no mas un Future
      // future: DBProvider.db.getAllScan(), //no usar DBprovider sino el scansBloc
      stream: scansBloc.scansStream, //instruccion conectada al registro
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
            itemCount: scans.length, //Contar numeros de scan
            itemBuilder: (context, i) => Dismissible(
                  //Dismissible para deslizar de Izquierda a derecha
                  //CREA una llave unica que requiere el metodo
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  // onDismissed: (direction) => DBProvider.db.deleteScan(scans[i].id), //Cuando se deslice completamente llamamos al DBPRrovider
                  onDismissed: (direction) => scansBloc.borrarScan((scans[i]
                      .id)), //Cuando se deslice completamente llamamos al DBPRrovider
                  child: ListTile(
                    leading: Icon(Icons.cloud_queue,
                        color: Theme.of(context).primaryColor),
                    title: Text(scans[i].valor),
                    subtitle: Text('ID: ${scans[i].id}'), //para ver el id
                    trailing: Icon(Icons.keyboard_arrow_right,
                        color: Colors.grey), // Indicar que se puede abrir
                    onTap: () => utils.abrirScan(context, scans[i]), //Esto lanza la pagina en el navegador, haciendo click en la lista, context para manejar geo location
                  ),
                ));
      },
    );
  }
}
