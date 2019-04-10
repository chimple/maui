import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> menuItems;
  final String hintText;
  final String value;
  final Function selectedItem;
  Dropdown({this.menuItems, this.hintText, this.value, this.selectedItem});
  @override
  _DropdownState createState() => new _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String dropdownValue;
  int _index;
  @override
  void initState() {
    super.initState();
    _index =
        widget.value == null ? null : widget.menuItems.indexOf(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.black54,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: new Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Theme.of(context).primaryColor),
          child: DropdownButtonFormField(
            hint: Center(
              child: Text(
                widget.hintText,
              ),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            value: _index == null ? null : widget.menuItems[_index],
            onChanged: (String newValue) {
              setState(() {
                _index = widget.menuItems.indexOf(newValue);
              });
              widget.selectedItem(newValue);
            },
            items:
                widget.menuItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
