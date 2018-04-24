import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  var output;
  SecondScreen(this.output);
  @override
  Widget build(BuildContext context) {
    print({"this is object": output});
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("DrawRecieve page"),
      ),
      body: new FittedBox(
          fit: BoxFit.fill,
          child: new Container(
            // otherwise the logo will be tiny
            child: Text("This is Drawing game"),
          ),
        ),
      );
  }
}

