import 'package:datum/custom_selector.dart';
import 'package:datum/global.dart';
import 'package:flutter/material.dart';

class Areas extends StatefulWidget {
  @override
  _AreasState createState() => _AreasState();
}

class _AreasState extends State<Areas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Areas"),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Selector(
            items: Global.areas,
            onSelect: (i) {
              Global.areaController.text = Global.areas[i];
              setState(() {
                Global.selectedArea = i;
              });
            },
            selectedIndex: Global.selectedArea,
          )
        ],
      ),
    );
  }
}
