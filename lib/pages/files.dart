import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'filedetails.dart';
import 'globals.dart' as globals;

String token = globals.token;

String url_getAllFiles = globals.baseUrl + 'File/GetFilesbyVesselId?vesselId=';

class allFilesModel {
  final String id;
  final String name;
  final String vessel;
  final String customer;
  final String department;
  final String port;
  final int paymentType;
  final String paymentTerm;
  final String currency;
  final String city;
  final String eta;

  allFilesModel({
    required this.id,
    required this.name,
    required this.vessel,
    required this.customer,
    required this.department,
    required this.port,
    required this.paymentType,
    required this.paymentTerm,
    required this.currency,
    required this.city,
    required this.eta,
  });

  factory allFilesModel.fromJson(Map<String, dynamic> json) {
    return allFilesModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      vessel: json['vessel'] ?? '',
      customer: json['customer'] ?? '',
      department: json['department'] ?? '',
      port: json['port'] ?? '',
      paymentType: json['paymentType'] ?? 0,
      paymentTerm: json['paymentTerm'] ?? '',
      currency: json['currency'] ?? '',
      city: json['city'] ?? '',
      eta: json['eta'] ?? '',
    );
  }
}

Future<List<allFilesModel>> fetchAllFiles(String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allFilesModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

class FilesPage extends StatefulWidget {
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  late Future<List<allFilesModel>> allFilesData;

  @override
  void initState() {
    super.initState();
    allFilesData =
        fetchAllFiles(url_getAllFiles + globals.selectedVesselId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "FILES",
          ),
          Text(
            'Please select file to see file details',
            style: new TextStyle(
              fontSize: 11.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ]),
        centerTitle: true,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<allFilesModel>>(
          future: allFilesData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allFilesModel>? data = snapshot.data;

              return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeContainer(data[index]);
                  });
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

  Container makeContainer(allFilesModel data) => Container(
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
                                      'Name:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.name,
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
                                      'Vessel:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.vessel,
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
                                              'Department',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.department,
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
                                              'Customer',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.customer,
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
                                              'Port',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.port,
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
                                              'Pay Type',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.paymentType.toString(),
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
                                              'Pay Term',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.paymentTerm,
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
                      child: Container(
                        child: OutlinedButton(
                          onPressed: () {
                            globals.selectedFileId = data.id;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FileDetailsPage()),
                            );
                          },
                          child: Text(
                            'SELECT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
      );

  /* Widget _buildPopupDialog(BuildContext context) {
    var vesselDetails;
    vesselDetails = fetchVesselDetails(url_getVesselDetail,token);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 250),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30),)
      ),
      content:Center(
        child: FutureBuilder<vesselDetailModel>(
          future: vesselDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return makePopupContainer(snapshot.data!.name, snapshot.data!.imo, snapshot.data!.flag, snapshot.data!.company);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),

    );
  }*/

  Container makePopupContainer(
    String name,
    String imo,
    String flag,
    String company,
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
                            'Name',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Imo',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Flag',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Company',
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
                            name,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
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
                        Container(
                          child: Text(
                            company,
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
                    Container(
                      child: OutlinedButton(
                        child: Text(
                          'SHOW ORDERS',
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
                        onPressed: () {},
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: OutlinedButton(
                        child: Text(
                          'SHOW ITEMS',
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
                        onPressed: () {},
                      ),
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
