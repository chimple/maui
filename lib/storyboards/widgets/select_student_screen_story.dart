import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/select_student_screen.dart';
import 'package:storyboard/storyboard.dart';

class SelectStudentScreenStory extends FullScreenStory {
  @override
  List<Widget> get storyContent => [
        Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: SelectStudentScreen(
                selectedTeacher: {
                  "endPointName":
                      "{\"\$\":\"ClassSession\",\r\n\"classId\":\"class1234\",\r\n\"name\":\"English\",\"teacherName\":\"teacher1\",\r\n\"teacherPhoto\":\"002page5.jpg\",\r\n\"sessionId\":\"session1\"\r\n}",
                  "endpointId": "x123y"
                },
                message:
                    "{\"\$\":\"ClassStudents\",\"classId\":\"class1\",\"sessionId\":\"session12\",\"students\":[{\"id\":\"123\",\"name\":\"nikhil\",\"grade\":\"grade 2\",\"photo\":\"002page5.jpg\"},{\"id\":\"124\",\"name\":\"kiran\",\"grade\":\"grade 2\",\"photo\":\"002page5.jpg\"},{\"id\":\"135\",\"name\":\"shant\",\"grade\":\"grade 2\",\"photo\":\"002page5.jpg\"},{\"id\":\"125\",\"name\":\"manu\",\"grade\":\"grade 2\",\"photo\":\"002page5.jpg\"}]}",
              ),
            ),
          ),
        )
      ];
}
