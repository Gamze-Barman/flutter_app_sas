import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'globals.dart' as globals;

String token = globals.token;

String url_getAllAttachments = globals.baseUrl +
    'LineItemAttachment/GetRequisitionsAttachments?requisitionId=';

class allAttachmentsModel {
  final String id;
  final String lineItemId;
  final String number;
  final String itemCode;
  final String description;
  final String url;
  final int type;
  final String fileName;
  final String contentType;

  allAttachmentsModel(
      {required this.id,
      required this.lineItemId,
      required this.number,
      required this.itemCode,
      required this.description,
      required this.url,
      required this.type,
      required this.fileName,
      required this.contentType});

  factory allAttachmentsModel.fromJson(Map<String, dynamic> json) {
    return allAttachmentsModel(
      id: json['id'] ?? '',
      lineItemId: json['lineItemId'] ?? '',
      number: json['number'] ?? '',
      itemCode: json['itemCode'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? 0,
      fileName: json['fileName'] ?? '',
      contentType: json['contentType'] ?? '',
    );
  }
}

Future<List<allAttachmentsModel>> fetchAllAttachments(
    String url, String token) async {
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": "bearer " + token,
  });
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new allAttachmentsModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occuredhy!');
  }
}

class AttachmentsPage extends StatefulWidget {
  @override
  _AttachmentsPageState createState() => _AttachmentsPageState();
}

class _AttachmentsPageState extends State<AttachmentsPage> {
  late Future<List<allAttachmentsModel>> allAttachmentsData;

  @override
  void initState() {
    super.initState();
    allAttachmentsData = fetchAllAttachments(
        url_getAllAttachments + globals.selectedRequisitionId, token);
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
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            child: Text(
                              'Number',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          flex: 1,
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Container(
                            child: Text(
                              'Item Code',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          flex: 1,
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Container(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          flex: 1,
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Container(
                            child: Text(
                              'File Name',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          flex: 1,
                          fit: FlexFit.tight,
                        ),
                        Flexible(
                          child: Container(
                            child: SizedBox.shrink(),
                          ),
                          flex: 1,
                          fit: FlexFit.tight,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                  ),
                  flex: 1,
                  fit: FlexFit.tight,
                ),
                Flexible(
                  child: FutureBuilder<List<allAttachmentsModel>>(
                    future: allAttachmentsData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<allAttachmentsModel>? data = snapshot.data;

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

  Container makeContainer(allAttachmentsModel data) => Container(
        child: Row(
          children: [
            Flexible(
              child: Container(
                child: Text(
                  data.number,
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
                  data.itemCode,
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
                  data.description,
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
                  data.fileName,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Icon(
                Icons.download_rounded,
                color: Colors.blue,
                size: 14.0,
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
          ],
        ),
        alignment: Alignment.center,
      );
}
