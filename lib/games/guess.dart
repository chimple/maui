import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import '../components/shaker.dart';
import '../components/Sticker.dart';

Map _decoded;

class GuessIt extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  GuessIt(
      {Key key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false})
      : super(key: key);

  @override
  _GuessItState createState() => new _GuessItState();
}

class _GuessItState extends State<GuessIt> with TickerProviderStateMixin {
  final TextEditingController _controller = new TextEditingController();
  String _guess = '';
  int _flag = 0;
  double x, y ;
  String paste='';

  AnimationController controller;
  Animation<double> animation, noanimation;

  // final FocusNode _focusnode = new FocusNode();

  void toAnimateFunction() {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      print(animation.value);
    });
    controller.forward();
  }

  Future<String> _loadGameAsset() async {
    return await rootBundle.loadString("assets/imageCoordinatesInfo.json");
  }

  Future _loadGameInfo() async {
    String jsonGameInfo = await _loadGameAsset();
    print(jsonGameInfo);
    this.setState(() {
      _decoded = json.decode(jsonGameInfo);
    });
    print(_decoded["id"]);
    print(_decoded["height"]);
    print(_decoded["width"]);
    print(_decoded["parts"][0]["name"]);
    // _parserJsonForGame(jsonGameInfo);
  }

  void _validate() {
    if (_guess == _decoded["parts"][0]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState((){
        x = 50.0;
        y = 100.0;
        paste = _guess;
      });
    } else if (_guess == _decoded["parts"][1]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState((){
        x = 250.0;
        y = 100.0;
        paste = _guess;
      });
    } else if (_guess == _decoded["parts"][2]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState((){
        x = 150.0;
        y = 100.0;
        paste = _guess;
      });
    } else if (_guess == _decoded["parts"][3]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState((){
        x = 200.0;
        y = 100.0;
        paste = _guess;
      });
    } else {
      this.setState(() {
        _flag = 1;
        toAnimateFunction();
        new Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _flag = 0;
          });
          print(animation.value);
          print(noanimation.value);
          _controller.text = '';
          controller.stop();
        });
      });
      paste = '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation = new Tween(begin: -3.0, end: 3.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(controller);
    this._loadGameInfo();
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.dispose();
    // _focusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // FocusScope.of(context).requestFocus(_focusnode);
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    return new Stack(
      children: <Widget>[
        new Scaffold(
          // backgroundColor: Colors.red[100],
          body: new Column(
            children: <Widget>[
              new Expanded(
                flex: 2,
                child: new Image(
                  image: AssetImage('assets/' + _decoded["id"]),
                  fit: BoxFit.contain,
                ),
              ),
              new Expanded(
                flex: 1,
                child: new Container(
                  decoration: new BoxDecoration(
                    border: new Border(
                        bottom: new BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        ),
                        top: new BorderSide(
                          width: 0.5,
                          color: Colors.black,
                        )),
                  ),
                  child: new Shake(
                    animation: (_flag == 0) ? noanimation : animation,
                    child: new Center(
                      child: new TextField(
                        // focusNode: _focusnode,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        controller: _controller,
                        obscureText: false,
                        style:new TextStyle(color: Colors.black, fontSize: 20.0),
                        decoration: new InputDecoration(
                          // hintText: "name what you see and press check",
                          // hintStyle: new TextStyle(color: Colors.blueGrey[200]),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: new BorderSide(style: BorderStyle.solid, width: 10.0, color: Colors.red )
                          ),
                        ),
                        onChanged: (String str) {
                          _guess = str.toLowerCase();
                          print(_guess);
                          // setState((){
                          //   _guess = str;
                          // });
                          // _controller.text = '';
                        },
                      ),
                    ),
                  ),
                ),
              ),
              new Expanded(
                flex: 1,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      key: new Key("checking"),
                      child: new Text("Check"),
                      onPressed: () => _validate(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        new Positioned(
          left: x,
          top: y,
          child: new Text(
            paste,
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
          
        )
      ],
    );
  }
}
