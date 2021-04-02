import 'package:flutter/material.dart';

import 'package:flutter_qr_scanner/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

//abrir scan. n ejemplo de la documentacion aparece como launchURL
void abrirScan(BuildContext context, ScanModel scan) async {
  if (scan.tipo == 'http') {
    await canLaunch(scan.valor)
        ? await launch(scan.valor)
        : throw 'Could not launch ${scan.valor}';
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan); //mandamos los argumentos
  }
}
