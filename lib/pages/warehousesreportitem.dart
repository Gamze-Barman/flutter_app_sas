import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;

String token = globals.token;

String url_getReportItems = globals.baseUrl + "Warehouse/GetReportItems?id=";

class warehouseDetailModel {
  final String id;
  final String warehouseId;
  final String itemCode;
  final String description;
  final String unit;
  final double cost;
  final String currencyId;
  final double vat;
  final String remark;
  final double availableQtty;

  warehouseDetailModel({
    required this.id,
    required this.warehouseId,
    required this.itemCode,
    required this.description,
    required this.unit,
    required this.cost,
    required this.currencyId,
    required this.vat,
    required this.remark,
    required this.availableQtty,
  });

  factory warehouseDetailModel.fromJson(Map<String, dynamic> json) {
    return warehouseDetailModel(
      id: json['id'] ?? '',
      warehouseId: json['warehouseId'] ?? '',
      itemCode: json['itemCode'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      cost: json['cost'] ?? 0.0,
      currencyId: json['currencyId'] ?? '',
      vat: json['vat'] ?? 0.0,
      remark: json['remark'] ?? '',
      availableQtty: json['availableQtty'] ?? 0.0,
    );
  }
}

Future<List<warehouseDetailModel>> fetchAllWarehousesDetails(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new warehouseDetailModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

class WarehousesReportItemPage extends StatefulWidget {
  @override
  _WarehousesReportItemPageState createState() =>
      _WarehousesReportItemPageState();
}

class _WarehousesReportItemPageState extends State<WarehousesReportItemPage> {
  late Future<List<warehouseDetailModel>> allWarehouseItemsData;

  @override
  void initState() {
    super.initState();
    allWarehouseItemsData = fetchAllWarehousesDetails(
        url_getReportItems + globals.selectedWarehouseId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "WAREHOUSES REPORT ITEMS",
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
        child: FutureBuilder<List<warehouseDetailModel>>(
          future: allWarehouseItemsData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<warehouseDetailModel>? data = snapshot.data;

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

  Container makeContainer(warehouseDetailModel data) => Container(
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
                              child: SizedBox.shrink(),
                              flex: 1,
                              fit: FlexFit.tight,
                            ),
                            Flexible(
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      'Remark:',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      data.remark,
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
                                              'Item Code',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.itemCode,
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
                                        child: Column(
                                          children: [
                                            Text(
                                              'Description:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.description,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 3,
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
                                              'Unit',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.unit,
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
                                              'Available Qtty',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.availableQtty.toString(),
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
                                              'Cost',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.cost.toString(),
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
                                              'Currency',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.currencyId.toString(),
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
                                              'Vat',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              data.vat.toString(),
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
                      flex: 3,
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

/*
  late Future<List<warehouseDetailModel>> allWarehousesData;

  @override
  void initState() {
    super.initState();
    allWarehousesData = fetchAllWarehousesDetails(
            url_getReportItems + globals.selectedWarehouseId, token)
        as Future<List<warehouseDetailModel>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "WAREHOUSES REPORT ITEMS",
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
        child: FutureBuilder<List<warehouseDetailModel>>(
          future: allWarehousesData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<warehouseDetailModel>? data = snapshot.data;
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

  Widget makeContainer(warehouseDetailModel data) {
    String currency = "";
    String department = "";

    if (data.currencyId == "dbdbe32d-eecb-4ce9-83f9-22da6d1e9ac1") {
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
    }

    return _buildPopupDialog(context, "", "", "", "", "");
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
          Radius.circular(30),
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
              flex: 3,
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
            ),
          ],
        ),
      );

   */

}
