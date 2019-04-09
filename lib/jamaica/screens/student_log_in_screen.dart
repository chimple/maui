import 'dart:convert';
import 'package:built_value/standard_json_plugin.dart';
import 'package:maui/models/serializers.dart';
import 'package:maui/models/student.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/screens/self_sign_up_screen.dart';
import 'package:maui/jamaica/widgets/student_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentLogInScreen extends StatefulWidget {
  StudentLogInScreen({Key key}) : super(key: key);

  _StudentLogInScreenState createState() => _StudentLogInScreenState();
}

class _StudentLogInScreenState extends State<StudentLogInScreen> {
  List<String> _students;
  bool _isLoading = false;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initData();
  }

  void _initData() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    _students = prefs.getKeys() != null
        ? prefs
            .getKeys()
            .toList(growable: false)
            .map((k) => prefs.getString(k))
            .toList(growable: false)
        : null;

    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(children: [
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
          Center(
            child: Container(
              margin: EdgeInsets.all(5.0),
              color: Colors.white70,
              width: media.size.width * .9,
              height: 5.0,
            ),
          ),
          Expanded(
            child: _isLoading
                ? SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  )
                : _students != null
                    ? GridView.count(
                        key: new Key('local_student_list'),
                        primary: true,
                        crossAxisCount: 4,
                        children: _students
                            .map((student) => StudentItem(student: student))
                            .toList())
                    : Container(),
          ),
        ]),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.5,
        child: FloatingActionButton(
          key: ValueKey('add-student'),
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute<Null>(
              builder: (BuildContext context) => SelfSignUpScreen())),
        ),
      ),
    );
  }
}

class StudentItem extends StatelessWidget {
  final String student;

  StudentItem({Key key, @required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final standardSerializers =
        (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
    final newJson = jsonDecode(student);
    Student studentDetails = standardSerializers.deserialize(newJson);
    return Center(
        child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/chatbot'),
            child: StudentDetails(studentDetails)));
  }
}
