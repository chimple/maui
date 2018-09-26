import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/hud.dart';
import 'package:maui/components/quiz_button.dart';
import 'dart:async';
import '../components/quiz_question.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/repos/user_repo.dart';
import '../db/entity/user.dart';
import 'card_list.dart';

// const Map<String, dynamic> _homework = {
//   'image': 'lion',
//   'question': "This animal is a carnivorous reptile.",
//   'answer': 'lion',
//   'choices': ["Cat", "Sheep", "lion", "Cow" "shshs", "udsjhjd", "hdjajdh"],
// };

class Quizscroller_pagger extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  Widget huda;
  final ralation;

  Quizscroller_pagger({Key key, this.input, this.onEnd, this.huda,this.ralation})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new Quizscroller_paggerState();
  }
}

enum Statuses { Active, Visible, Disappear, Wrong }

class Quizscroller_paggerState extends State<Quizscroller_pagger>
    with SingleTickerProviderStateMixin {
  bool showans = false;
  var top = 0.0;
  int playTime = 10000;
  var expheight;
  double _myProgress = 0.0;
  List<Statuses> _statuses = [];
  TabController tabController;
  final _scrollController = TrackingScrollController();
  // AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
    List<String> choices = widget.input['choices'].cast<String>();
    _statuses = choices.map((a) => Statuses.Active).toList(growable: false);
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
    MediaQueryData media = MediaQuery.of(context);
    print("thius..... is....expandheight is.....$expheight");


    print("hello this what i am trying to send to that....::${widget.huda}");
    var size = media.size;

    List<String> choices = [
      "Cat",
      "Sheep",
      "lion",
      "Cow" "shshs",
      "udsjhjd",
      "hdjajdh",
      "hello",
      "boss",
      "scroll"
    ];


      return Scaffold(
          bottomNavigationBar: Container(
            // alignment: Alignment.bottomCenter,
            height: top == 0.0 ? 150.0 : 150.0,
                      // margin: EdgeInsets.all(32.0),
      //                   decoration: new ShapeDecoration(
      //   shape: new RoundedRectangleBorder(
      //     borderRadius: new BorderRadius.all(Radius.circular(32.0)),
      //     side: new BorderSide(width: 1.0)
      //   )
      // ),
           
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
// controller: tabController,
//             tabs: <Widget>[
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
                      setState(() => top -= v.scrollDelta / 2);
                    }
                  },
                  child: Stack(children: [
                
                    // new Positioned(
                    //   top: top,
                    //   child: new Image.asset('assets/HouseItems.png'),
                    // ),
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
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, -0.4),
                                      colors: <Color>[
                                        Color(0x60000000),
                                        Color(0x00000000)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              
                        
                         new SliverList(
                            delegate: new SliverChildListDelegate(<Widget>[
                              Container(
                              // height: size.height/2,
                                decoration: new BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: const Radius.circular(30.0),
                                      topRight: const Radius.circular(40.0)),
                                ),
                                child: 
                                CardList(input:widget.input,onEnd:widget.onEnd,optionsType:widget.ralation),
                                
                                // new Column(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   // crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: _buildListOfQuestionsAsked(
                                  // context, choices),
                                // ),
                              ),
                            
                            ], addRepaintBoundaries: false),
                          ),
                       
                      ],
                    ),
                  ]),
                );
              } else {
                return new Text('Loading...');
              }
            },
          ));
   
  }

  _buildListOfQuestionsAsked(BuildContext context, List<String> choices) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    List<Widget> _questionResults = [];

    choices.map((q) {
      _questionResults.add(
        _buildAskedQuestionExpandableTile(q, context),
      );
    }).toList(growable: false);

    return _questionResults;
  }

  Widget _buildAskedQuestionExpandableTile(String q, BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    return new Container(
      width: size.width / 2,
      height: size.height / 8,
      child: Card(
        child: new Text("$q"),
      ),
    );
  }
}
