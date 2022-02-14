import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter_app_sas/pages/customers.dart';
import 'package:flutter_app_sas/pages/vessels.dart';
import 'package:flutter_app_sas/pages/warehouses.dart';
import 'package:flutter_app_sas/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
