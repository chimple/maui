import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';

class Buttonunit extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  final double height;
  final String bgImage;

  Buttonunit({
    Key key,
    this.text,
    this.height,
    this.bgImage,
    this.onPress,
  }) : super(key: key);

  @override
  _ButtonunitState createState() {
    return new _ButtonunitState();
  }
}

class _ButtonunitState extends State<Buttonunit> {
  @override
  Widget build(BuildContext context) {
    int rowSize = 1;
    int valTextNumber = 0;
    if (int.tryParse(widget.text) != null) {
      valTextNumber = int.tryParse(widget.text);
    }
    List numberDots = new List(valTextNumber);
    if (numberDots.length > 5) {
      rowSize = 2;
    } else {
      rowSize = 1;
    }
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(top: 8.0, left: 5.0, right: 3.0),
        height: widget.height,
        width: widget.height - 2,
        // color: Colors.white,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 5.0,
        child: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            image: widget.bgImage != null
                ? new DecorationImage(
                    image: new AssetImage(widget.bgImage), fit: BoxFit.cover)
                : null,
            color: Colors.teal,
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
          ),
          height: widget.height,
          width: widget.height,
          child: FlatButton(
              splashColor: Theme.of(context).accentColor,
              highlightColor: Theme.of(context).accentColor,
              onPressed: () {
                widget.onPress();
              },
              padding: EdgeInsets.all(0.0),
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: valTextNumber == 0
                  ? Text("${widget.text}",
                      style: TextStyle(color: Colors.black, fontSize: 30.0))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          Text("${widget.text}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 30.0)),
                          new ResponsiveGridView(
                            rows: rowSize,
                            cols: 5,
                            children: numberDots
                                .map((e) => new Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: _buildDots()))
                                .toList(growable: false),
                          ),
                        ])),
        ),
      ),
    ]);
  }

  Widget _buildDots() {
    return new Icon(
      Icons.panorama_fish_eye,
      color: Colors.white,
      size: 13.0,
    );
  }
}
