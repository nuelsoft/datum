import 'package:datum/admin.dart';
import 'package:datum/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datum',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Montserrat"),
      home: MyHomePage(title: 'Datum'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final bool adminMode = false;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: (widget.adminMode)
              ? <Widget>[
                  IconButton(
                      icon: Icon(Icons.dashboard),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AdminPage()));
                      })
                ]
              : [],
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Text(
                "Please fill out the form \nAll fields are compulsory unless otherwise indicated"),
            DatumForm()
          ],
        ));
  }
}
