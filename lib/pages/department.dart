import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_sas/pages/orderlineitemspage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'filedetails.dart';
import 'globals.dart' as globals;

String token = globals.token;

String url_getDepartment = globals.baseUrl + 'Department/GetAllDepartments';

class allDepartmentModel {
  final String id;
  final String name;
  final String suffix;
  final String masterDepartmentId;
  final bool isSubDepartment;

  allDepartmentModel({
    required this.id,
    required this.name,
    required this.suffix,
    required this.masterDepartmentId,
    required this.isSubDepartment,
  });

  factory allDepartmentModel.fromJson(Map<String, dynamic> json) {
    return allDepartmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      suffix: json['suffix'] ?? '',
      masterDepartmentId: json['masterDepartmentId'] ?? '',
      isSubDepartment: json['isSubDepartment'] ?? false,
    );
  }
}

Future<List<allDepartmentModel>> fetchAllDepartments(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allDepartmentModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

class DepartmentPage extends StatefulWidget {
  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  late Future<List<allDepartmentModel>> allDepartmentData;

  @override
  void initState() {
    super.initState();
    allDepartmentData = fetchAllDepartments(url_getDepartment, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "DEPARTMENTS",
            ),
            Text(
              'Please select orders to see details',
              style: new TextStyle(
                fontSize: 11.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder<List<allDepartmentModel>>(
          future: allDepartmentData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allDepartmentModel>? data = snapshot.data;

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

  Container makeContainer(allDepartmentModel data) => Container(
        height: 140,
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
                                              data.name,
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
                      flex: 100,
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
                                      ' Suffix:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.suffix,
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
                                      'isSubDepartment:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.isSubDepartment.toString(),
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
                            globals.selectedOrderId = data.id;
                          },
                          child: Text(
                            'SELECT',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 9),
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
}
