import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttery/gestures.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/db/entity/unit.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/repos/unit_repo.dart';
import '../components/spins.dart';
import 'package:maui/loca.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:ui' as ui show Image, instantiateImageCodec, Codec, FrameInfo;
import 'package:maui/components/unit_button.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:maui/components/gameaudio.dart';

class SpinWheel extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  GameConfig gameConfig;
  bool isRotated;
  final Color disableColor;
  SpinWheel(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.function,
      this.gameConfig,
      this.disableColor,
      this.isRotated = false})
      : super(key: key);
  @override
  _SpinWheelState createState() => new _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> with TickerProviderStateMixin {
  List<Color> _wheelColor = [
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFD1F2EB),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
  ];
  List<String> _circleData = [],
      _unitButtonData = [],
      _circleShuffledData = [],
      _unitButtonShuffledData = [];
  Map<String, String> _allData = new Map<String, String>();
  List<bool> _slice = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Animation shakeAnimate, noAnimation, animatoin;
  AnimationController controller, controller1;
  String _text = '', s1 = 'assets/dict/', s2 = '.png', _maxString;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  List<ui.Image> images = new List<ui.Image>();
  List<String> _imageData = [];
  Unit _unit;
  UnitMode _unitMode;
  double rotationPercent = 0.0,
      rotationPercent1 = 0.0,
      angleDiff,
      _angleOnDragStard,
      _angleOnDragEnd;
  bool test = true, doShake = true, _isLoading = true, _imageNotFound = true;
  var _angleDiffAntiCockWise = 0.0,
      onDragCordUpdated,
      onDragCordStarted,
      dragStart = 0.0,
      dragEnd = 0.0,
      dragEnd1 = 0.0,
      dragUpdate = 0.0,
      _angleDiff,
      _gameEndFlag = true;

  int _indexOfContainerData = 0,
      _dataSize,
      _countGameEnd = 0,
      _wmCount,
      _activeIndex;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
    controller1 =
        new AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller = new AnimationController(
        duration: Duration(milliseconds: 80), vsync: this);
    shakeAnimate = new Tween(begin: -8.0, end: 8.0).animate(controller);
    noAnimation = new Tween(begin: -0.0, end: 0.0).animate(controller);
    animatoin =
        new CurvedAnimation(parent: controller1, curve: Curves.easeInOut);
    controller1.addStatusListener((status) {});
    controller1.forward();
    if (widget.gameConfig.level < 4) {
      print("level <4");
      _dataSize = 6;
    } else if (widget.gameConfig.level < 6) {
      print("level <8");
      _dataSize = 6;
    } else {
      print("level <10");
      _dataSize = 6;
    }
    _initBoard();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void didUpdateWidget(SpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration && widget.iteration != 2) {
      _indexOfContainerData = 0;
      _countGameEnd = 0;
      dragEnd = 0.0;
      angleDiff = 0.0;
      _circleData.clear();
      _unitButtonData.clear();
      _circleShuffledData.clear();
      _unitButtonShuffledData.clear();
      images.clear();
      _imageData.clear();
      controller1.forward();
      _gameEndFlag = true;
      _initBoard();
      reset();
    }
  }

  void _initBoard() async {
    setState(() {
      _isLoading = true;
    });

    _allData = await fetchPairData(widget.gameConfig.gameCategoryId, _dataSize);

    print("mode question:: ${widget.gameConfig.questionUnitMode}");
    print("mode answer:: ${widget.gameConfig.answerUnitMode}");
    print("all data:: $_allData");
    print("data size:: $_dataSize");
    _allData.forEach((k, v) {
      _circleData.add(k);
      _unitButtonData.add(v);
    });

    _circleShuffledData = _circleData.sublist(0, _dataSize);
    _unitButtonShuffledData = _unitButtonData.sublist(0, _dataSize);
    _circleShuffledData.shuffle();
    _unitButtonShuffledData.shuffle();

    if (widget.gameConfig.answerUnitMode == UnitMode.image) {
      for (int i = 0; i < _dataSize; i++) {
        _unit =
            await new UnitRepo().getUnit(_circleShuffledData[i].toLowerCase());
        print("image length:: ${_unit.image?.length}");
        if ((_unit.image?.length ?? 0) == 0) {
          _unitMode = UnitMode.text;
          _imageNotFound = false;
          print("not found");
          break;
        } else {
          _imageData.add(_unit.image);
        }
      }
    }
    if (_imageNotFound && widget.gameConfig.answerUnitMode == UnitMode.image) {
      for (int i = 0; i < _dataSize; i++) {
        String _image = _imageData[i];
        load(_image).then((j) {
          images.add(j);
        });
      }
      _unitMode = UnitMode.image;
    } else {
      _maxString = _circleShuffledData[0];
      for (int i = 1; i < _dataSize; i++) {
        if (_maxString.length < _circleShuffledData[i].length) {
          _maxString = _circleShuffledData[i];
        }
      }
      _unitMode = UnitMode.text;
    }
    for (int i = 0; i < _dataSize; i++) {
      if (_circleShuffledData[i].length == _maxString.length) {
        _wmCount = 'w'.allMatches(_circleShuffledData[i].toLowerCase()).length;
        _wmCount = _wmCount >=
                'm'.allMatches(_circleShuffledData[i].toLowerCase()).length
            ? _wmCount
            : 'm'.allMatches(_circleShuffledData[i].toLowerCase()).length;

        if (_wmCount > 0) {
          _maxString = _circleShuffledData[i];
        }
      }
    }
    rotationPercent = 0.0;
    _text = _unitButtonShuffledData[0];

    _activeIndex = _unitButtonData.indexOf(_text);

    int index = _circleShuffledData.indexOf(_circleData[_activeIndex]);

    _slice[index] = true;
    setState(() {
      _isLoading = false;
    });
    print("unit mode after fatching data::$_unitMode");
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  void reset() {
    if (_dataSize == 2) {
    } else if (_dataSize == 4) {
      setState(() {
        _wheelColor[0] = Color(0XFFD1F2EB);
        _wheelColor[1] = Color(0XFFD1F2EB);
        _wheelColor[2] = Color(0XFFD1F2EB);
        _wheelColor[3] = Color(0XFFD1F2EB);

        List<CircularStackEntry> data = _generateChartData(_dataSize);
        _chartKey.currentState.updateData(data);
      });
    } else if (_dataSize == 6) {
      setState(() {
        _wheelColor[0] = Color(0XFFD1F2EB);
        _wheelColor[1] = Color(0XFFD1F2EB);
        _wheelColor[2] = Color(0XFFD1F2EB);
        _wheelColor[3] = Color(0XFFD1F2EB);
        _wheelColor[4] = Color(0XFFD1F2EB);
        _wheelColor[5] = Color(0XFFD1F2EB);

        List<CircularStackEntry> data = _generateChartData(_dataSize);
        _chartKey.currentState.updateData(data);
      });
    } else if (_dataSize == 8) {
      for (int i = 0; i < _dataSize; i++) {
        setState(() {
          _wheelColor[0] = Color(0XFFD1F2EB);
          _wheelColor[1] = Color(0XFFD1F2EB);
          _wheelColor[2] = Color(0XFFD1F2EB);
          _wheelColor[3] = Color(0XFFD1F2EB);
          _wheelColor[4] = Color(0XFFD1F2EB);
          _wheelColor[5] = Color(0XFFD1F2EB);
          _wheelColor[6] = Color(0XFFD1F2EB);
          _wheelColor[7] = Color(0XFFD1F2EB);
          List<CircularStackEntry> data = _generateChartData(_dataSize);
          _chartKey.currentState.updateData(data);
        });
      }
    } else if (_dataSize == 10) {
      setState(() {
        _wheelColor[0] = Color(0XFFD1F2EB);
        _wheelColor[1] = Color(0XFFD1F2EB);
        _wheelColor[2] = Color(0XFFD1F2EB);
        _wheelColor[3] = Color(0XFFD1F2EB);
        _wheelColor[4] = Color(0XFFD1F2EB);
        _wheelColor[5] = Color(0XFFD1F2EB);
        _wheelColor[6] = Color(0XFFD1F2EB);
        _wheelColor[7] = Color(0XFFD1F2EB);
        _wheelColor[8] = Color(0XFFD1F2EB);
        _wheelColor[9] = Color(0XFFD1F2EB);
        List<CircularStackEntry> data = _generateChartData(_dataSize);
        _chartKey.currentState.updateData(data);
      });
    }
  }

  _onDragStart(PolarCoord cord) {
    onDragCordStarted = cord;
    _angleOnDragStard = (cord.angle / (2 * pi) * 360);
    //startDragTime = currentTime;
    setState(() {
      rotationPercent = dragEnd;
    });
  }

  _onDragUpdate(PolarCoord dragCord) {
    onDragCordUpdated = dragCord;
    if (onDragCordStarted != null) {
      angleDiff = onDragCordStarted.angle - dragCord.angle;
      angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
      _angleDiffAntiCockWise = -dragCord.angle + onDragCordStarted.angle;

      _angleDiffAntiCockWise = _angleDiffAntiCockWise <= 0
          ? _angleDiffAntiCockWise
          : (_angleDiffAntiCockWise - (2 * pi));

      _angleDiff = angleDiff;

      setState(() {
        rotationPercent = angleDiff + dragEnd; //angleDiff + dragEnd;
      });
    }
    _angleOnDragEnd = (dragCord.angle / (2 * pi) * 360);
  }

  _onDragEnd() {
    dragEnd = rotationPercent;
    _angleDiff = (angleDiff / (2 * pi) * 360);
    if (_dataSize == 8)
      compareTheangle8();
    else if (_dataSize == 6)
      compareTheangle6();
    else if (_dataSize == 4)
      compareTheangle4();
    else if (_dataSize == 2) compareTheangle2();
  }
  // code optimizing
  void _comparisonOfAngle(int size, List<double> _lowerAngle,
      List<double> _uperAngle, List<bool> _sliceBool) {
    for (int j = 0; j < size; j++) {
      if (_angleDiff >= _lowerAngle[j] &&
          _angleDiff <= _uperAngle[j] &&
          _sliceBool[j] == true) {}
    }
  }

  // hard codes
  void compareTheangle8() {
    //0
    if (_angleDiff >= 2.0 && _angleDiff <= 43.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, .375);
    } //1
    else if (_angleDiff >= 47.0 && _angleDiff <= 88.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;

      _changeData(1, 1.125);
    }
    //2
    else if (_angleDiff >= 92.0 && _angleDiff <= 133.0 && _slice[2] == true) {
      print("Slice2::");

      _slice[2] = false;
      _changeData(2, 1.875);
    }
    //3
    else if (_angleDiff >= 137.0 && _angleDiff <= 178.0 && _slice[3] == true) {
      print("Slice3::");

      _slice[3] = false;
      _changeData(3, 2.75);
    }
    //4
    else if (_angleDiff >= 182.0 && _angleDiff <= 223.0 && _slice[4] == true) {
      print("Slice4::");

      _slice[4] = false;
      _changeData(4, 3.5);
    }
    //5
    else if (_angleDiff >= 227.0 && _angleDiff <= 268.0 && _slice[5] == true) {
      print("Slice5::");

      _slice[5] = false;
      _changeData(5, 4.25);
    }
    //6
    else if (_angleDiff >= 274.0 && _angleDiff <= 313.0 && _slice[6] == true) {
      print("Slice6::");

      _slice[6] = false;
      _changeData(6, 5.1);
    }
    //7
    else if (_angleDiff >= 317.0 && _angleDiff <= 358.0 && _slice[7] == true) {
      print("Slice7::");
      _slice[7] = false;
      _changeData(7, 5.9);
    } else {
      if (_angleDiff >= 1.0) _shake();
    }
  }

  void compareTheangle6() {
    //0
    if (_angleDiff >= 2.0 && _angleDiff <= 58.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, pi / 6);
    } //1
    else if (_angleDiff >= 62.0 && _angleDiff <= 118.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;
      _changeData(1, pi / 2);
    }
    //2
    else if (_angleDiff >= 122.0 && _angleDiff <= 178.0 && _slice[2] == true) {
      print("Slice2::");

      _slice[2] = false;
      _changeData(2, 5 * pi / 6);
    }
    //3
    else if (_angleDiff >= 182.0 && _angleDiff <= 238.0 && _slice[3] == true) {
      print("Slice3::");

      _slice[3] = false;
      _changeData(3, 7 * pi / 6);
    }
    //4
    else if (_angleDiff >= 242.0 && _angleDiff <= 298.0 && _slice[4] == true) {
      print("Slice4::");

      _slice[4] = false;
      _changeData(4, 3 * pi / 2);
    }
    //5
    else if (_angleDiff >= 302.0 && _angleDiff <= 358.0 && _slice[5] == true) {
      print("Slice5::");

      _slice[5] = false;
      _changeData(5, (11 * pi) / 6);
    } else {
      if (_angleDiff >= 1.0) _shake();
    }
  }

  void compareTheangle4() {
    //0
    if (_angleDiff >= 2.0 && _angleDiff <= 88.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, pi / 4);
    } //1
    else if (_angleDiff >= 92.0 && _angleDiff <= 178.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;
      _changeData(1, (pi / 4 + pi / 2));
    }
    //2
    else if (_angleDiff >= 182.0 && _angleDiff <= 268.0 && _slice[2] == true) {
      print("Slice2::");

      _slice[2] = false;
      _changeData(2, (pi / 4 + (pi / 2) * 2));
    }
    //3
    else if (_angleDiff >= 272.0 && _angleDiff <= 358.0 && _slice[3] == true) {
      print("Slice3::");

      _slice[3] = false;
      _changeData(3, (pi / 4 + (pi / 2) * 3));
    } else {
      if (_angleDiff >= 1.0) _shake();
    }
  }

  void compareTheangle2() {
    //0
    if (_angleDiff >= 5.0 && _angleDiff <= 175.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, pi / 2);
    } //1
    else if (_angleDiff >= 180.0 && _angleDiff <= 360.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;

      _changeData(1, pi / 2 + pi);
    } else {
      if (_angleDiff >= 1.0) _shake();
    }
  }

  void _shake() {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      } else if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });
    controller.forward();
    doShake = true;
    new Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        controller.stop();
      });
      if (_gameEndFlag) {
        widget.onScore(-1);
      }
    });
  }

  void _changeData(int indx, double angle) {
    new Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _wheelColor[indx] = new Color(0XFF8FBC8F);
        List<CircularStackEntry> data = _generateChartData(_dataSize);
        _chartKey.currentState.updateData(data);
        rotationPercent = angle;
      });
    });
    new Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        _text = _unitButtonShuffledData[++_indexOfContainerData];
        _activeIndex = _unitButtonData.indexOf(_text);
        //print("index of samll circle: ${_circleData[_activeIndex]}");
        int index = _circleShuffledData.indexOf(_circleData[_activeIndex]);
        _slice[index] = true;
        _chartKey.currentState.updateData(data);
      });
    });
    // print("slice no::$_index");
    if (_countGameEnd == _dataSize - 1) {
      new Future.delayed(Duration(seconds: 2), () {
        widget.onEnd();
      });
      _gameEndFlag = false;
    }
    _countGameEnd++;
    //print("game count $_countGameEnd");
    if (_countGameEnd != _dataSize - 1) widget.onScore(4);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CircularStackEntry> data, data1;
  List<CircularStackEntry> _generateChartData(int size) {
    // not working
    // for (int i = 0; i < 8; i++) {
    //   data[i] = new CircularStackEntry(
    //     [
    //       new CircularSegmentEntry(500.0, _wheelColor[i], rankKey: 'a'),
    //     ],
    //     rankKey: 'Quarterly Profits',
    //   );
    // }
    if (size == 10) {
      data = [
        new CircularStackEntry(<CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, _wheelColor[0], rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, _wheelColor[1], rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, _wheelColor[2], rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, _wheelColor[3], rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, _wheelColor[4], rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, _wheelColor[5], rankKey: 'Q6'),
          new CircularSegmentEntry(500.0, _wheelColor[6], rankKey: 'Q7'),
          new CircularSegmentEntry(500.0, _wheelColor[7], rankKey: 'Q8'),
          new CircularSegmentEntry(500.0, _wheelColor[8], rankKey: 'Q9'),
          new CircularSegmentEntry(500.0, _wheelColor[9], rankKey: 'Q10'),
        ], rankKey: 'Spin_Wheel'),
      ];
    } else if (size == 8) {
      data = [
        new CircularStackEntry(<CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, _wheelColor[0], rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, _wheelColor[1], rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, _wheelColor[2], rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, _wheelColor[3], rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, _wheelColor[4], rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, _wheelColor[5], rankKey: 'Q6'),
          new CircularSegmentEntry(500.0, _wheelColor[6], rankKey: 'Q7'),
          new CircularSegmentEntry(500.0, _wheelColor[7], rankKey: 'Q8'),
        ], rankKey: 'Spin_Wheel'),
      ];
    } else if (size == 6) {
      data = [
        new CircularStackEntry(<CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, _wheelColor[0], rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, _wheelColor[1], rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, _wheelColor[2], rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, _wheelColor[3], rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, _wheelColor[4], rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, _wheelColor[5], rankKey: 'Q6'),
        ], rankKey: 'Spin_Wheel'),
      ];
    } else if (size == 4) {
      data = [
        new CircularStackEntry(<CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, _wheelColor[0], rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, _wheelColor[1], rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, _wheelColor[2], rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, _wheelColor[3], rankKey: 'Q4'),
        ], rankKey: 'Spin_Wheel'),
      ];
    } else {
      data = [
        new CircularStackEntry(<CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, _wheelColor[0], rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, _wheelColor[1], rankKey: 'Q2'),
        ], rankKey: 'Spin_Wheel'),
      ];
    }
    return data;
  }

  List<CircularStackEntry> _generateChartData1(double value) {
    data1 = [
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, Colors.black, rankKey: 'Q1'),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];

    return data1;
  }

  @override
  Widget build(BuildContext context) {
    double _sizeOfWheel;
    Size size2 = MediaQuery.of(context).size;
    // print("size of the screen:: $size2");
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    Size size1 = MediaQuery.of(context).size;
    if (isLandscape) {}
    // final Orientation orientation = MediaQuery.of(context).orientation;
    //final bool isLanscape = orientation == Orientation.landscape;
    size1 = new Size(size1.height * .6, size1.height * .6);
    size2 = new Size(size2.height * .6, size2.height * .6);

    var maxChars = (_unitButtonData != null
        ? _unitButtonData.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);

    return new LayoutBuilder(builder: (context, constraints) {
      Size _size;
      if (constraints.maxHeight > constraints.maxWidth) {
        _sizeOfWheel = constraints.maxWidth;
        _size = new Size(_sizeOfWheel + .20 * _sizeOfWheel,
            _sizeOfWheel + _sizeOfWheel * .20);
      } else {
        _sizeOfWheel = constraints.maxHeight;
        _size = new Size(
            _sizeOfWheel - _sizeOfWheel * .2, _sizeOfWheel - _sizeOfWheel * .2);
      }
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth =
          (constraints.maxWidth - hPadding * 2) / 2.1; //- middle_spacing;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 2;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight - 10);
      // AppState state = AppStateContainer.of(context).state;
      if (_isLoading) {
        return Container(
            child: Center(
                child: Text(
          Loca.of(context).loading,
          style: TextStyle(
            color: Colors.green,
            fontSize: 24.0,
          ),
        )));
      }
      return new Column(
        children: <Widget>[
          new Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: new Color(0xFFA52A2A),
                child: Stack(
                  children: <Widget>[
                    // new Text(''),
                    Center(
                      child: Shake(
                        animation: shakeAnimate,
                        child: new UnitButton(
                          text: _text,
                          unitMode: widget.gameConfig.questionUnitMode,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          // new Expanded(flex: 1, child: new Text('')
          //),
          new Expanded(
            flex: 7,
            child: new Stack(
              children: <Widget>[
                new Center(
                  child: new ScaleTransition(
                    scale: animatoin,
                    child: new AnimatedCircularChart(
                      size: size2 * .98,
                      duration: Duration(milliseconds: 1),
                      initialChartData: _generateChartData1(100.0),
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
                    ),
                  ),
                ),
                new Center(
                  child: new Transform(
                    // transformHitTests: ,
                    origin: new Offset(0.0, 0.0),
                    transform: new Matrix4.rotationZ(-rotationPercent),
                    alignment: Alignment.center,
                    child: new ScaleTransition(
                      scale: animatoin,
                      child: new AnimatedCircularChart(
                          duration: Duration(milliseconds: 1),
                          // percentageValues: false,
                          key: _chartKey,
                          edgeStyle: SegmentEdgeStyle.flat,
                          size: size1,
                          initialChartData: _generateChartData(_dataSize),
                          chartType: CircularChartType.Pie),
                    ),
                  ),
                ),
                new Center(
                    child: new ScaleTransition(
                  scale: animatoin,
                  child: new Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      //color: Colors.red
                    ),
                    height: size1.width * .8,
                    width: size1.width * .8,
                    child: new RadialDragGestureDetector(
                        onRadialDragStart: _onDragStart,
                        onRadialDragUpdate: _onDragUpdate,
                        onRadialDragEnd: _onDragEnd,
                        child: new Container(
                            width: size1.width,
                            height: size1.width,
                            child: new CustomPaint(
                              painter: (_unitMode != UnitMode.image)
                                  ? TextPainters(
                                      wmCount: _wmCount,
                                      maxChar: maxChars,
                                      dataSize: _dataSize,
                                      rotation: rotationPercent,
                                      data: _circleShuffledData,
                                      maxString: _maxString,
                                    )
                                  : ImagePainter(
                                      dataSize: _dataSize,
                                      images: images,
                                      rotation: rotationPercent),
                            ))),
                  ),
                )),
                new ScaleTransition(
                  scale: animatoin,
                  child: new Center(
                    child: new Center(
                      child: new CustomPaint(
                        painter: ArrowPainter(sizeArrow: size2),
                      ),
                    ),
                  ),
                ),
                new ScaleTransition(
                  scale: animatoin,
                  child: Center(
                    child: new Container(
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: new LinearGradient(
                              colors: [Colors.green, Color(0XFFD1F2EB)])),
                      height: size1.width * .15,
                      width: size1.width * .15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
