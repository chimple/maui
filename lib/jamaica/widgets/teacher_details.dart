import 'dart:convert';
import 'package:built_value/standard_json_plugin.dart';
import 'package:maui/models/class_session.dart';
import 'package:maui/models/serializers.dart';
import 'package:flutter/material.dart';

class TeacherDetails extends StatelessWidget {
  final dynamic teacher;

  const TeacherDetails(this.teacher, {Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

    final newJson = jsonDecode(teacher['endPointName']);
    ClassSession classSession = standardSerializers.deserialize(newJson);

    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    var size = media.size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
      ),
      margin: EdgeInsets.all(size.width * .02),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 5.0),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(50.0)),
                image: DecorationImage(
                  image: AssetImage('assets/score/star.png'),
//                      'assets/stories/images/${classSession.teacherPhoto}'),
                )),
            width: orientation == Orientation.portrait
                ? size.width * 0.2
                : size.width * 0.12,
            height: orientation == Orientation.portrait
                ? size.height * .1
                : size.height * .2,
          ),
          Text(classSession.teacherId,
              style: TextStyle(
                  fontSize: orientation == Orientation.portrait
                      ? size.height * .02
                      : size.height * .05,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis),
          Text(classSession.classId,
              style: TextStyle(
                  fontSize: orientation == Orientation.portrait
                      ? size.height * .015
                      : size.height * .03,
                  color: Colors.white),
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
