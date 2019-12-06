import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:async';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _reader='';
  Permission perm = Permission.Camera;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(title: new Text("Scanner"),),
        body: new Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            new RaisedButton(

              splashColor: Colors.pinkAccent,
              color: Colors.red,
              child: new Text("Scan", style: new TextStyle(fontSize: 20.0, color: Colors.white),),
              onPressed: scan,
            ),
            new Padding(padding: const EdgeInsets.symmetric(vertical: 10.0), ),
            new Text('$_reader', softWrap: true, style: new TextStyle(fontSize: 30.0, color: Colors.blue),),
          ],
        ),
      ),
    );
  }
requestPermission() async {
    await SimplePermissions.requestPermission(perm);
}

scan() async{
    try {
      String reader = await BarcodeScanner.scan();

      if(!mounted) {return;}
      setState(()=> _reader =reader);
    }on PlatformException catch(e) {
      if(e.code==BarcodeScanner.CameraAccessDenied){
        requestPermission();
      } else{setState(()=>_reader = "Unknown error $e");;
      }

    }on FormatException {
      setState(()=> _reader = "Please scan again");
    }catch(e) {
      {
        setState(()=>_reader = "Unknown error $e");;
      }
    }
}

}

