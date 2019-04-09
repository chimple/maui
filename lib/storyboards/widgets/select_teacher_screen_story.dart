import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/select_teacher_screen.dart';
import 'package:storyboard/storyboard.dart';

class SelectTeacherScreenStory extends FullScreenStory {
  String get obj1 =>
      "{\"\$\":\"ClassSession\",\r\n\"classId\":\"class1234\",\r\n\"name\":\"English\",\"teacherName\":\"teacher1\",\r\n\"teacherPhoto\":\"002page5.jpg\",\r\n\"sessionId\":\"session1\"\r\n}";
  String get obj2 =>
      "{\"\$\":\"ClassSession\",\r\n\"classId\":\"class4321\",\r\n\"name\":\"kannada\",\"teacherName\":\"teacher2\",\r\n\"teacherPhoto\":\"002page2.jpg\",\r\n\"sessionId\":\"session3\"\r\n}";

  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: TeachersScreen(
                advertisers: [
                  {"endPointName": obj1, "endpointId": "xyza"},
                  {"endPointName": obj2, "endpointId": "abcd"},
                ],
              ),
            ),
          ),
        )
      ];
}
