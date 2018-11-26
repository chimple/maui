import 'dart:async';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:maui/loca.dart';
import 'package:image/image.dart' as Img;

String imagePathStore;
String userNameStore;
String bigImagePath, tempFilePath;

class CameraScreen extends StatefulWidget {
  CameraScreen(this.editImage);
  bool editImage = false;
  @override
  _CameraScreenState createState() {
    return new _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras;
  CameraController controller;
  String imagePath = '';
  String _deviceId;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onTakePicture = true, onTakePicture1 = false;
  Orientation ornt;
  int mode = -1;

  @override
  void didUpdateWidget(CameraScreen oldwidget) {
    super.didUpdateWidget(oldwidget);
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    var user = AppStateContainer.of(context).state.loggedInUser;

    print("image path checking wether its working or not... $imagePath");
    return Scaffold(
        backgroundColor: Colors.black87,
        key: _scaffoldKey,
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            onTakePicture
                ? new Center(
                    child: RotatedBox(
                        quarterTurns: 1, child: _cameraPreviewWidget()),
                  )
                : Container(
                    child: bigImagePath != ''
                        ? Center(
                            child: onTakePicture1
                                ? null
                                : Image.file(new File(imagePath)))
                        : new Container()),
            Container(
                color: Colors.black87,
                height: 120.0,
                child: Center(child: _captureControlRowWidget(user))),
          ],
        ));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return RotatedBox(
        quarterTurns: -1,
        child: Text(
          Loca.of(context).tapACamera,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    } else {
      return new Container(
        height: double.infinity,
        width: double.infinity,
        //aspectRatio: 1.6, //controller.value.aspectRatio,
        child: new CameraPreview(controller),
      );
    }
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget(User user) {
    if (onTakePicture)
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.white,
            child: Center(
              child: Transform.rotate(
                angle: .8,
                child: new IconButton(
                    iconSize: 30.0,
                    splashColor: Colors.white,
                    icon: const Icon(
                      Icons.add,
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pop();
                      imagePathStore = null;
                    }),
              ),
            ),
          ),
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.white,
            child: Center(
              child: new IconButton(
                iconSize: 30.0,
                splashColor: Colors.white,
                icon: const Icon(
                  Icons.camera_alt,
                ),
                color: Colors.blue,
                onPressed: controller != null &&
                        controller.value.isInitialized &&
                        !controller.value.isRecordingVideo
                    ? onTakePictureButtonPressed
                    : null,
              ),
            ),
          ),
        ],
      );
    else if (onTakePicture1) {
      return new Container(
        color: Colors.black12,
      );
    } else
      return Container(
        height: 120.0,
        color: Colors.black54,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.0,
                child: Transform.rotate(
                  angle: .80,
                  child: new IconButton(
                    color: Colors.black54,
                    iconSize: 30.0,
                    onPressed: () {
                      setState(() {
                        imagePathStore = '';
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                        onTakePicture = true;
                        onTakePicture1 = true;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                )),
            CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.0,
                child: Center(
                  child: new IconButton(
                    color: Colors.black54,
                    iconSize: 30.0,
                    onPressed: () {
                      if (widget.editImage == true) {
                        print("object is fine ${widget.editImage}");
                        _changeState(user);
                      }
                      imagePathStore = imagePath;

                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.done),
                  ),
                )),
          ],
        ),
      );
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  // void onTakenPicture() {
  //   SystemChrome.setPreferredOrientations([]);
  //     setState(() {
  //     onTakePicture1 = true;
  //     onTakePicture = false;
  //   });
  //   takePicture().then((String bigFilePath) async {
  //     String filePath;
  //     final bigImage = Img.decodeImage(new File(bigFilePath).readAsBytesSync());
  //     // int ht = bigImage.height;
  //     // int wd = bigImage.width;
  //     // int reducedHt = ((ht - wd)/2).toInt();
  //     // int reducedWd = 0;
  //     // print("Values of Reduced height and Width - $reducedHt.........$reducedWd");
  //     // final croppedImage = bigImage.width > bigImage.height
  //     //     ? Img.copyCrop(
  //     //         bigImage,
  //     //         ((bigImage.height - bigImage.width)/2).toInt(),
  //     //         ((bigImage.height - bigImage.width)/2).toInt(),
  //     //         bigImage.height,
  //     //         bigImage.width)
  //     //     : Img.copyCrop(
  //     //         bigImage,
  //     //         ((bigImage.height - bigImage.width)/2).toInt(),
  //     //         ((bigImage.height - bigImage.width)/2).toInt(),
  //     //         bigImage.width,
  //     //         bigImage.height);
  //     new File(bigFilePath)..writeAsBytesSync(Img.encodePng(bigImage));
      
  //     if (mounted) {
  //       setState(() {
  //         bigImagePath = bigFilePath;
  //         imagePath = bigImagePath;
  //         onTakePicture = false;
  //         onTakePicture1 = false;
  //       });
  //       onTakePictureButtonPressed();
  //       // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  //       // final thumbnail = Img.copyResize(bigImage, 64);

  //       // // // Save the thumbnail as a PNG.
  //       // new File(imagePath)..writeAsBytesSync(Img.encodePng(thumbnail));
  //       //  setState(() {
  //       //     // imagePath = bigFilePath;
  //       //     imagePathStore = imagePath;            
  //       //   });
  //     }
  //   });
  // }

  void onTakePictureButtonPressed() {
    SystemChrome.setPreferredOrientations([]);
    setState(() {
      onTakePicture1 = true;
      onTakePicture = false;
    });
    takePicture().then((String filePath) async {
      final image = Img.decodeImage(new File(filePath).readAsBytesSync());

      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      final thumbnail = Img.copyResize(image, 64);

      // Save the thumbnail as a PNG.
      new File(filePath)..writeAsBytesSync(Img.encodePng(thumbnail));

      if (mounted) {
        Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            imagePath = filePath;
            imagePathStore = imagePath;
            onTakePicture = false;
            onTakePicture1 = false;
          });
        });
      }
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
    SystemChrome.setPreferredOrientations([]);
    controller.dispose();
    super.dispose();
  }

  void initCamera() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    cameras = await availableCameras();
    print("print camera lenafa$cameras");
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
    print("contloafasfsa ${controller.value.aspectRatio}");
  }

  void _changeState(User user) async {
    if (imagePathStore != user.image && user.image != null) {
      var user1 = user;
      user1.image = imagePathStore;
      UserRepo().update(user1);
    }
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
