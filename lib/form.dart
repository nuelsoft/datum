import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datum/areas.dart';
import 'package:datum/custom_selector.dart';
import 'package:datum/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatumForm extends StatefulWidget {
  @override
  _DatumFormState createState() => _DatumFormState();
}

class _DatumFormState extends State<DatumForm> {
  bool mTicket = false;
  int genderSelected = 0;
  int ageSelected = 0;
  List<String> genderSelectItems = ["Male", "Female"];
  List<String> ageSelectItems = ["Child", "Youth", "Adult"];

  static TextEditingController nameController = TextEditingController();
  static TextEditingController phoneController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static TextEditingController assemblyController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clear() {
    Global.areaController.clear();
    nameController.clear();
    emailController.clear();
    assemblyController.clear();
    mTicket = false;
    phoneController.clear();
    ageSelected = 0;
    genderSelected = 0;
    Global.selectedArea = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextFormField(
              controller: nameController,
              validator: (str) =>
                  (str.length == 0) ? "please fill this out" : null,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
                  labelText: "Name",
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Selector(
              items: genderSelectItems,
              selectedIndex: genderSelected,
              title: "Gender",
              onSelect: (i) {
                setState(() {
                  genderSelected = i;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: phoneController,
              validator: (str) =>
                  (str.length == 0) ? "please fill this out" : null,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
                  labelText: "Phone Number",
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: emailController,
              validator: (str) => (str.length != 0 && !EmailUtils.isEmail(str))
                  ? "please enter a correct email"
                  : null,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
                  labelText: "Email (optional)",
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Selector(
              items: ageSelectItems,
              selectedIndex: ageSelected,
              title: "Age Bracket",
              onSelect: (i) {
                setState(() {
                  ageSelected = i;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: Global.areaController,
              validator: (str) =>
                  (str.length == 0) ? "please fill this out" : null,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
                  labelText: "Area",
                  suffix: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, CupertinoPageRoute(builder: (_) => Areas()));
                    },
                    child: Text("Select"),
                  ),
                  border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: assemblyController,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 10),
                  labelText: "Assembly (optional)",
                  border: OutlineInputBorder()),
            ),
          ),
          SwitchListTile(
            value: mTicket,
            title: Text("Meal Ticket"),
            onChanged: (b) {
              setState(() {
                mTicket = b;
              });
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 8, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    setState(() {
                      clear();
                    });
                  },
                  child: Text("Clear"),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Firestore fstore = Firestore.instance;

                      fstore.collection("datum").document("data").setData({
                        "collected": FieldValue.arrayUnion([
                          {
                            "name": nameController.text,
                            "gender": genderSelectItems[genderSelected],
                            "phone": phoneController.text,
                            "email": emailController.text,
                            "age_bracket": ageSelectItems[ageSelected],
                            "area": Global.areaController.text,
                            "assembly": assemblyController.text,
                            "meal_ticket": mTicket
                          }
                        ])
                      }, merge: true).whenComplete(() {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("Success: submitted data"),
                            ),
                            duration: Duration(milliseconds: 500)));
                      });
                      clear();
                    }
                  },
                  child: Text("Submit"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
