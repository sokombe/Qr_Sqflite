import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sample/models/personne.dart';

class PersonneQr extends StatefulWidget {
  String? personne;
   PersonneQr({@required this.personne});

  @override
  State<PersonneQr> createState() => _PersonneQrState();
}

class _PersonneQrState extends State<PersonneQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Center(
  child:   Container(

    child:QrImage(

      data: widget.personne!,

      version: QrVersions.auto,

      size: 350.0,

    ),

  ),
),


    );
  }
}
