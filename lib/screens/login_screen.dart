import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/camera.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maui/screens/welcome_screen.dart';
import 'tab_home.dart';
import 'package:maui/components/gameaudio.dart';
import 'package:maui/loca.dart';
import 'package:nima/nima_actor.dart';
import 'package:image/image.dart' as Img;

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
  CameraDescription camera;
  final textEditController = TextEditingController();
  double _size = 500.0;
  FocusNode _focusName;
  String _animationName;
  bool paused;
  bool disabled;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _animationName = "signup";
    paused = false;
    disabled = false;

    controller = new AnimationController(
        duration: new Duration(milliseconds: 50), vsync: this);
    shakeAnimation = new Tween(begin: -4.0, end: 4.0).animate(controller);
    controller.addStatusListener((status) {});
    _focusName = FocusNode()
      ..addListener(() {
        _focusName.hasFocus ? _compressIcon() : _decompressIcon();
      });
    _initData();
  }

  _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      User user = await UserRepo().getUser(userId);
      await AppStateContainer.of(context).setLoggedInUser(user);
      Navigator.of(context).pushNamed('/welcome');
    }
    var users = await UserRepo().getLocalUsers();

    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  _compressIcon() {
    setState(() {
      _size = 250.0;
    });
  }

  _decompressIcon() {
    setState(() {
      _size = 500.0;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    _focusName.dispose();
    controller.dispose();
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

  // String imagePath;
  // bool displaImage = true;
  // // call this method for android camera
  // Future getImageOriganl() async {
  //   String image = await ImagePick.pickImage(source: ImageSrc.camera);
  //   print("image path $image");
  //   setState(() {
  //     imagePath = image;
  //     displaImage = false;
  //   });
  // }

  Orientation ornt;
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    var user = AppStateContainer.of(context).state.loggedInUser;
    return Scaffold(
      appBar: _isLoading
          ? null
          : new AppBar(
              backgroundColor: new Color(0xff4C5C9E),
              title: new Text(Loca.of(context).enterYourDetails),
            ),
      body: new Container(
        decoration: new BoxDecoration(
          color: Colors.purple,
        ),
        child: _isLoading
            ? new SizedBox(
                width: 20.0,
                height: 20.0,
                child: new CircularProgressIndicator(),
              )
            : (_users?.length ?? 0) == 0
                ? new Container()
                // : new UserList(users: _users),
                : ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: new Column(
                          // mainAxisAlignment:
                          // MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: AlignmentDirectional.center,
                              child: AnimatedContainer(
                                height: _size,
                                width: _size,
                                curve: Curves.bounceOut,
                                child: new AspectRatio(
                                    aspectRatio: 2.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 40.0, right: 40.0),
                                      child: new NimaActor("assets/quack",
                                          animation: _animationName,
                                          alignment: Alignment.center,
                                          fit: BoxFit.scaleDown,
                                          mixSeconds: 0.2,
                                          paused: paused,
                                          completed: (String animationName) {
                                        setState(() {
                                          paused = true;
                                          _animationName = null;
                                        });
                                      }),
                                    )),
                                duration: Duration(milliseconds: 1200),
                              ),
                            ),
                            new Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                new Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        new BorderRadius.circular(50.0),
                                    border: new Border.all(
                                      width: 6.0,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Padding(
                                        padding: size.height > size.width
                                            ? new EdgeInsets.all(10.0)
                                            : new EdgeInsets.all(5.0),
                                      ),
                                      imagePathStore == null
                                          ? Container(
                                              height: size.height > size.width
                                                  ? size.height * 0.2
                                                  : size.height * 0.075,
                                              width: size.height > size.width
                                                  ? size.width * 0.2
                                                  : size.width * 0.1,
                                              child: RaisedButton(
                                                splashColor: Colors.amber,
                                                color: Colors.white,
                                                shape: CircleBorder(
                                                    side: BorderSide(
                                                        width: 3.0,
                                                        color: Colors.amber)),
                                                onPressed: () =>
                                                    getImage(context),
                                                child: new IconTheme(
                                                  data: IconThemeData(
                                                      size: size.height * 0.05,
                                                      color: Colors.amber),
                                                  child: Icon(Icons.add),
                                                ),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () => getImage(context),
                                              child: new Container(
                                                  width: 130.0,
                                                  height: 130.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image:
                                                          new DecorationImage(
                                                        image: FileImage(File(
                                                            imagePathStore)),
                                                        fit: BoxFit.fill,
                                                      ))),
                                            ),
                                      new Padding(
                                        padding: size.height > size.width
                                            ? new EdgeInsets.all(
                                                size.height * 0.1)
                                            : new EdgeInsets.fromLTRB(
                                                size.height * 0.04,
                                                size.height * 0.03,
                                                size.height * 0.04,
                                                size.height * 0.085),
                                        child: new TextField(
                                          focusNode: _focusName,
                                          autocorrect: false,
                                          onSubmitted: _submit(userName),
                                          onChanged: _onTyping,
                                          // controller:
                                          //     TextEditingController(
                                          //         text: userName),
                                          decoration: new InputDecoration(
                                            labelStyle:
                                                TextStyle(color: Colors.red),
                                            isDense: true,
                                            border: const OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        const Radius.circular(
                                                            10.0)),
                                                borderSide: const BorderSide(
                                                    style: BorderStyle.solid,
                                                    width: 100.0,
                                                    color: Colors.amber)),
                                            hintText:
                                                Loca.of(context).writeYourName,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: new EdgeInsets.all(20.0),
                                  child: new InkWell(
                                    onTap: disabled ? null : tabSreen,
                                    splashColor: Colors.amber,
                                    child: new Shake(
                                        animation: shakeAnimation,
                                        child: new Container(
                                            // alignment:
                                            //     Alignment(0.0, 0.5),
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                      .all(
                                                  const Radius.circular(16.0)),
                                              color: Colors.amber,
                                            ),
                                            height: size.height * 0.06,
                                            width: size.width * 0.2,
                                            child: disabled
                                                ? Center(
                                                    child: SizedBox(
                                                        height: 16.0,
                                                        width: 16.0,
                                                        child:
                                                            CircularProgressIndicator()))
                                                : Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Colors.white,
                                                    size: 50.0))),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  _onTyping(String name) {
    userName = name;
  }

  _submit(String name) {
    setState(() {
      userName = name;
    });
  }

  String compressedImage;
//  @override
//  void didChangeDependencies() {
//    if (imagePathStore != null) {
//      compressImage(imagePathStore).then((s) {
//        compressedImage = s;
//      });
//    }
//    super.didChangeDependencies();
//  }

  void tabSreen() {
    if (imagePathStore != null && userName != '' && userName != null) {
      setState(() {
        disabled = true;
      });
      compressImage(imagePathStore).then((s) async {
        compressedImage = s;
        user = await new UserRepo().insertLocalUser(new User(
            image: compressedImage,
            currentLessonId: 1,
            name: userName,
            points: 100));
        AppStateContainer.of(context).setLoggedInUser(user);
        Navigator.of(context).pushReplacementNamed('/welcome');
      });
    } else {
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

Future<String> compressImage(String imagePath) async {
  final Directory extDir = await getApplicationDocumentsDirectory();
  final String dirPath = '${extDir.path}/Pictures/flutter_test';
  await Directory(dirPath).create(recursive: true);
  final String filePath = '$dirPath/${timestamp()}.jpg';
  Img.Image image = Img.decodeImage(File(imagePath).readAsBytesSync());
//  print("image original ht and wid: ${image.height} , ${image.width}");
  var cp = Img.copyResize(
    image,
    64,
  );
  var c = File(filePath)..writeAsBytesSync(Img.encodePng(cp));
//  print("compressed image:: ${cp.height}, ${cp.width}");
  return c.path;
}

String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
