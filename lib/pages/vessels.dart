import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/files.dart';
import 'package:flutter_app_sas/pages/search_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:expandable/expandable.dart';

String token = globals.token;
String url_getAllVessels = globals.baseUrl + 'Vessel/GetAllVessels';
String url_getVesselDetail = globals.baseUrl + 'Vessel?vesselId=';

class allVesselsModel {
  final String id;
  final String name;

  allVesselsModel({required this.id, required this.name});

  factory allVesselsModel.fromJson(Map<String, dynamic> json) {
    return allVesselsModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class vesselDetailModel {
  final String id;
  final String name;
  final String imo;
  final String flag;

  vesselDetailModel(
      {required this.id,
      required this.name,
      required this.imo,
      required this.flag});

  factory vesselDetailModel.fromJson(Map<String, dynamic> json) {
    return vesselDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imo: json['imo'] ?? '',
      flag: json['flag'] ?? '',
    );
  }
}

Future<List<allVesselsModel>> fetchAllVessels(String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);

/*
    var tagsJson = jsonDecode(response.body)['name'];
    namesList = (tagsJson != null ? List.from(tagsJson) : null)!;
*/
    return jsonResponse
        .map((data) => new allVesselsModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhy!');
  }
}

Future<vesselDetailModel> fetchVesselDetails(String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return vesselDetailModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Unexpected error occuredhy');
  }
}

class VesselsPage extends StatefulWidget {
  @override
  _VesselsPageState createState() => _VesselsPageState();
}

class _VesselsPageState extends State<VesselsPage> {
  late List<allVesselsModel> allvessels;
  late List<allVesselsModel> vessels;

  String query = '';

  late Future<List<allVesselsModel>> allVesselsData;

  @override
  void initState() {
    super.initState();
    convertLists();
  }

  void convertLists() async {
    allVesselsData = fetchAllVessels(url_getAllVessels, token);
    allvessels = await allVesselsData;
    vessels = allvessels;
  }

  void searchBook(String query) {
    final vessels = allvessels.where((vessel) {
      final titleLower = vessel.name.toLowerCase();
      //final authorLower = vessel.author.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.vessels = vessels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "VESSELS",
          ),
          Text(
            'Please select vessel to see its Files',
            style: new TextStyle(
              fontSize: 11.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ]),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<allVesselsModel>>(
          future: allVesselsData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allVesselsModel>? data = vessels;
              return Column(
                children: <Widget>[
                  buildSearch(),
                  Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return makeContainer(data[index]);
                          })),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Vessel Name',
        onChanged: searchBook,
      );

  Container makeContainer(allVesselsModel data) => Container(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupDialog(context, data),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Container(
                  child: Text(
                    data.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
                flex: 5,
                fit: FlexFit.tight,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          child: Text(
                            'SEE DETAILS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)),
                            color: Colors.blue,
                          ),
                        ),
                        flex: 1,
                      ),
                      Flexible(
                        child: Container(
                          child: SizedBox.shrink(),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                flex: 2,
                fit: FlexFit.tight,
              ),
            ],
          ),
        ),
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(
            255,
            215,
            237,
            242,
          ),
        ),
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      );

  Widget _buildPopupDialog(BuildContext context, allVesselsModel data) {
    var vesselDetails;
    vesselDetails = fetchVesselDetails(url_getVesselDetail + data.id, token);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 250),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(30),
      )),
      content: Center(
        child: FutureBuilder<vesselDetailModel>(
          future: vesselDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return makePopupContainer(
                context,
                snapshot.data!.id,
                snapshot.data!.name,
                snapshot.data!.imo,
                snapshot.data!.flag,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Container makePopupContainer(
    dialogContext,
    String id,
    String name,
    String imo,
    String flag,
  ) =>
      Container(
        height: 250,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      'Name:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(
              flex: 8,
              child: Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Text(
                            'Imo:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Flag:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            imo,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            flag,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                margin: EdgeInsets.all(
                  10,
                ),
                padding: EdgeInsets.all(
                  2,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(),
                    ),
                    Flexible(
                      child: Container(
                        child: OutlinedButton(
                          child: Text(
                            'BACK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                              side: BorderSide.none,
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: Container(
                        child: OutlinedButton(
                          child: Text(
                            'SHOW FILES',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                              side: BorderSide.none,
                            ),
                            backgroundColor: Colors.blue,
                            shadowColor: Colors.black,
                            elevation: 5,
                          ),
                          onPressed: () {
                            globals.selectedVesselId = id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilesPage()),
                            );
                          },
                        ),
                      ),
                      flex: 3,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
}
