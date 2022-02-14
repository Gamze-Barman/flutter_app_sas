import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/vessels.dart';
import 'package:flutter_app_sas/pages/warehouses.dart';
import 'package:flutter_app_sas/root.dart';
import 'customers.dart';
import 'vessels.dart';
import 'warehouses.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String base64Encode(List<int> bytes) => base64.encode(bytes);

  @override
  Widget build(BuildContext context) {
    /* return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              /*child: Image(
                image: AssetImage('assets/images/sasdemo.png'),
                height: 150,
                width: 150,
              ),*/
              children: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.all(18.0),
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text('HOME'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RootPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );*/
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                onPressed: _upload,
                child: Text('Upload Image'),
              )
            ],
          ),
          file == null ? Text('No Image Selected') : Image.file(file)
        ],
      ),
    );
  }

  final String phpEndPoint = 'http://192.168.43.171/phpAPI/image.php';
  final String nodeEndPoint = 'http://192.168.43.171:3000/image';
  File file;

  void _choose() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
// file = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _upload() {
    if (file == null) return;
    String base64Image = base64Encode(file.readAsBytesSync());
    String fileName = file.path.split("/").last;

    http.post(phpEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }
}
