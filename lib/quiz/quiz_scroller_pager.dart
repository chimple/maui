import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';
import 'card_list.dart';

class QuizScrollerPager extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  Widget huda;
  final relation;

  QuizScrollerPager({Key key, this.input, this.onEnd, this.huda, this.relation})
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
  bool showBottomBar = true;

  TabController tabController;
  var optionalType;
  final _scrollController = TrackingScrollController();
  // AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);

    print("hello this should come first...");
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Future<ui.Image> _getImage() {
    Image image = new Image.asset('assets/dict/cat.png');
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => completer.complete(info.image));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    optionalType = widget.relation;
    MediaQueryData media = MediaQuery.of(context);
    print("thius..... is....expandheight is.....$expheight");
    print("Wiget relation type is......::${widget.relation}");

    print("hello this what i am trying to send to that....::${widget.input}");
    var size = media.size;

    return Scaffold(
        bottomNavigationBar: Container(
          height: showBottomBar ? 150.0 : 0.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Tab(
                child: new Icon(
                  Icons.arrow_back,
                  semanticLabel: "previous",
                ),
              ),
              Container(
                height: 100.0,
                child: new Tab(
                  child: widget.huda,
                ),
              ),
              new Tab(
                child: new Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
        body: new FutureBuilder<ui.Image>(
          future: _getImage(),
          builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              ui.Image image = snapshot.data;

              expheight = image.height;

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
                        expandedHeight: double.parse("${image.height}"),
                        pinned: false,
                        floating: false,
                        // snap: true,

                        flexibleSpace: new FlexibleSpaceBar(
                          centerTitle: true,
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Container(
                                height: double.parse("$expheight"),
                                //  color: Colors.red,
                                child: new Image.asset(
                                  "assets/dict/cat.png",
                                  fit: BoxFit.fitHeight,

                                  // height: 500.0,
                                ),
                              ),
                              // const DecoratedBox(
                              //   decoration: BoxDecoration(
                              //     gradient: LinearGradient(
                              //       begin: Alignment(0.0, -1.0),
                              //       end: Alignment(0.0, -0.4),
                              //       colors: <Color>[
                              //         Color(0x60000000),
                              //         Color(0x00000000)
                              //       ],
                              //     ),
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
                              color: Colors.grey,
                              borderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(30.0),
                                  topRight: const Radius.circular(40.0)),
                            ),
                            child: CardList(
                              input: widget.input,
                              onEnd: widget.onEnd,
                              optionsType: widget.relation == "many"
                                  ? OptionCategory.many
                                  : widget.relation == "pair"
                                      ? OptionCategory.pair
                                      : OptionCategory.oneAtATime,
                            ),
                          ),
                        ], addRepaintBoundaries: false),
                      ),
                    ],
                  ),
                ]),
              );
            }
          },
        ));
  }
}
