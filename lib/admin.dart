import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class AdminPage extends StatefulWidget {
  static final TextEditingController _emailController = TextEditingController();

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String filePath;
  String currentProcess;
  bool isProcessing = false;

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();

    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/clouddata.csv';
    return File('$path/clouddata.csv').create();
  }

  getCsv() async {
    setState(() {
      currentProcess = "Getting data from the cloud";
      isProcessing = true;
    });
    List<List<dynamic>> rows = List<List<dynamic>>();
    var cloud = await Firestore.instance
        .collection("datum")
        .document("data")
        .get()
        .whenComplete(() {
      setState(() {
        currentProcess = "Decoding data";
      });
    });
    rows.add([
      "Name",
      "Gender",
      "Phone Number",
      "Email",
      "Age",
      "Area",
      "Assembly",
      "Meal Ticket"
    ]);
    if (cloud.data != null) {
      for (int i = 0; i < cloud.data["collected"].length; i++) {
        List<dynamic> row = List<dynamic>();
        row.add(cloud.data["collected"][i]["name"]);
        row.add(cloud.data["collected"][i]["gender"]);
        row.add(cloud.data["collected"][i]["phone"]);
        row.add(cloud.data["collected"][i]["email"]);
        row.add(cloud.data["collected"][i]["age_bracket"]);
        row.add(cloud.data["collected"][i]["area"]);
        row.add(cloud.data["collected"][i]["assembly"]);
        row.add(cloud.data["collected"][i]["meal_ticket"]);
        rows.add(row);
      }


      File f = await _localFile.whenComplete(() {
        setState(() {
          currentProcess = "Writing to CSV";
        });
      });
      String csv = const ListToCsvConverter().convert(rows);
      f.writeAsString(csv);
      // filePath = f.uri.path;
    }
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'Data Collected and Compiled by the Datum App. <br> A CSV file is attached to this <b>mail</b> <hr><br> Compiled at ${DateTime.now()}',
      subject: 'Datum Entry for ${DateTime.now().toString()}',
      recipients: [AdminPage._emailController.text],
      isHTML: true,
      attachmentPath: filePath,
    );

    await FlutterEmailSender.send(email);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Datum Dash")),
      body: ListView(
        padding: EdgeInsets.only(top: 45, right: 10, left: 10, bottom: 20),
        children: <Widget>[
          Text("Welcome to DashBoard",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
          Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: AdminPage._emailController,
                    validator: (str) => (str.length == 0)
                        ? "please enter your email"
                        : (!EmailUtils.isEmail(str))
                            ? "please enter a valid email"
                            : null,
                    decoration: InputDecoration(
                        labelText: "Enter your email",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.email)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text("Compile and Send"),
                    onPressed: (isProcessing)
                        ? null
                        : () async {
                            if (_formkey.currentState.validate()) {
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  await getCsv().then((v) {
                                    setState(() {
                                      currentProcess =
                                          "Compiling and sending mail";
                                    });
                                    sendMailAndAttachment().whenComplete(() {
                                      setState(() {
                                        isProcessing = false;
                                      });
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text("Data Sent"),
                                      ));
                                    });
                                  });
                                }
                              } on SocketException catch (_) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Connect your device to the internet, and try again"),
                                ));
                              }
                            }
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    visible: (isProcessing) ? true : false,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            child: CircularProgressIndicator(),
                            height: 25,
                            width: 25),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("$currentProcess"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
