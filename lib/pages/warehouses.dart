import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/warehousesreportitem.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;
import 'orderspage.dart';

String token = globals.token;

String url_getAllWarehouses = globals.baseUrl + 'Warehouse/GetWarehouses';

class allWarehousesModel {
  final String id;
  final String name;
  final String currencyId;
  final String managerEmail;
  final bool isFreeZone;
  final String departmentId;

  allWarehousesModel({
    required this.id,
    required this.name,
    required this.currencyId,
    required this.managerEmail,
    required this.isFreeZone,
    required this.departmentId,
  });

  factory allWarehousesModel.fromJson(Map<String, dynamic> json) {
    return allWarehousesModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      currencyId: json['currencyId'] ?? '',
      managerEmail: json['managerEmail'] ?? '',
      isFreeZone: json['isFreeZone'] ?? false,
      departmentId: json['departmentId'] ?? '',
    );
  }
}

Future<List<allWarehousesModel>> fetchAllWarehouses(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allWarehousesModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

class WarehousesPage extends StatefulWidget {
  @override
  _WarehousesPageState createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  late Future<List<allWarehousesModel>> allWarehousesData;

  @override
  void initState() {
    super.initState();
    allWarehousesData = fetchAllWarehouses(url_getAllWarehouses, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "WAREHOUSES",
          ),
          Text(
            'Please select warehouse to see its Items & Orders',
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
        child: FutureBuilder<List<allWarehousesModel>>(
          future: allWarehousesData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allWarehousesModel>? data = snapshot.data;
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

  Widget makeContainer(allWarehousesModel data) {
    globals.selectedVesselId = data.id;
    String currency = "";
    String department = "";

    /* if (data.currencyId == "dbdbe32d-eecb-4ce9-83f9-22da6d1e9ac1") {
      currency = "USD";
    } else if (data.currencyId == "dce874db-4186-4797-8cfb-372ef5039438") {
      currency = "test1";
    } else if (data.currencyId == "ce409be2-d011-4bf9-bddb-454b852ef24e") {
      currency = "YUAN";
    } else if (data.currencyId == "cb747837-33cd-4509-82e8-68281f7ae227") {
      currency = "TL";
    } else if (data.currencyId == "d863092f-04b3-4926-ab08-a24ff5803d05") {
      currency = "EURO";
    } else if (data.currencyId == "5a66a2a9-b642-452c-a010-fe1ed495aebe") {
      currency = "Test67";
    } else {
      currency = "-";
    }*/

    /*if (data.departmentId == "9b8954ab-1569-491f-96cb-192742cef5dd") {
      department = "Accounting";
    } else if (data.departmentId == "f332f079-a5c6-4ae4-8e1e-92fe56c37803") {
      department = "Technical";
    } else if (data.departmentId == "a08c391b-bbe6-491e-b607-a4ab109bc505") {
      department = "Catering";
    } else if (data.departmentId == "521cdcf4-48c9-4f1e-9e4e-b1eb951a0505") {
      department = "Sales";
    } else if (data.departmentId == "bdaf1361-64fd-4ec1-9117-d6cbd9e4a3cd") {
      department = "Custom";
    } else {
      department = "-";
    }*/

    return Container(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(
                context,
                data.name,
                department,
                data.managerEmail,
                currency,
                data.isFreeZone.toString()),
          );
          globals.selectedWarehouseId = data.id;
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
  }

  Widget _buildPopupDialog(
    BuildContext context,
    String name,
    String departmentId,
    String managerEmail,
    String currencyId,
    String isFreeZone,
  ) {
    return AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 250),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(20),
        )),
        content: makePopupContainer(
            name, departmentId, managerEmail, currencyId, isFreeZone));
  }

  Container makePopupContainer(
    String name,
    String departmentId,
    String managerEmail,
    String currencyId,
    String isFreeZone,
  ) =>
      Container(
        height: 240,
        child: Column(
          children: [
            Flexible(
              flex: 1,
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
                            'Department:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'E-mail:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Currency:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'FreeZone:',
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
                            departmentId,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            managerEmail,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            currencyId,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            isFreeZone.toString(),
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
              flex: 2,
              child: Container(
                child: Row(
                  children: [
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WarehousesReportItemPage()),
                          );
                        },
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrdersPage()),
                          );
                        },
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
