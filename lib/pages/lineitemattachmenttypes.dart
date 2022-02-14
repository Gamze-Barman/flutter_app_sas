import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;

String token = globals.token;

String url_getAttachmentTypes =
    globals.baseUrl + 'LineItemAttachment/GetAttachmentTypes';

class allAttachmentTypesModel {
  final String key;
  final int value;

  allAttachmentTypesModel({
    required this.key,
    required this.value,
  });

  factory allAttachmentTypesModel.fromJson(Map<String, dynamic> json) {
    return allAttachmentTypesModel(
      key: json['key'] ?? '',
      value: json['value'] ?? 0,
    );
  }
}

Future<List<allAttachmentTypesModel>> fetchAllAttachmentTypes(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allAttachmentTypesModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhhhyyy!');
  }
}

class AttachmentTypesPage extends StatefulWidget {
  @override
  _AttachmentTypesPageState createState() => _AttachmentTypesPageState();
}

class _AttachmentTypesPageState extends State<AttachmentTypesPage> {
  late Future<List<allAttachmentTypesModel>> allAttachmentTypesData;

  @override
  void initState() {
    super.initState();
    allAttachmentTypesData =
        fetchAllAttachmentTypes(url_getAttachmentTypes, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            "ATTACHMENTS",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 35,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                  ),
                  flex: 1,
                  fit: FlexFit.tight,
                ),
                Flexible(
                  child: FutureBuilder<List<allAttachmentTypesModel>>(
                    future: allAttachmentTypesData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<allAttachmentTypesModel>? data = snapshot.data;

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
                  flex: 10,
                  fit: FlexFit.tight,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container makeContainer(allAttachmentTypesModel data) => Container(
        child: Row(
          children: [
            Flexible(
              child: Container(
                child: Text(
                  data.key,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Container(
                child: Text(
                  data.value.toString(),
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
          ],
        ),
        alignment: Alignment.center,
      );
}
