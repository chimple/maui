import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/state/button_state_container.dart';

class FindSizeGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  FindSizeGame(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);
  @override
  _FindSizeGameState createState() => _FindSizeGameState();
}

class _FindSizeGameState extends State<FindSizeGame>
    with TickerProviderStateMixin {
  String dropBoxBg = "assets/box.jpg";
  List<String> _dropData = new List();
  List<String> _images = [
    "assets/apple.png",
    "assets/Colors.png",
    "assets/Boy.png"
  ];

  int code;
  bool _isLoading = true;

  List<bool> _isDone = new List();
  var data, flag1, correct, keys;

  initState() {
    super.initState();
    initFn();
  }

  initFn() {
    setState(() => _isLoading = true);
    // data = await fetchWordData(
    //   widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
    int temp = 0;
    while (temp < _images.length) {
      _isDone.add(false);
      _dropData.add(null);
      temp++;
    }

    var rng = new Random();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }

    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String image, bool isDone) {
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      img: image,
      isDone: isDone,
      code: code,
      dropBoxBg: dropBoxBg,
      onDrag: () {
        setState(() {});
      },
      isRotated: widget.isRotated,
      onAccepted: (data) {
        flag1 = 0;
        String dragData = data;
        int dindex = int.parse(dragData.substring(0, 3));
        int dcode = int.parse(dragData.substring(4));
        if (code == dcode) {
          int findex = dindex - 100;
          print('gg $findex ${_isDone[findex]} $index');
          if (index == findex) {
            //right
            setState(() {
              _isDone[findex] = true;
              _dropData[index] = _images[index];
            });
          } else if (_isDone[findex] == false) {
            // wrong
          }
        }
        // keys: keys++
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new LayoutBuilder(builder: (context, constraints) {
      var rwidth, rheight;
      rwidth = constraints.maxWidth;
      rheight = constraints.maxHeight;
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      final isPortait = rwidth < rheight * 1.2;

      double maxWidth = (constraints.maxWidth - hPadding * 2) /
          (isPortait ? _images.length : _images.length * 2 + 1);
      double maxHeight =
          (constraints.maxHeight - vPadding * 2) / (isPortait ? 2 : 1);
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 3);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth - 30, maxHeight - 30);

      int j = 0;
      int inc = 0;
      int k = 100;
      return new Container(
          color: Colors.black87,
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          child: rwidth < rheight * 1.2
              ? new Column(
                  // portrait mode
                  children: <Widget>[
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '  Find the size .',
                                style: TextStyle(color: Colors.yellow),
                                textScaleFactor: 2.2,
                              ))),
                      Expanded(
                          flex: 2,
                          child: new Container(
                              // color: Color(0xFFD32F2F),
                              child: ResponsiveGridView(
                                  rows: 1,
                                  cols: _dropData.length,
                                  children: _dropData
                                      .map((e) => Padding(
                                          padding:
                                              EdgeInsets.all(buttonPadding),
                                          child: _buildItem(inc++, e, false)))
                                      .toList(growable: false)))),
                      new Padding(padding: new EdgeInsets.all(buttonPadding)),
                      Expanded(
                          flex: 2,
                          child: Container(
                              // color: Colors.white,
                              child: new ResponsiveGridView(
                                  rows: 1,
                                  cols: _images.length,
                                  children: _images
                                      .map((e) => Padding(
                                          padding:
                                              EdgeInsets.all(buttonPadding),
                                          child:
                                              _buildItem(k++, e, _isDone[j++])))
                                      .toList(growable: false)))),
                    ])
              : new Column(
                  children: [
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '  Find the size .',
                              style: TextStyle(color: Colors.yellow),
                              textScaleFactor: 2.2,
                            ))),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          new Expanded(
                              child: new Container(
                                  // color: Colors.white,
                                  child: new ResponsiveGridView(
                                      rows: 1,
                                      cols: _dropData.length,
                                      children: _dropData
                                          .map((e) => Padding(
                                              padding:
                                                  EdgeInsets.all(buttonPadding),
                                              child:
                                                  _buildItem(inc++, e, false)))
                                          .toList(growable: false)))),
                          new Expanded(
                              child: new Container(
                                  // color: Color(0xFFD32F2F),
                                  child: new ResponsiveGridView(
                                      rows: 1,
                                      cols: _images.length,
                                      children: _images
                                          .map((e) => Padding(
                                              padding:
                                                  EdgeInsets.all(buttonPadding),
                                              child: _buildItem(
                                                  k++, e, _isDone[j++])))
                                          .toList(growable: false))))
                        ],
                      ),
                    )
                  ],
                  // landsape mode
                ));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.dropBoxBg,
      this.onAccepted,
      this.code,
      this.isRotated,
      this.img,
      this.onDrag,
      this.isDone})
      : super(key: key);
  final index;
  final String dropBoxBg;
  final int code;
  final bool isRotated;
  final String img;
  final DragTargetAccept onAccepted;
  final bool isDone;
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;

    if (widget.index < 100 && buttonConfig != null) {
      return new Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
        ),
        child: new DragTarget(
          onAccept: (String data) => widget.onAccepted(data),
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return new Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Image.asset(
                    widget.dropBoxBg,
                    width: buttonConfig.width + 30,
                    height: buttonConfig.height + 30,
                  ),
                ),
                widget.img == null
                    ? Container(
                        width: buttonConfig.width,
                        height: buttonConfig.height,
                      )
                    : new UnitButton(
                        key: new Key('A${widget.index}'),
                        text: '',
                        showHelp: false,
                        unitMode: UnitMode.image,
                        bgImage: widget.img,
                      ),
              ],
            );
          },
        ),
      );
    } else if (widget.index >= 100 &&
        widget.img != null &&
        buttonConfig != null) {
      if (widget.isDone)
        return Container(
            height: buttonConfig.height,
            width: buttonConfig.width,
            color: Colors.transparent);
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: new Draggable(
          onDragStarted: () {
            if (ButtonStateContainer.of(context).startUsingButton()) {
              widget.onDrag();
            }
          },
          onDragCompleted: () =>
              ButtonStateContainer.of(context).endUsingButton(),
          onDraggableCanceled: (_, __) =>
              ButtonStateContainer.of(context).endUsingButton(),
          maxSimultaneousDrags:
              (!ButtonStateContainer.of(context).isButtonBeingUsed) ? 1 : 0,
          data: '${widget.index}' + '_' + '${widget.code}',
          child: new UnitButton(
            key: new Key('${widget.index}'),
            text: '',
            showHelp: false,
            unitMode: UnitMode.image,
            bgImage: widget.img,
          ),
          feedback: UnitButton(
            key: new Key('F' + '${widget.index}'),
            text: '',
            bgImage: widget.img,
            unitMode: UnitMode.image,
            maxHeight: buttonConfig.height,
            maxWidth: buttonConfig.width,
            fontSize: buttonConfig.fontSize,
          ),
        ),
      );
    } else
      return Container();
  }
}
