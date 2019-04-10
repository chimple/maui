import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/state_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maui/storyboards/widgets/drop_down.dart';
import 'package:path_provider/path_provider.dart';

class SelfSignUpScreen extends StatefulWidget {
  @override
  _SelfSignUpScreenState createState() {
    return _SelfSignUpScreenState();
  }
}

class _SelfSignUpScreenState extends State<SelfSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _studentName;
  String _standard;
  String _id;
  File _image;
  String _board;
  String studentImage;
  List<String> _standardList = ['1', '2', '3', '4', '5', '6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: Text(
                "Self Sign Up",
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Center(
            child: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * 0.9,
              height: 8.0,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/Background_potriat.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Center(
                            child: _image == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      color: const Color(0xFFE18025),
                                      icon: Icon(Icons.add_a_photo),
                                      iconSize: 80.0,
                                      onPressed: () {
                                        openCamera();
                                      },
                                    ),
                                    maxRadius: 80.0,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        ExactAssetImage(studentImage),
                                    maxRadius: 80.0,
                                  ),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Student Name',
                                ),
                                onSaved: (input) {
                                  _studentName = input;
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter student name';
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Dropdown(
                            menuItems: _standardList,
                            hintText: 'select standard',
                            selectedItem: (String value) {
                              _standard = value;
                            },
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Dropdown(
                            menuItems: <String>['Central', 'State'],
                            hintText: 'select Board',
                            selectedItem: (String value) {
                              _board = value;
                            },
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Center(
                            child: RaisedButton(
                              color: const Color(0xFFE18025),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  await StateContainer.of(context).selfSignUp(
                                      _standard,
                                      "${_studentName + _standard}",
                                      _studentName,
                                      studentImage);

                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openCamera() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 256.0, maxWidth: 256.0);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String _imagePath = appDocDir.uri
        .resolve("${DateTime.now().millisecondsSinceEpoch}.jpg")
        .path;
    File _imageFile = await _image.copy(_imagePath);
    userImage(_imagePath);
  }

  userImage(String _image) async {
    setState(() {
      // this._image = _image;
      this.studentImage = _image;
    });
  }
}
