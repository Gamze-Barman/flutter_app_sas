import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter_app_sas/pages/customers.dart';
import 'package:flutter_app_sas/pages/port.dart';
import 'package:flutter_app_sas/pages/supplier.dart';
import 'package:flutter_app_sas/pages/vessels.dart';
import 'package:flutter_app_sas/pages/warehouses.dart';
import 'package:flutter_app_sas/pages/login.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.lightBlue[300],
          selectedItemBorderColor: Colors.lightBlue[300],
          selectedItemBackgroundColor: Colors.white,
          selectedItemIconColor: Colors.lightBlue[300],
          selectedItemLabelColor: Colors.white,
          unselectedItemIconColor: Colors.white,
          unselectedItemLabelColor: Colors.white,
        ),
        selectedIndex: _selectedIndex,
        onSelectTab: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.people,
            label: 'Customers',
          ),
          FFNavigationBarItem(
            iconData: Icons.calendar_today,
            label: 'Vessels',
          ),
          FFNavigationBarItem(
            iconData: Icons.wallet_membership,
            label: 'Warehouses',
          ),
          FFNavigationBarItem(
            iconData: Icons.wallpaper,
            label: 'Suppliers',
          ),
          FFNavigationBarItem(
            iconData: Icons.access_alarm_rounded,
            label: 'Ports',
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      CustomersPage(),
      VesselsPage(),
      WarehousesPage(),
      /*Center(
        child: Text("Settings Page",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),),
      ),*/
      SupplierPage(),
      PortsPage(),
      //PortsPage(),
    ];
    return IndexedStack(
      index: _selectedIndex,
      children: pages,
    );
  }
}
