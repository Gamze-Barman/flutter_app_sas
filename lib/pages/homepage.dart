import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sas/root.dart';
import 'dart:async';
import 'globals.dart' as globals;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

Future<String> userImage(String companyId) async {
  final response = await http.post(
    Uri.parse(
        'https://shipsupplyapi.azurewebsites.net/Company/GetLogo?companyId=' +
            companyId),
    headers: <String, String>{
      "Accept": "text/plain",
      "Authorization": "bearer " + globals.token,
    },
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //postOk = true;
    print("post ok");
    print(response.body.toString());

    //globals.myBytes = Base64Decoder().convert(response.body);
    return response.body.toString();
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //postOk = false;
    print("post not ok");
    throw Exception('Failed to create album.');
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> base64Image;

  @override
  void initState() {
    super.initState();
    base64Image = userImage(globals.userCompanyId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                /*child: Image(
                  image: AssetImage('assets/images/sasdemo.png'),
                  height: 150,
                  width: 150,
                ),*/
                /*children: <Widget>[
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
                ],*/
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/sasdemo.png'),
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                  ),
                  FutureBuilder<String>(
                    future: base64Image,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Uint8List _bytesImage;
                        String? data = snapshot.data!.replaceAll("\"", "");
                        _bytesImage = Base64Decoder().convert(data);

                        return Container(
                          height: 150,
                          width: 150,
                          child: Image.memory(_bytesImage),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
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
      ),
    );
  }
}
