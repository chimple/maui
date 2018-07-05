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
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:ui' as ui show Image, instantiateImageCodec, Codec, FrameInfo;
import 'package:maui/components/unit_button.dart';
import 'dart:ui' as ui;
import 'dart:async';

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
      _smallCircleData = [],
      _shuffleCircleData1 = [],
      _shuffleCircleData2 = [];

  Map<String, String> _data = {
    'CHEEK': 'CHEEK',
    'cheese': 'cheese',
    'cheetah': 'cheetah',
    'cherry': 'cherry',
    'CHESS': 'CHESS',
    'chicken': 'chicken',
    'chico': 'chico',
    'CHIHUAHUA': 'CHIHUAHUA',
  };
  Map<String, String> allData = new Map<String, String>();
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

  double rotationPercent = 0.0, rotationPercent1 = 0.0, angleDiff;

  bool _isLoading = true;
  var _angleDiffAntiCockWise = 0.0,
      onDragCordUpdated,
      onDragCordStarted,
      dragStart = 0.0,
      dragEnd = 0.0,
      dragEnd1 = 0.0,
      dragUpdate = 0.0,
      _angleDiff,
      gameEndFlag = true;
  UnitMode _unitMode;
  int _indexOfContainerData = 0, dataSize, _countGameEnd = 0;
  String _text = '', s1 = 'assets/dict/', s2 = '.png';
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  List<ui.Image> images = new List<ui.Image>();
  @override
  void initState() {
    super.initState();
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
      dataSize = 4;
    } else if (widget.gameConfig.level < 6) {
      print("level <8");
      dataSize = 6;
    } else {
      print("level <10");
      dataSize = 8;
    }
    _initBoard();
  }

  @override
  void didUpdateWidget(SpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _indexOfContainerData = 0;
      _countGameEnd = 0;

      dragEnd = 0.0;
      angleDiff = 0.0;
      _circleData.clear();
      _smallCircleData.clear();
      _shuffleCircleData1.clear();
      _shuffleCircleData2.clear();
      images.clear();
      controller1.forward();
      gameEndFlag = true;
      _initBoard();
      reset();
    }
  }

  bool _imageFound = true;
  int _activeIndex;
  String _maxString = '';
  void _initBoard() async {
    setState(() {
      _isLoading = true;
    });

    allData = await fetchPairData(widget.gameConfig.gameCategoryId, dataSize);

    print("mode question:: ${widget.gameConfig.questionUnitMode}");
    print("mode answer:: ${widget.gameConfig.answerUnitMode}");
    allData.forEach((k, v) {
      _circleData.add(k);
      _smallCircleData.add(v);
    });

    _shuffleCircleData1 = _circleData.sublist(0, dataSize);
    _shuffleCircleData2 = _smallCircleData.sublist(0, dataSize);
    _shuffleCircleData1.shuffle();
    _shuffleCircleData2.shuffle();

    if (widget.gameConfig.answerUnitMode == UnitMode.image) {
      for (int i = 0; i < dataSize; i++) {
        _unit =
            await new UnitRepo().getUnit(_shuffleCircleData1[i].toLowerCase());
        // print(_unit);
        if ((widget.gameConfig.answerUnitMode == UnitMode.audio &&
                (_unit.sound?.length ?? 0) == 0) ||
            (widget.gameConfig.answerUnitMode == UnitMode.image &&
                (_unit.image?.length ?? 0) == 0)) {
          _unitMode = UnitMode.text;
          _imageFound = false;
          break;
        }
      }
    }
    if (_imageFound && widget.gameConfig.answerUnitMode == UnitMode.image) {
      for (int i = 0; i < dataSize; i++) {
        String _image = s1 + _shuffleCircleData1[i].toLowerCase() + s2;
        // print("image url:: $_image");
        load(_image).then((j) {
          images.add(j);
        });
      }
      _unitMode = UnitMode.image;
    }

    rotationPercent = 0.0;
    _text = _shuffleCircleData2[0];

    _activeIndex = _smallCircleData.indexOf(_text);

    int index = _shuffleCircleData1.indexOf(_circleData[_activeIndex]);

    _slice[index] = true;
    _maxString = _shuffleCircleData1[0];
    for (int i = 1; i < dataSize; i++) {
      if (_maxString.length < _shuffleCircleData1[i].length) {
        _maxString = _shuffleCircleData1[i];
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<ui.Image> load(String asset) async {
    //print("print asset value:: $asset");
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  void reset() {
    if (dataSize == 2) {
    } else if (dataSize == 4) {
      setState(() {
        _wheelColor[0] = Color(0XFFD1F2EB);
        _wheelColor[1] = Color(0XFFD1F2EB);
        _wheelColor[2] = Color(0XFFD1F2EB);
        _wheelColor[3] = Color(0XFFD1F2EB);

        List<CircularStackEntry> data = _generateChartData(dataSize);
        _chartKey.currentState.updateData(data);
      });
    } else if (dataSize == 6) {
      setState(() {
        _wheelColor[0] = Color(0XFFD1F2EB);
        _wheelColor[1] = Color(0XFFD1F2EB);
        _wheelColor[2] = Color(0XFFD1F2EB);
        _wheelColor[3] = Color(0XFFD1F2EB);
        _wheelColor[4] = Color(0XFFD1F2EB);
        _wheelColor[5] = Color(0XFFD1F2EB);

        List<CircularStackEntry> data = _generateChartData(dataSize);
        _chartKey.currentState.updateData(data);
      });
    } else if (dataSize == 8) {
      for (int i = 0; i < dataSize; i++) {
        setState(() {
          _wheelColor[0] = Color(0XFFD1F2EB);
          _wheelColor[1] = Color(0XFFD1F2EB);
          _wheelColor[2] = Color(0XFFD1F2EB);
          _wheelColor[3] = Color(0XFFD1F2EB);
          _wheelColor[4] = Color(0XFFD1F2EB);
          _wheelColor[5] = Color(0XFFD1F2EB);
          _wheelColor[6] = Color(0XFFD1F2EB);
          _wheelColor[7] = Color(0XFFD1F2EB);
          List<CircularStackEntry> data = _generateChartData(dataSize);
          _chartKey.currentState.updateData(data);
        });
      }
    } else if (dataSize == 10) {
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
        List<CircularStackEntry> data = _generateChartData(dataSize);
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

  double _angleOnDragStard, _angleOnDragEnd;
  _onDragEnd() {
    dragEnd = rotationPercent;
    _angleDiff = (angleDiff / (2 * pi) * 360);
    print("Drag Start here:: ${_angleOnDragStard}");
    print("Drag End here:: ${_angleOnDragEnd}");
    print("agnle did:: $_angleDiff");
    if (dataSize == 8)
      compareTheangle8();
    else if (dataSize == 6)
      compareTheangle6();
    else if (dataSize == 4)
      compareTheangle4();
    else if (dataSize == 2) compareTheangle2();
  }

  void compareTheangle8() {
    //0
    if (_angleDiff >= 5.0 && _angleDiff <= 45.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, .375);
    } //1
    else if (_angleDiff >= 50.0 && _angleDiff <= 90.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;

      _changeData(1, 1.125);
    }
    //2
    else if (_angleDiff >= 95.0 && _angleDiff <= 135.0 && _slice[2] == true) {
      print("Slice2::");

      _slice[2] = false;
      _changeData(2, 1.875);
    }
    //3
    else if (_angleDiff >= 140.0 && _angleDiff <= 185.0 && _slice[3] == true) {
      print("Slice3::");

      _slice[3] = false;
      _changeData(3, 2.75);
    }
    //4
    else if (_angleDiff >= 190.0 && _angleDiff <= 230.0 && _slice[4] == true) {
      print("Slice4::");

      _slice[4] = false;
      _changeData(4, 3.5);
    }
    //5
    else if (_angleDiff >= 235.0 && _angleDiff <= 275.0 && _slice[5] == true) {
      print("Slice5::");

      _slice[5] = false;
      _changeData(5, 4.25);
    }
    //6
    else if (_angleDiff >= 280.0 && _angleDiff <= 320.0 && _slice[6] == true) {
      print("Slice6::");

      _slice[6] = false;
      _changeData(6, 5.1);
    }
    //7
    else if (_angleDiff >= 320.0 && _angleDiff <= 365.0 && _slice[7] == true) {
      print("Slice7::");
      _slice[7] = false;
      _changeData(7, 5.9);
    } else {
      _shake();
    }
  }

  void compareTheangle6() {
    //0
    if (_angleDiff >= 5.0 && _angleDiff <= 60.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, pi / 6);
    } //1
    else if (_angleDiff >= 65.0 && _angleDiff <= 120.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;
      _changeData(1, pi / 2);
    }
    //2
    else if (_angleDiff >= 125.0 && _angleDiff <= 180.0 && _slice[2] == true) {
      print("Slice2::");

      _slice[2] = false;
      _changeData(2, 5 * pi / 6);
    }
    //3
    else if (_angleDiff >= 185.0 && _angleDiff <= 240.0 && _slice[3] == true) {
      print("Slice3::");

      _slice[3] = false;
      _changeData(3, 7 * pi / 6);
    }
    //4
    else if (_angleDiff >= 245.0 && _angleDiff <= 310.0 && _slice[4] == true) {
      print("Slice4::");

      _slice[4] = false;
      _changeData(4, 3 * pi / 2);
    }
    //5
    else if (_angleDiff >= 315.0 && _angleDiff <= 360.0 && _slice[5] == true) {
      print("Slice5::");

      _slice[5] = false;
      _changeData(5, (11 * pi) / 6);
    } else {
      _shake();
    }
  }

  void compareTheangle4() {
    //0
    if (_angleDiff >= 5.0 && _angleDiff <= 90.0 && _slice[0] == true) {
      print("Slice0::");
      _slice[0] = false;
      _changeData(0, pi / 4);
    } //1
    else if (_angleDiff >= 95.0 && _angleDiff <= 180.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = false;
      _changeData(1, (pi / 4 + pi / 2));
    }
    //2
    else if (_angleDiff >= 185.0 && _angleDiff <= 270.0 && _slice[2] == true) {
      print("Slice2::");

      _slice[2] = false;
      _changeData(2, (pi / 4 + (pi / 2) * 2));
    }
    //3
    else if (_angleDiff >= 275.0 && _angleDiff <= 360.0 && _slice[3] == true) {
      print("Slice3::");

      _slice[3] = false;
      _changeData(3, (pi / 4 + (pi / 2) * 3));
    } else {
      _shake();
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
      _shake();
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
        //doShake = false;
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        controller.stop();
      });
      if (gameEndFlag) widget.onScore(-1);
    });
  }

  void _changeData(int indx, double angle) {
    new Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _wheelColor[indx] = new Color(0XFF8FBC8F);
        List<CircularStackEntry> data = _generateChartData(dataSize);
        _chartKey.currentState.updateData(data);
        rotationPercent = angle;
      });
    });
    new Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        _text = _shuffleCircleData2[++_indexOfContainerData];
        _activeIndex = _smallCircleData.indexOf(_text);
        //print("index of samll circle: ${_circleData[_activeIndex]}");
        int index = _shuffleCircleData1.indexOf(_circleData[_activeIndex]);
        _slice[index] = true;
        _chartKey.currentState.updateData(data);
      });
    });
    // print("slice no::$_index");
    if (_countGameEnd == dataSize - 1) {
      new Future.delayed(Duration(seconds: 2), () {
        widget.onEnd();
      });
      gameEndFlag = false;
    }
    _countGameEnd++;
    //print("game count $_countGameEnd");
    widget.onScore(4);
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

  bool doShake = true;
  bool test = true;
  List<String> mode = ['image', 'text'];
  Unit _unit;
  @override
  Widget build(BuildContext context) {
    double _sizeOfWheel;
    Size size2 = MediaQuery.of(context).size;
    // print("size of the screen:: $size2");

    Size size1 = MediaQuery.of(context).size;
    // final Orientation orientation = MediaQuery.of(context).orientation;
    //final bool isLanscape = orientation == Orientation.landscape;
    size1 = new Size(size1.height * .6, size1.height * .6);
    size2 = new Size(size2.height * .6, size2.height * .6);

    var maxChars = (_smallCircleData != null
        ? _smallCircleData.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);
    return new LayoutBuilder(builder: (context, constraints) {
      // final bool isPortrait = orientation == Orientation.portrait;
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
          (constraints.maxWidth - hPadding * 2) / 2.4; //- middle_spacing;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / 1;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight - 10);
      // AppState state = AppStateContainer.of(context).state;
      if (_isLoading) {
        return Container(
          height: 40.0,
          width: 40.0,
          child: new CircularProgressIndicator(
            strokeWidth: 2.0,
            backgroundColor: Colors.blue,
          ),
        );
      }
      return new Column(
        //direction: Axis.vertical,
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
            flex: 6,
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
                          initialChartData: _generateChartData(dataSize),
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
                                      maxChar: maxChars,
                                      noOfSlice: dataSize,
                                      rotation: rotationPercent,
                                      data: _shuffleCircleData1,
                                      maxString: _maxString,
                                    )
                                  : ImagePainter(
                                      noOfSlice: dataSize,
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
                          //color: Colors.white,
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
          // new Expanded(
          //   flex: 1,
          //   child: new Text(''),
          // ),
        ],
      );
    });
  }
}
