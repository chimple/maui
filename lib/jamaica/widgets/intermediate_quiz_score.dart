import 'package:flutter/material.dart';

class IntermediateQuizScore extends StatelessWidget {
  final Function onTap;

  const IntermediateQuizScore({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: onTap,
        child: Text('Next'),
      ),
    );
  }
}
