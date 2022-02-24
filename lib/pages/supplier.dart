import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/attachments.dart';
import 'package:flutter_app_sas/pages/search_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;

String token = globals.token;

String url_getAllSupplier = globals.baseUrl + 'Supplier/GetAllSuppliers';
String url_getAllSupplierDetail = globals.baseUrl + 'Supplier?Id=';

class allSupplierModel {
  final String id;
  final String name;

  allSupplierModel({
    required this.id,
    required this.name,
  });

  factory allSupplierModel.fromJson(Map<String, dynamic> json) {
    return allSupplierModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class allSupplierDetailModel {
  final String id;
  final String name;
  final String primaryEmail;
  final String address;
  final String phone;
  final String taxNumber;
  final String createdAt;
  final String createdBy;
  final String lastUpdatedAt;
  final String lastUpdatedBy;
  final String supplierTypeId;
  final String detailsOfBusinessScope;
  final String contactDetails;
  final String country;

  allSupplierDetailModel({
    required this.id,
    required this.name,
    required this.primaryEmail,
    required this.address,
    required this.phone,
    required this.taxNumber,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdatedAt,
    required this.lastUpdatedBy,
    required this.supplierTypeId,
    required this.detailsOfBusinessScope,
    required this.contactDetails,
    required this.country,
  });

  factory allSupplierDetailModel.fromJson(Map<String, dynamic> json) {
    return allSupplierDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      primaryEmail: json['primaryEmail'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      taxNumber: json['taxNumber'] ?? '',
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      lastUpdatedAt: json['lastUpdatedAt'] ?? '',
      lastUpdatedBy: json['lastUpdatedBy'] ?? '',
      supplierTypeId: json['supplierTypeId'] ?? '',
      detailsOfBusinessScope: json['detailsOfBusinessScope'] ?? '',
      contactDetails: json['contactDetails'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

Future<List<allSupplierModel>> fetchAllSuppliers(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allSupplierModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhy!');
  }
}

Future<allSupplierDetailModel> fetchAllSupplierDetails(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return allSupplierDetailModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Unexpected error occuredhy');
  }
}

class SupplierPage extends StatefulWidget {
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  late List<allSupplierModel> allSuppliers;
  late List<allSupplierModel> suppliers;

  late Future<List<allSupplierModel>> allSuppliersData;

  // Future<allSupplierDetailModel>? customerDetails;

  String query = '';

  @override
  void initState() {
    super.initState();
    //allCustomersData = fetchAllSuppliers(url_getAllSupplier, token);
    convertLists();
  }

  void convertLists() async {
    allSuppliersData = fetchAllSuppliers(url_getAllSupplier, token);
    allSuppliers = await allSuppliersData;
    suppliers = allSuppliers;
  }

  void searchBook(String query) {
    final suppliers = allSuppliers.where((suppliers) {
      final titleLower = suppliers.name.toLowerCase();
      //final authorLower = vessel.author.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.suppliers = suppliers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "SUPPLIERS",
          ),
          Text(
            'Please select supplier to see the details',
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
        child: FutureBuilder<List<allSupplierModel>>(
          future: allSuppliersData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allSupplierModel>? data = suppliers;
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
        hintText: 'Suppliers Name',
        onChanged: searchBook,
      );

  Container makeContainer(allSupplierModel data) => Container(
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

  Widget _buildPopupDialog(BuildContext context, allSupplierModel data) {
    var vesselDetails;
    vesselDetails =
        fetchAllSupplierDetails(url_getAllSupplierDetail + data.id, token);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 250),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(30),
      )),
      content: Center(
        child: FutureBuilder<allSupplierDetailModel>(
          future: vesselDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return makePopupContainer(
                context,
                snapshot.data!.id,
                snapshot.data!.name,
                snapshot.data!.country,
                snapshot.data!.primaryEmail,
                snapshot.data!.address,
                snapshot.data!.phone,
                snapshot.data!.taxNumber,
                snapshot.data!.contactDetails,
                snapshot.data!.detailsOfBusinessScope,
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
    String country,
    String primaryEmail,
    String address,
    String phone,
    String taxNumber,
    String contactDetails,
    String detailsOfBusinessScope,
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
                            'Country:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'E-Mail:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                            child: Text(
                          'Address:',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                        Container(
                            child: Text(
                          'Phone:',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                        Container(
                            child: Text(
                          'TaxNumber:',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                    Column(
                      children: [
                        Container(
                          child: Text(
                            country,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            primaryEmail,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            address,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            phone,
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            taxNumber,
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

  Widget buildx(BuildContext context, allSupplierModel data) {
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
          fetchAllSupplierDetails(url_getAllSupplierDetail + data.id, token);
      return Center(
        child: FutureBuilder<allSupplierDetailModel>(
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
                                              "E-mail",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.primaryEmail,
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
                                              'Phone',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.phone,
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
                                                      'Address',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.address,
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
                                                      'Tax Number:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.taxNumber
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
                                                      'Contact Details:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!.contactDetails,
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
                                                      'Business Scope:',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!
                                                          .detailsOfBusinessScope,
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
