import 'package:flutter/material.dart';
import 'package:maui/screens/tab_home.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';
import 'card_list.dart';
import 'package:maui/db/entity/quiz.dart';

class QuizScrollerPager extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  Widget hud;
  String question;
  List<String> answer;
  List<String> choices;
  String image;
  final QuizType relation;

  QuizScrollerPager(
      {Key key,
      this.input,
      this.question,
      this.answer,
      this.choices,
      this.image,
      this.onEnd,
      this.hud,
      this.relation})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new QuizScrollerPagerState();
  }
}

class QuizScrollerPagerState extends State<QuizScrollerPager>
    with SingleTickerProviderStateMixin {
  bool showans = false;
  var top = 0.0;
  int playTime = 10000;
  var expheight;
  bool displayIcon = false;
  var jsonData;

  bool showBottomBar = true;
  TabController tabController;
  final _scrollController = TrackingScrollController();
  // AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    print(
        "Data received by QuizScrollerPager from QuizPager - ${widget.question}.....${widget.answer}......${widget.choices}.....${widget.image}");

    print("hello this should come first...");
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  _gettingOnEndData(var onEndData, bool displayStatus) {
    print("Test Function CallBack received $onEndData......::$displayStatus");
    setState(() {
      jsonData = onEndData;
      displayIcon = displayStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print("thius..... is....expandheight is.....$expheight");
    print("Wiget relation type is......::${widget.relation}");

    print("hello this what i am trying to send to that....::${widget.input}");
    var size = media.size;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          bottomNavigationBar: Container(
            height: showBottomBar ? size.height * 0.1 : 0.0,
            color: Colors.amber[300],
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      _onWillPop();
                    },

                    //   => Navigator.of(context).push(
                    //     MaterialPageRoute<void>(builder: (BuildContext context) {
                    //   return TabHome();
                    // })),
                    child: new Tab(
                      child: new Icon(
                        Icons.arrow_back,
                        size: 70.0,
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: size.height * 0.1 * 0.8,
                //   child: new Tab(
                //     child: widget.hud,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Tab(
                    child: GestureDetector(
                      onTap: displayIcon == true
                          ? () {
                              setState(() {
                                widget.onEnd(jsonData);
                                displayIcon = false;
                              });
                            }
                          : null,
                      child: new Icon(
                        Icons.arrow_forward,
                        color: displayIcon == true ? Colors.black : Colors.grey,
                        size: 70.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: new FutureBuilder<ui.Image>(
            future: _getImage(),
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.hasData) {
                print("hello this changing or not");

                ui.Image image = snapshot.data;

                expheight = image.height;
                print(
                    "height of the image is how much iam getting in this.........::${image.height}");
                return new NotificationListener(
                  onNotification: (v) {
                    if (v is ScrollUpdateNotification) {
                      setState(() {
                        top -= v.scrollDelta / 2;
                        // if(top<0){
                        //   showBottomBar=false;
                        // }
                        // else{
                        //   showBottomBar=true;
                        // }
                      });
                      print("here comming");
                    }
                  },
                  child: Stack(children: [
                    new CustomScrollView(
                      slivers: <Widget>[
                        new SliverAppBar(
                          titleSpacing: 0.0,
                          elevation: 0.0,

                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          expandedHeight:
                              double.parse("${image.height}") > size.height
                                  ? double.parse("${image.height}") / 2
                                  : double.parse("${image.height}"),
                          pinned: false,
                          floating: false,
                          // snap: true,

                          flexibleSpace: new FlexibleSpaceBar(
                            centerTitle: true,
                            background: new Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                new Container(
                                    //  constraints:  BoxConstraints.expand(width:size.width),
                                    // width: 100.00,
                                    height: double.parse("$expheight"),
                                    decoration: new BoxDecoration(
                                      image: new DecorationImage(
                                        image: ExactAssetImage(
                                            "${widget.input["image"]}"),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                // Container(
                                //   height: double.parse("$expheight"),
                                //   //  color: Colors.red,
                                //   child: new Image.asset(
                                //     "${widget.input["image"]}",
                                //     fit: BoxFit.fitHeight,

                                //     // height: 500.0,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        new SliverList(
                          delegate: new SliverChildListDelegate(<Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.amber,
                                borderRadius: const BorderRadius.only(
                                    topLeft: const Radius.circular(30.0),
                                    topRight: const Radius.circular(40.0)),
                              ),
                              child: CardList(
                                input: widget.input,
                                question: widget.question,
                                answer: widget.answer,
                                choices: widget.choices,
                                onEnd: widget.onEnd,
                                onPress: _gettingOnEndData,
                                optionsType: widget.relation,
                              ),
                            ),
                          ], addRepaintBoundaries: false),
                        ),
                      ],
                    ),
                  ]),
                );
              } else {
                return const Center(
                  child: const Text('Loading...'),
                );
              }
            },
          )),
    );
  }

  Future<ui.Image> _getImage() {
    Image image = new Image.asset("${widget.input["image"]}");
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(info.image));
    print("this...is. _geteimage method is........::${completer.future}");
    return completer.future;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: alertDialog,
        ) ??
        false;
  }

  Widget alertDialog(BuildContext context) {
    var colors = Colors.blueAccent;
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: new Container(
          width: 350.0,
          height: 200.0,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
          ),
          child: new Container(
              child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              new Text(
                'Exit?',
                style: TextStyle(
                    color: colors[1],
                    fontStyle: FontStyle.normal,
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold),
              ),
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 40.0),
                      width: 130.0,
                      decoration: BoxDecoration(
                        color: colors[0],
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xFF919191),
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 6.0),
                          )
                        ],
                      ),
                      child: new FlatButton(
                        child: Center(
                          child: IconButton(
                            iconSize: 40.0,
                            alignment: AlignmentDirectional.bottomStart,
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: null,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      )),
                  new Padding(
                    padding: EdgeInsets.only(right: 70.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 40.0),
                      width: 130.0,
                      decoration: BoxDecoration(
                        color: colors[0],
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xFF919191),
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 6.0),
                          )
                        ],
                      ),
                      child: new FlatButton(
                        child: Center(
                          child: IconButton(
                            iconSize: 40.0,
                            alignment: AlignmentDirectional.bottomStart,
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: null,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName('/tab'));
                        },
                      )),
                ],
              )
            ],
          ))),
    ));
  }
}
