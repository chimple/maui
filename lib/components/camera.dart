import 'dart:async';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/screens/login_screen.dart';

String imagePathStore;
String userNameStore;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return new _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras;
  CameraController controller;
  String imagePath;
  String _deviceId;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onTakePicture = true;
  Orientation ornt;
  int mode = -1;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        backgroundColor: Colors.black87,
        key: _scaffoldKey,
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            onTakePicture
                ? new Center(
                    child: RotatedBox(
                        quarterTurns: -1, child: _cameraPreviewWidget()),
                  )
                : Container(
                    child: Center(child: Image.file(new File(imagePath)))),
            Container(
                height: 80.0, child: Center(child: _captureControlRowWidget())),
          ],
        ));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return RotatedBox(
        quarterTurns: 1,
        child: Text(
          'Tap a camera',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    } else {
      return new AspectRatio(
        aspectRatio: 1.7, //controller.value.aspectRatio,
        child: new CameraPreview(controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    if (onTakePicture)
      return CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.white,
        child: Center(
          child: new IconButton(
            iconSize: 30.0,
            splashColor: Colors.white,
            icon: const Icon(Icons.camera_alt),
            color: Colors.blue,
            onPressed: controller != null &&
                    controller.value.isInitialized &&
                    !controller.value.isRecordingVideo
                ? onTakePictureButtonPressed
                : null,
          ),
        ),
      );
    else
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50.0,
              child: new IconButton(
                color: Colors.black54,
                iconSize: 30.0,
                onPressed: () {
                  setState(() {
                    onTakePicture = true;
                  });
                },
                icon: Icon(Icons.arrow_back),
              )),
          new Padding(
            padding: new EdgeInsets.all(20.0),
          ),
          CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50.0,
              child: Center(
                child: new IconButton(
                  color: Colors.black54,
                  iconSize: 30.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.done),
                ),
              )),
        ],
      );
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) async {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          onTakePicture = false;
        });
//        if (filePath != null) showInSnackBar('Picture saved to $filePath');
        // var user = await new UserRepo()
        //     .insertLocalUser(new User(image: filePath, currentLessonId: 1));
        //print("insert image path:: ${user.image}");
        //AppStateContainer.of(context).setLoggedInUser(user);
        //Navigator.of(context).pop();
      }
      imagePathStore = imagePath;
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  @override
  void initState() {
    super.initState();

    initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([]);
  }

  void initCamera() async {
    cameras = await availableCameras();
    controller = new CameraController(cameras[1], ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
