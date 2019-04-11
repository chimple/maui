import 'package:maui/models/class_students.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/student_details.dart';
import 'package:maui/jamaica/widgets/teacher_details.dart';
import 'package:maui/models/student.dart';

class SelectStudentScreen extends StatefulWidget {
  final dynamic selectedTeacher;
  final dynamic message;

  SelectStudentScreen({Key key, this.selectedTeacher, this.message})
      : super(key: key);

  @override
  _SelectStudentScreenState createState() => _SelectStudentScreenState();
}

class _SelectStudentScreenState extends State<SelectStudentScreen> {
  List<Student> studentList = [];
  String selectedStudent;
  ClassStudents classStudents;

  @override
  Widget build(BuildContext context) {
    if (StateContainer.of(context).classStudents != null) {
      classStudents = StateContainer.of(context).classStudents;

      studentList.clear();
      for (var i = 0; i < classStudents.students.length; i++) {
        studentList.add(classStudents.students[i]);
      }
    }
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: TeacherDetails(widget.selectedTeacher),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(5.0),
              color: Colors.white70,
              width: media.size.width * .9,
              height: orientation == Orientation.portrait
                  ? media.size.height * .004
                  : media.size.height * .005,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: media.size.width * .05),
            child: Container(
              width: media.size.width,
              child: Text(
                "Select your Photo",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              child: StateContainer.of(context).classStudents != null
                  ? GridView.count(
                      key: new Key('student_list_page'),
                      primary: true,
                      childAspectRatio: orientation == Orientation.portrait
                          ? media.size.width / (media.size.height / 1.5)
                          : media.size.width / (media.size.height * 1.3),
                      crossAxisCount: 4,
                      children: studentList
                          .map((t) => InkWell(
                              onTap: () async {
                                await StateContainer.of(context).studentJoin(
                                    t.id,
                                    classStudents.sessionId,
                                    widget.selectedTeacher['endPointId']);
                                Navigator.of(context).pushNamed('/chatbot');
                              },
                              child: StudentDetails(t)))
                          .toList(growable: false),
                    )
                  : Center(
                      child: SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator()),
                    )),
        ],
      ),
    );
  }
}
