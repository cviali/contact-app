import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanPage extends StatefulWidget {
  final String barcode;

  const ScanPage({Key key, this.barcode}) : super(key: key);

  @override
  _ScanPageState createState() {
    return _ScanPageState();
  }
}

class _ScanPageState extends State<ScanPage> {
  String barcode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan Result"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Christian",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text("viali.bounche@gmail.com"),
          ],
        ));
  }
}
