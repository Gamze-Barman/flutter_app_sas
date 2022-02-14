import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_sas/pages/orderlineitemspage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'filedetails.dart';
import 'globals.dart' as globals;

String token = globals.token;

String url_getOrders = globals.baseUrl + 'Order/GetOrders?warehouseId=';

class allOrdersModel {
  final String id;
  final String vesselName;
  final String orderNumber;
  final String department;
  final String date;
  final int status;

  allOrdersModel({
    required this.id,
    required this.vesselName,
    required this.orderNumber,
    required this.department,
    required this.date,
    required this.status,
  });

  factory allOrdersModel.fromJson(Map<String, dynamic> json) {
    return allOrdersModel(
      id: json['id'] ?? '',
      vesselName: json['vesselName'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      department: json['department'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}

Future<List<allOrdersModel>> fetchAllOrders(String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allOrdersModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<allOrdersModel>> allOrdersData;

  @override
  void initState() {
    super.initState();
    allOrdersData =
        fetchAllOrders(url_getOrders + globals.selectedWarehouseId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "ORDERS",
          ),
          Text(
            'Please select orders to see details',
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
        child: FutureBuilder<List<allOrdersModel>>(
          future: allOrdersData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allOrdersModel>? data = snapshot.data;

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

  Container makeContainer(allOrdersModel data) => Container(
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
                                            /*Text(
                                              'Department',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),*/
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
                                      'Vessel Name:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.vesselName,
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
                                      'OrderNumber:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.orderNumber,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderLineItemsPage()),
                            );
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
