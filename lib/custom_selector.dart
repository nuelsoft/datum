import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Selector extends StatefulWidget {
  final List<String> items;
  int selectedIndex = 0;
  final String title;
  final Function(int) onSelect;

  Selector(
      {@required this.items, this.selectedIndex, this.onSelect, this.title});

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  List<Widget> convertItems() {
    List<Widget> ls = [];
    for (int i = 0; i < widget.items.length; i++) {
      ls.add(ListTile(
        contentPadding: EdgeInsets.only(left: 6),
        title: Text(
          "${widget.items[i]}",
        ),
        leading: (widget.selectedIndex == i)
            ? Icon(
                CupertinoIcons.circle_filled,
                color: Theme.of(context).accentColor,
              )
            : Icon(CupertinoIcons.circle),
        onTap: () {
          widget.onSelect(i);
        },
      ));
    }
    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        (widget.title == null)
            ? Container(
                height: 0,
                width: 0,
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.title}",
                  style: TextStyle(fontSize: 15),
                ),
              ),
        Card(
          child: Column(children: convertItems()),
        ),
      ],
    );
  }
}
