import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/expand.dart';
import 'package:flutter_app_sas/pages/search_widget.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'filedetails.dart';
import 'globals.dart' as globals;

String token = globals.token;

String url_getAllCustomer = globals.baseUrl + 'Customer/GetAllCustomers';

String url_getCustomerDetail = globals.baseUrl + 'Customer?customerId=';

class allCustomersModel {
  final String id;
  final String name;

  allCustomersModel({required this.id, required this.name});

  factory allCustomersModel.fromJson(Map<String, dynamic> json) {
    return allCustomersModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class customerDetailModel {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String country;
  final int paymentType;
  final String paymentTerm;
  final String note;
  final Currency currency;
  final int rate;
  final double discount;

  customerDetailModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.country,
    required this.paymentType,
    required this.paymentTerm,
    required this.note,
    required this.currency,
    required this.rate,
    required this.discount,
  });

  factory customerDetailModel.fromJson(Map<String, dynamic> json) {
    return customerDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      paymentType: json['paymentType'] ?? 0,
      paymentTerm: json['paymentTerm'] ?? '',
      note: json['note'] ?? '',
      currency: Currency.fromJson(json["currency"]),
      rate: json['rate'] ?? 0,
      discount: json['discount'] ?? 0.0,
    );
  }
}

class Currency {
  String? id;
  String? name;
  bool? isDefault;

  Currency({this.id, this.name, this.isDefault});

  factory Currency.fromJson(Map<String, dynamic> parsedJson) {
    return Currency(
      id: parsedJson['id'],
      name: parsedJson['name'],
      isDefault: parsedJson['isDefault'],
    );
  }
}

Future<List<allCustomersModel>> fetchAllCustomers(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allCustomersModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhy!');
  }
}

Future<customerDetailModel> fetchCustomerDetails(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return customerDetailModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Unexpected error occuredhy');
  }
}

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late List<allCustomersModel> allCustomers;
  late List<allCustomersModel> customers;

  late Future<List<allCustomersModel>> allCustomersData;

  //Future<customerDetailModel>? customerDetails;

  String query = '';

  @override
  void initState() {
    super.initState();
    //allCustomersData = fetchAllCustomers(url_getAllCustomer, token);
    convertLists();
  }

  void convertLists() async {
    allCustomersData = fetchAllCustomers(url_getAllCustomer, token);
    allCustomers = await allCustomersData;
    customers = allCustomers;
  }

  void searchBook(String query) {
    final customers = allCustomers.where((customer) {
      final titleLower = customer.name.toLowerCase();
      //final authorLower = vessel.author.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.customers = customers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "CUSTOMERS",
          ),
          Text(
            'Please select customer to see the details',
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
        child: FutureBuilder<List<allCustomersModel>>(
          future: allCustomersData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<allCustomersModel>? data = customers;
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
        hintText: 'Customers Name',
        onChanged: searchBook,
      );

  Container makeContainer(allCustomersModel data) => Container(
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

  Widget _buildPopupDialog(BuildContext context, allCustomersModel data) {
    var vesselDetails;
    vesselDetails =
        fetchCustomerDetails(url_getCustomerDetail + data.id, token);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(vertical: 250),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(30),
      )),
      content: Center(
        child: FutureBuilder<customerDetailModel>(
          future: vesselDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return makePopupContainer(
                context,
                snapshot.data!.id,
                snapshot.data!.name,
                snapshot.data!.address,
                snapshot.data!.phone,
                snapshot.data!.email,
                snapshot.data!.country,
                snapshot.data!.paymentType.toInt(),
                snapshot.data!.paymentTerm,
                snapshot.data!.discount.toInt(),
                snapshot.data!.note,
                snapshot.data!.currency,
                snapshot.data!.rate,
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
    String address,
    String phone,
    String email,
    String country,
    int paymentType,
    String paymentTerm,
    int discount,
    String note,
    Currency currency,
    int rate,
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
                            'Address:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Phone:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Email:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Country:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Payment Type:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Payment Term:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Discount:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Note:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Currency:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Rate:',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
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
                            address,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            phone,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            email,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            country,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            paymentType.toString(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            paymentTerm,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            discount.toString(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            note,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            currency.name.toString(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 6,
                            ),
                          ),
                        ),
                        Container(
                          /*child: Text(
                            rate.toString(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                            ),
                          ),*/
                          child: Icon(
                            Icons.star_border,
                            color: Colors.blue,
                            size: 20.0,
                          ), //
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

  /* Card makeCard(allCustomersModel data) => Card(
    elevation: 8.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    color: Colors.blue,
    child: Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
      ),

      child: makeListTile(data),
    ),
  );
  ListTile makeListTile(allCustomersModel data) => ListTile(
    contentPadding:
    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.person, color: Colors.blue),
    ),
    title: Text(
      data.name,
      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),

    trailing:
    Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 30.0),
    onTap: () {
          showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(context),
      );
    },
  );
  Widget _buildPopupDialog(BuildContext context) {
    var customerDetails;
    customerDetails = fetchCustomerDetails(url_getCustomerDetail,token);

    return AlertDialog(
      title: const Text('Popup example'),
      content:Center(
        child: FutureBuilder<customerDetailModel>(
          future: customerDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Text("Name"),
                      Text("E-mail"),
                      Text("Address"),
                      Text("Payment Type"),
                      Text("Payment Term"),
                      Text("Country"),
                      Text("Currency"),
                      Text("Note"),

                    ],
                  ),
                  Column(
                    children: [
                      Text(snapshot.data!.name),
                      Text(snapshot.data!.email),
                      Text(snapshot.data!.address),
                      Text(snapshot.data!.paymentType.toString()),
                      Text(snapshot.data!.paymentTerm),
                      Text(snapshot.data!.country),
                      Text(snapshot.data!.currency),
                      Text(snapshot.data!.note),
                    ],
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      )
      ,
      actions: <Widget>[
        new FlatButton(
          onPressed: () {

           // Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }*/
  Widget buildx(BuildContext context, allCustomersModel data) {
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

    /* buildCollapsed2() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ]);
    }*/

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

    /* buildExpanded2() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ]);
    }*/

    buildExpanded3() {
      var customerDetails;
      customerDetails =
          fetchCustomerDetails(url_getCustomerDetail + data.id, token);
      return Center(
        child: FutureBuilder<customerDetailModel>(
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
                                              snapshot.data!.email,
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
