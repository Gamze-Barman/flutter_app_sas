import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/attachments.dart';
import 'package:flutter_app_sas/pages/search_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'department.dart';
import 'globals.dart' as globals;

String token = globals.token;

String url_getAllPorts = globals.baseUrl + 'Port/GetPortDetailedList';
String url_getAllPortsDetail = globals.baseUrl + 'Port?portId=';

class allPortsModel {
  final String id;
  final String name;
  final String note;
  final String country;

  allPortsModel({
    required this.id,
    required this.name,
    required this.note,
    required this.country,
  });

  factory allPortsModel.fromJson(Map<String, dynamic> json) {
    return allPortsModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      note: json['note'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class allPortsDetailModel {
  final String id;
  final String name;
  final String note;
  final int companyId;
  final String createdAt;
  final String createdBy;
  final String lastUpdatedAt;
  final String lastUpdatedBy;
  final String deletedAt;
  final String deletedBy;
  final bool isDeleted;
  final String applicationUser;
  final String country;

  allPortsDetailModel({
    required this.id,
    required this.name,
    required this.note,
    required this.companyId,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdatedAt,
    required this.lastUpdatedBy,
    required this.deletedAt,
    required this.deletedBy,
    required this.isDeleted,
    required this.applicationUser,
    required this.country,
  });

  factory allPortsDetailModel.fromJson(Map<String, dynamic> json) {
    return allPortsDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      note: json['note'] ?? '',
      companyId: json['companyId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] ?? '',
      lastUpdatedBy: json['lastUpdatedBy'] ?? '',
      deletedAt: json['supplierTypeId'] ?? '',
      deletedBy: json['detailsOfBusinessScope'] ?? '',
      isDeleted: json['contactDetails'] ?? false,
      applicationUser: json['applicationUser'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

Future<List<allPortsModel>> fetchAllPorts(String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allPortsModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

Future<allPortsDetailModel> fetchAllPortDetails(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return allPortsDetailModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class PortsPage extends StatefulWidget {
  @override
  _PortsPageState createState() => _PortsPageState();
}

class _PortsPageState extends State<PortsPage> {
  late List<allPortsModel> allPorts;
  late List<allPortsModel> ports;

  late Future<List<allPortsModel>> allPortsData;

  String query = '';

  @override
  void initState() {
    super.initState();
    //allPortsData = fetchAllPorts(url_getAllPorts, token);
    convertLists();
  }

  void convertLists() async {
    allPortsData = fetchAllPorts(url_getAllPorts, token);
    allPorts = await allPortsData;
    ports = allPorts;
  }

  void searchBook(String query) {
    final ports = allPorts.where((ports) {
      final titleLower = ports.name.toLowerCase();
      //final authorLower = vessel.author.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.ports = ports;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "PORTS",
          ),
          Text(
            'Please select port to see the details',
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
        child: FutureBuilder<List<allPortsModel>>(
          future: allPortsData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allPortsModel>? data = ports;
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
        hintText: 'Ports Name',
        onChanged: searchBook,
      );

  Container makeContainer(allPortsModel data) => Container(
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

  Widget _buildPopupDialog(BuildContext context, allPortsModel data) {
    var vesselDetails;
    vesselDetails = fetchAllPortDetails(url_getAllPortsDetail + data.id, token);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 250),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(30),
      )),
      content: Center(
        child: FutureBuilder<allPortsDetailModel>(
          future: vesselDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return makePopupContainer(
                context,
                snapshot.data!.id,
                snapshot.data!.name,
                snapshot.data!.note,
                snapshot.data!.country,
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
    String note,
    String country,
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
                            'Note:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Country:',
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
                            note,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            country,
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

  /*Container makeContainer(allPortsModel data) => Container(
        height: 120,
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              child: SizedBox.shrink(),
                              flex: 1,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: Container(
                                child: Column(
                                  children: [
                                    Flexible(
                                      child: SizedBox.shrink(),
                                      flex: 10,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Name',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.name.toString(),
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                      flex: 20,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Note',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.note.toString(),
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                      flex: 20,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(
                                              'Country',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.country.toString(),
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      ),
                                      flex: 20,
                                      fit: FlexFit.tight,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 20,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: SizedBox.shrink(),
                              flex: 1,
                              fit: FlexFit.tight,
                            ),
                          ],
                        ),
                      ),
                      flex: 150,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: SizedBox.shrink(),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                  ],
                ),
              ),
              flex: 5,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(
                      child: SizedBox.shrink(),
                      flex: 2,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: Container(
                        child: OutlinedButton(
                          onPressed: () {
                            globals.selectedPortId = data.id;
                          },
                          child: Text(
                            'SHOW ITEMS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          color: Colors.blue,
                        ),
                      ),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                  ],
                ),
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
          ],
        ),
        margin: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            20,
          ),
          color: Color.fromARGB(
            255,
            229,
            239,
            245,
          ),
        ),
      );*/

  Widget buildx(BuildContext context, allPortsDetailModel data) {
    buildCollapsed1() {
      return Container(
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
                        child: Builder(
                          builder: (context) {
                            var controller = ExpandableController.of(context,
                                required: true)!;
                            return TextButton(
                              child: Text(
                                controller.expanded ? "CLOSE" : "SEE DETAILS",
                                style: new TextStyle(
                                    fontSize: 11.0,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                controller.toggle();
                              },
                            );
                          },
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
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(
            255,
            229,
            239,
            245,
          ),
        ),
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
      );
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return Container(
        child: GestureDetector(
          onTap: () {},
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
                          child: Builder(
                            builder: (context) {
                              var controller = ExpandableController.of(context,
                                  required: true)!;
                              return TextButton(
                                child: Text(
                                  controller.expanded ? "CLOSE" : "SEE DETAILS",
                                  style: new TextStyle(
                                      fontSize: 11.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  controller.toggle();
                                },
                              );
                            },
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
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: Color.fromARGB(
            255,
            229,
            239,
            245,
          ),
        ),
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
      );
    }

    buildExpanded3() {
      var customerDetails;
      customerDetails =
          fetchAllPortDetails(url_getAllPortsDetail + data.id, token);
      return Center(
        child: FutureBuilder<allPortsDetailModel>(
          future: customerDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Container(
                height: 150,
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              child: SizedBox.shrink(),
                              flex: 10,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: Container(
                                child: Column(
                                  children: [
                                    Flexible(
                                      child: SizedBox.shrink(),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Name:",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.name,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 3,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: SizedBox.shrink(),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Text(
                                              'Country',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.country,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 3,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: SizedBox.shrink(),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 90,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                              flex: 1,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: Container(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: SizedBox.shrink(),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Flexible(
                                              child: SizedBox.shrink(),
                                              flex: 10,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Note:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.note,
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                              flex: 20,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              flex: 1,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Created At:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.createdAt
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                              flex: 20,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              flex: 1,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Created At:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.createdAt,
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                              flex: 20,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              flex: 1,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Country:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.country,
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                              flex: 20,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              flex: 1,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Created By:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.createdBy,
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                ),
                                              ),
                                              flex: 20,
                                              fit: FlexFit.tight,
                                            ),
                                            Flexible(
                                              child: Container(
                                                child: SizedBox.shrink(),
                                              ),
                                              flex: 10,
                                              fit: FlexFit.tight,
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 20,
                                      fit: FlexFit.tight,
                                    ),
                                    Flexible(
                                      child: SizedBox.shrink(),
                                      flex: 1,
                                      fit: FlexFit.tight,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 150,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: SizedBox.shrink(),
                              flex: 1,
                              fit: FlexFit.tight,
                            ),
                          ],
                        ),
                      ),
                      flex: 5,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                      child: Container(
                        child: Row(
                          children: [
                            Flexible(
                              child: SizedBox.shrink(),
                              flex: 3,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: Container(),
                              flex: 1,
                              fit: FlexFit.tight,
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                  ],
                ),
                margin: new EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  color: Color.fromARGB(
                    255,
                    229,
                    239,
                    245,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      );
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expandable(
              collapsed: buildCollapsed1(),
              expanded: buildExpanded1(),
            ),
            /*Expandable(
                collapsed: buildCollapsed2(),
                expanded: buildExpanded2(),
              ),*/
            Expandable(
              collapsed: buildCollapsed3(),
              expanded: buildExpanded3(),
            ),
            /* Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      var controller =
                          ExpandableController.of(context, required: true)!;
                      return TextButton(
                        child: Text(
                          controller.expanded ? "COLLAPSE" : "EXPAND",
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Colors.deepPurple),
                        ),
                        onPressed: () {
                          controller.toggle();
                        },
                      );
                    },
                  ),
                ],
              ),*/
          ],
        ),
      ),
    ));
  }
}
