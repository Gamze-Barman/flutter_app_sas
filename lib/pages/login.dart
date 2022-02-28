import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_sas/pages/vessels.dart';
import 'package:flutter_app_sas/pages/customexception.dart';
import 'package:flutter_app_sas/root.dart';
import 'package:flutter_app_sas/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'homepage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class loginModel {
  final String token;
  final String refreshToken;
  final bool success;
  final String errors;

  loginModel({
    required this.token,
    required this.refreshToken,
    required this.success,
    required this.errors,
  });

  factory loginModel.fromJson(Map<String, dynamic> json) {
    return loginModel(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      success: json['success'] ?? false,
      errors: json['errors'] ?? '',
    );
  }
}

Future<loginModel> postLogin(RoundedLoadingButtonController controller) async {
  var responseJson;
  try {
    final response = await http.post(
      Uri.parse(globals.baseUrl + '/Identity/login'),
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json-patch+json",
      },
      body: jsonEncode(<String, String>{
        "email": "ikardas@izmeer.com",
        "password": "Izmeer35",
      }),
    );
    responseJson = _returnResponse(response, controller);
  } on SocketException {
    throw FetchDataException('No Internet connection');
  }
  return responseJson;
}

dynamic _returnResponse(
    http.Response response, RoundedLoadingButtonController controller) {
  switch (response.statusCode) {
    case 200:
      globals.token = loginModel.fromJson(jsonDecode(response.body)).token;
      print(globals.token);
      print("refreshToken" +
          loginModel.fromJson(jsonDecode(response.body)).refreshToken);
      print("success" +
          loginModel.fromJson(jsonDecode(response.body)).success.toString());
      print("errors" + loginModel.fromJson(jsonDecode(response.body)).errors);

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('CompanyId');
      print(payload['CompanyId']);
      globals.userCompanyId = payload['CompanyId'];
      controller.success();
      return loginModel.fromJson(jsonDecode(response.body));
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _btnController1.stateStream.listen((value) {
      print(value);
    });
  }

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  Future<loginModel>? loginData;

  bool _rememberMe = false;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RoundedLoadingButton(
        elevation: 5.0,
        color: Colors.white,
        valueColor: Colors.blue,
        errorColor: Colors.white,
        successColor: Colors.white,
        successIcon: Icons.check,
        failedIcon: Icons.dangerous,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        controller: _btnController1,
        onPressed: () {
          postLogin(_btnController1);
          Timer(
            Duration(seconds: 1),
            () {
              if (globals.token != "" || globals.token != null) {
                print(globals.token);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      title: 'Home',
                    ),
                  ),
                );
              } else {
                print("unsuccesful login");
              }
            },
          );
        },
      ),
      /*RaisedButton(
        elevation: 5.0,

        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFA6B1CD),
                      Color(0xFF7F99B8),
                      Color(0xFFDADEE3),
                      Color(0xFF1B4676),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
