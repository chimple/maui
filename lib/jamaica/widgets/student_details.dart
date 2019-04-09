import 'package:data/data.dart';
import 'package:flutter/material.dart';

class StudentDetails extends StatelessWidget {
  final Student studentDetails;

  const StudentDetails(this.studentDetails, {Key key}) : super(key: key);

  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    var size = media.size;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 5.0),
              borderRadius: const BorderRadius.all(const Radius.circular(60.0)),
              image: DecorationImage(
                image: AssetImage(studentDetails.photo),
              )
              ),
          width: orientation == Orientation.portrait
              ? size.width * 0.2
              : size.width * 0.12,
          height: orientation == Orientation.portrait
              ? size.height * .1
              : size.height * .2,
        ),
        Text(studentDetails.name,
            style: TextStyle(
                fontSize: orientation == Orientation.portrait
                    ? size.height * .02
                    : size.height * .05,
                color: Colors.white),
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
