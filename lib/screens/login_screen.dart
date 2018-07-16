import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/camera.dart';
import 'package:maui/components/user_list.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tab_home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() {
    return new _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  List<User> _users;
  var user;
  dynamic decode;
  String userName;
  bool _isLoading = false, fileExist = false;
  Animation shakeAnimation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    _isLoading = true;

    controller = new AnimationController(
        duration: new Duration(milliseconds: 50), vsync: this);
    shakeAnimation = new Tween(begin: -4.0, end: 4.0).animate(controller);
    controller.addStatusListener((status) {});

    _initData();
  }

  _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      User user = await UserRepo().getUser(userId);
      AppStateContainer.of(context).setLoggedInUser(user);

      Navigator.of(context).pushNamed('/tab');
    }
    var users = await UserRepo().getLocalUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  getImage(BuildContext context) async {
//    var _fileName = await ImagePicker.pickImage(
//        source: ImageSource.camera, maxHeight: 128.0, maxWidth: 128.0);
//    var user = await new UserRepo()
//        .insert(new User(image: _fileName.path, currentLessonId: 1));
//    AppStateContainer.of(context).setLoggedInUser(user);
    Navigator.of(context).pushNamed('/camera');
  }

  String imagePath;
  bool displaImage = true;
  Future getImageOriganl() async {
    String image = await ImagePick.pickImage(source: ImageSrc.camera);
    print("image path $image");
    setState(() {
      imagePath = image;
      displaImage = false;
    });
  }

  Orientation ornt;
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    print("user detail ?::: $user");
    return (user != null)
        ? new TabHome()
        : new Scaffold(
            appBar: _isLoading
                ? null
                : new AppBar(
                    backgroundColor: new Color(0xff4C5C9E),
                    title: new Text('Create Account'),
                  ),
            body: _isLoading
                ? new SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: new CircularProgressIndicator(),
                  )
                : (_users?.length ?? 0) == 0
                    ? new Container()
                    // : new UserList(users: _users),
                    : Container(
                        padding: const EdgeInsets.all(20.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            imagePath == null
                                ? Center(
                                    child: Container(
                                      height: 130.0,
                                      width: 130.0,
                                      child: RaisedButton(
                                        splashColor: Colors.blue,
                                        color: Colors.white,
                                        shape: CircleBorder(
                                            side: BorderSide(
                                                width: 3.0,
                                                color: new Color(0xff4C5C9E))),
                                        onPressed: getImageOriganl,
                                        child: new IconTheme(
                                          data: IconThemeData(
                                              size: 70.0,
                                              color: new Color(0xff4C5C9E)),
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: getImageOriganl,
                                    child: new Container(
                                        width: 130.0,
                                        height: 130.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              image: new FileImage(
                                                  new File(imagePath)),
                                              fit: BoxFit.fill,
                                            ))),
                                  ),
                            new TextField(
                              autocorrect: false,
                              onSubmitted: _submit(userName),
                              onChanged: _onTyping,
                              controller: TextEditingController(text: userName),
                              decoration: new InputDecoration(
                                labelStyle: TextStyle(color: Colors.red),
                                isDense: true,
                                border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0)),
                                    borderSide: const BorderSide(
                                        style: BorderStyle.solid,
                                        width: 100.0,
                                        color: const Color(0xff4C5C9E))),
                                hintText: 'Write Your Name...',
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(0.0),
                            ),
                            Shake(
                              animation: shakeAnimation,
                              child: Container(
                                // margin: const EdgeInsets.only(top: 10.0),
                                width: 100.0,
                                height: 50.0,
                                child: new RaisedButton(
                                    splashColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: BorderSide(
                                            width: 3.0,
                                            color: new Color(0xff4C5C9E))),
                                    color: new Color(0xffE3EB28),
                                    child: new Icon(Icons.keyboard_arrow_right),
                                    onPressed: tabSreen),
                              ),
                            )
                          ],
                        ),
                      ),
          );
  }

  _onTyping(String name) {
    userName = name;
  }

  _submit(String name) {
    print('call on submit $name');
    setState(() {
      userName = name;
    });
  }

  void tabSreen() async {
    if (imagePath != null && userName != '' && userName != null) {
      var user = await new UserRepo().insertLocalUser(
          new User(image: imagePath, currentLessonId: 1, name: userName));
      AppStateContainer.of(context).setLoggedInUser(user);
      //Navigator.of(context).pop();
    } else {
      print("false");
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
      controller.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        controller.stop();
      });
    }
  }
}

enum ImageSrc {
  camera,
  galery,
}

class ImagePick {
  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/image_picker');
  static Future<String> pickImage({
    @required ImageSrc source,
    double maxWidth,
    double maxHeight,
  }) async {
    assert(source != null);

    List<CameraDescription> cameras;
    if (maxWidth != null && maxWidth < 0) {
      print("camera sdede $cameras");
      throw new ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
    }

    if (maxHeight != null && maxHeight < 0) {
      throw new ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
    }
    final String path = await _channel.invokeMethod(
      'pickImage',
      <String, dynamic>{
        'source': source.index,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      },
    );

    return path == null ? null : path;
  }
}
