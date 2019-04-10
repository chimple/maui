import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/select_student_screen.dart';
import 'package:maui/jamaica/screens/student_log_in_screen.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:maui/jamaica/widgets/teacher_details.dart';

class SelectTeacherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TeachersScreen(advertisers: StateContainer.of(context).advertisers);
  }
}

class TeachersScreen extends StatefulWidget {
  final List<dynamic> advertisers;
  TeachersScreen({Key key, this.advertisers}) : super(key: key);
  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  String selected;
  dynamic selectedTeacher;

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    MediaQueryData media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.orange,
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: media.size.height * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: media.size.width * .05),
                    child: Text(
                      "Choose your Class",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: 40.0,
                    color: Colors.white,
                    onPressed: () {
                      StateContainer.of(context).stopDiscovery();
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) =>
                              StudentLogInScreen()));
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                color: Colors.white70,
                width: media.size.width * .9,
                height: media.size.height * .004,
              ),
            ),
            Expanded(
              child: GridView.count(
                key: new Key('teacher_list'),
                primary: true,
                crossAxisCount: 4,
                childAspectRatio: orientation == Orientation.portrait
                    ? media.size.width / (media.size.height / 1.4)
                    : media.size.width / (media.size.height * 1.6),
                children: widget.advertisers
                    .map((advertiser) => InkWell(
                        onTap: () {
                          setState(() async {
                            selectedTeacher = advertiser;
                            await StateContainer.of(context)
                                .connectTo(selectedTeacher);
                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) =>
                                    SelectStudentScreen(
                                      selectedTeacher: selectedTeacher,
                                      // message: messageData,
                                    )));
                          });
                        },
                        child: TeacherDetails(advertiser)))
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
