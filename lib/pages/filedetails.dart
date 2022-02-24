import 'package:flutter/material.dart';
import 'package:flutter_app_sas/pages/requisitionnotes.dart';
import 'package:flutter_app_sas/pages/requisitions.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'globals.dart' as globals;

String token = globals.token;

String url_getFileDetail = globals.baseUrl + 'File?fileId=';

class fileDetailModel {
  final String id;
  final String name;
  final String vesselId;
  final String vessel;
  final String customerId;
  final String customer;
  final int customerRate;
  final String departmentId;
  final String department;
  final String portId;
  final String port;
  final String eta;
  final int paymentType;
  final bool isHighQuality;
  final double discount;
  final String currency;
  final String currencyId;
  final String city;
  final String cityId;
  final String createdBy;
  final String createdDate;
  final double deliveryCost;
  final double rebate;
  final bool isCalled;
  final bool isMailled;
  final double customsCost;
  final String exworkNote;
  final String note;
  final double boatServiceFee;
  final double exworkTransportationCost;
  final String paymentTerm;
  final bool isClosed;
  final String closedBy;
  final String masterDepId;
  final String masterDepName;

  fileDetailModel({
    required this.id,
    required this.name,
    required this.vesselId,
    required this.vessel,
    required this.customerId,
    required this.customer,
    required this.customerRate,
    required this.departmentId,
    required this.department,
    required this.portId,
    required this.port,
    required this.eta,
    required this.paymentType,
    required this.isHighQuality,
    required this.discount,
    required this.currency,
    required this.currencyId,
    required this.city,
    required this.cityId,
    required this.createdBy,
    required this.createdDate,
    required this.deliveryCost,
    required this.rebate,
    required this.isCalled,
    required this.isMailled,
    required this.customsCost,
    required this.exworkNote,
    required this.note,
    required this.boatServiceFee,
    required this.exworkTransportationCost,
    required this.paymentTerm,
    required this.isClosed,
    required this.closedBy,
    required this.masterDepId,
    required this.masterDepName,
  });

  factory fileDetailModel.fromJson(Map<String, dynamic> json) {
    return fileDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      vesselId: json['vesselId'] ?? '',
      vessel: json['vessel'] ?? '',
      customerId: json['customerId'] ?? '',
      customer: json['customer'] ?? '',
      customerRate: json['customerRate'] ?? 0,
      departmentId: json['departmentId'] ?? '',
      department: json['department'] ?? '',
      portId: json['portId'] ?? '',
      port: json['port'] ?? '',
      eta: json['eta'] ?? '',
      paymentType: json['paymentType'] ?? 0,
      isHighQuality: json['isHighQuality'] ?? false,
      discount: json['discount'] ?? 0,
      currency: json['currency'] ?? '',
      currencyId: json['currencyId'] ?? '',
      city: json['city'] ?? '',
      cityId: json['cityId'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdDate: json['createdDate'] ?? '',
      deliveryCost: json['deliveryCost'] ?? 0,
      rebate: json['rebate'] ?? 0,
      isCalled: json['isCalled'] ?? false,
      isMailled: json['isMailled'] ?? false,
      customsCost: json['customsCost'] ?? 0,
      exworkNote: json['exworkNote'] ?? '',
      note: json['note'] ?? '',
      boatServiceFee: json['boatServiceFee'] ?? 0,
      exworkTransportationCost: json['exworkTransportationCost'] ?? 0,
      paymentTerm: json['paymentTerm'] ?? '',
      isClosed: json['isClosed'] ?? false,
      closedBy: json['closedBy'] ?? '',
      masterDepId: json['masterDepId'] ?? '',
      masterDepName: json['masterDepName'] ?? '',
    );
  }
}

Future<fileDetailModel> fetchFileDetails(String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return fileDetailModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Unexpected error occuredhy');
  }
}

class FileDetailsPage extends StatefulWidget {
  @override
  _FileDetailsPage createState() => _FileDetailsPage();
}

class _FileDetailsPage extends State<FileDetailsPage> {
  var fileDetails;

/*
  ShapeBorder? bottomBarShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))) ;
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.pinned;
  EdgeInsets padding = const EdgeInsets.only(left: 12,right: 12,);
  int _selectedItemPosition = 0;
  SnakeShape snakeShape = SnakeShape.circle;
  bool showSelectedLabels = true;
  bool showUnselectedLabels = true;
  Color selectedColor = Colors.white;
  Color unselectedColor = Colors.white;
  Color? containerColor = Colors.blue;
*/
  List<Widget> _items = [
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Profile',
    ),
    Text(
      'Index 2: Shop',
    ),
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    fileDetails =
        fetchFileDetails(url_getFileDetail + globals.selectedFileId, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "FILE DETAILS",
          ),
          Text(
            '',
            style: new TextStyle(
              fontSize: 11.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ]),
        centerTitle: true,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Container(
                alignment: Alignment.center,
                height: double.infinity,
                width: double.infinity,
                child: _showBottomNav(),
              ),
            ),
            Flexible(
              flex: 15,
              fit: FlexFit.tight,
              child: Center(
                child: FutureBuilder<fileDetailModel>(
                  future: fileDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return getBody(
                        snapshot.data!.vessel,
                        snapshot.data!.customer,
                        snapshot.data!.customerRate,
                        snapshot.data!.department,
                        snapshot.data!.port,
                        snapshot.data!.eta,
                        snapshot.data!.paymentType,
                        snapshot.data!.isHighQuality,
                        snapshot.data!.discount,
                        snapshot.data!.currency,
                        snapshot.data!.city,
                        snapshot.data!.deliveryCost,
                        snapshot.data!.rebate,
                        snapshot.data!.isCalled,
                        snapshot.data!.isMailled,
                        snapshot.data!.customsCost,
                        snapshot.data!.exworkNote,
                        snapshot.data!.note,
                        snapshot.data!.boatServiceFee,
                        snapshot.data!.exworkTransportationCost,
                        snapshot.data!.paymentTerm,
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _showBottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.info_outlined),
          label: 'Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Requisitions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notes),
          label: 'Notes',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: _onTap,
    );
  }

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Container makeContainerforDetails(
    String vessel,
    String customer,
    int customerRate,
    String department,
    String port,
    String eta,
    int paymentType,
    bool isHighQuality,
    double discount,
    String currency,
    String city,
    double deliveryCost,
    double rebate,
    bool isCalled,
    bool isMailled,
    double customsCost,
    String exworkNote,
    String note,
    double boatServiceFee,
    double exworkTransportationCost,
    String paymentTerm,
  ) =>
      Container(
        height: double.infinity,
        width: double.infinity,
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
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                'Vessel Name',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Customer Name',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Custome Rate',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Department',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Port',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'City',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Currency',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Eta',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Discount',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Delivery Cost',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Rebate',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Pay. Type',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Pay. Term',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Custom Cost',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Boat Service Fee',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Called',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Mailed',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'High Quality',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Exw. Transport Cost',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Exw. Note',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Note',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        flex: 1,
                        fit: FlexFit.tight,
                      ),
                      Flexible(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vessel,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                customer,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                customerRate.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                department,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                port,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                city,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currency,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                eta,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                discount.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                deliveryCost.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                rebate.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                paymentType.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                paymentTerm,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                customsCost.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                boatServiceFee.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isCalled.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isMailled.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isHighQuality.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                exworkTransportationCost.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                exworkNote,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                note,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
          margin: EdgeInsets.only(
            left: 30,
            right: 30,
          ),
        ),
      );

  Widget getBody(
      vessel,
      customer,
      customerRate,
      department,
      port,
      eta,
      paymentType,
      isHighQuality,
      discount,
      currency,
      city,
      deliveryCost,
      rebate,
      isCalled,
      isMailled,
      customsCost,
      exworkNote,
      note,
      boatServiceFee,
      exworkTransportationCost,
      paymentTerm) {
    List<Widget> pages = [
      makeContainerforDetails(
          vessel,
          customer,
          customerRate,
          department,
          port,
          eta,
          paymentType,
          isHighQuality,
          discount,
          currency,
          city,
          deliveryCost,
          rebate,
          isCalled,
          isMailled,
          customsCost,
          exworkNote,
          note,
          boatServiceFee,
          exworkTransportationCost,
          paymentTerm),
      RequisitionsPage(),
      RequisitionNotesPage(),
    ];

    return IndexedStack(
      index: _selectedIndex,
      children: pages,
    );
  }
}

/*
Container(
child: Row(
children: [
Flexible(
child: GestureDetector(
child: Container(
child: Text(
'INFO',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.bold,
),
),
alignment: Alignment.center,
),
onTap: () {},
),
flex: 1,
fit: FlexFit.tight,
),
Flexible(
child: GestureDetector(
child: Container(
child: Text(
'REQUISITIONS',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.bold,
),
),
alignment: Alignment.center,
),
onTap: () {},
),
flex: 1,
fit: FlexFit.tight,
),
Flexible(
child: GestureDetector(
child: Container(
child: Text(
'ATTACHMENTS',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.bold,
),
),
alignment: Alignment.center,
),
onTap: () {},
),
flex: 1,
fit: FlexFit.tight,
),
Flexible(
child: GestureDetector(
child: Container(
child: Text(
'NOTES',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 9,
fontWeight: FontWeight.bold,
),
),
alignment: Alignment.center,
),
onTap: () {},
),
flex: 1,
fit: FlexFit.tight,
),
],
),
),*/
