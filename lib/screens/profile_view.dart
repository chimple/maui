import 'dart:io';
import '../repos/topic_repo.dart';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/topic.dart';
import '../state/app_state_container.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  // TabController _controller;
  List<Topic> _topics;
  List<String> categories = [
    "Gallery",
    "Topic",
  ];
  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _topics = await TopicRepo().getTopicsForCategoryId('Animals');
    print("subcategory of birds iss,,,....::$_topics");
  }

  @override
  Widget build(BuildContext ctxt) {
      MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = media.orientation;
    var _size = media.size;
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new MaterialApp(
        home: DefaultTabController(
            length: categories.length,
            child: new Scaffold(
                // appBar: new AppBar(
                //   backgroundColor: Colors.white24,
                //   title: new Center(
                //       child: Column(children: [
                //     Expanded(
                //         child: new Container(
                //       //  height: 60.0,
                //       //  width: 60.0,
                //       decoration: new BoxDecoration(
                //         borderRadius:
                //             const BorderRadius.all(const Radius.circular(16.0)),
                //       ),
                //       child: Image.file(new File(user.image)),
                //     )),
                //     new Text("${user.name}")
                //   ])),
                //   bottom: new TabBar(
                //     isScrollable: true,
                //     tabs: List<Widget>.generate(categories.length, (int index) {
                //       print(categories[0]);
                //       return Padding(
                //         padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                //         child: new Tab(text: "${categories[index]}"),
                //       );
                //     }),
                //   ),
                // ),
                // body: new TabBarView(
                //   children:
                //       List<Widget>.generate(categories.length, (int index) {
                //     print(categories[0]);
                //     return new Text(
                //         "again some random text${categories[index]}");
                //   }),
                // )
                
                 body: new NestedScrollView(
          // controller: _scrollcontroller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                backgroundColor: const Color(0xffFC5E79),
                pinned: true,
                // floating: true,
                // actions: <Widget>[_icon2],
              
                // title:Container(
                //   height: 300.0,
                //   width: 300.0,
                //   child: new Center(
                //         child: Column(children: [
                //       Expanded(
                //           child: new Container(
                //          height: 100.0,
                //          width: 100.0,
                //         decoration: new BoxDecoration(
                //           borderRadius:
                //               const BorderRadius.all(const Radius.circular(16.0)),
                //         ),
                //         child: Image.file(new File(user.image)),
                //       )),
                //       new Text("${user.name}")
                //     ])),
                // ),
                
                expandedHeight: orientation == Orientation.portrait
                    ? _size.height * .25
                    : _size.height * .5,
                // forceElevated:false,
                flexibleSpace: new FlexibleSpaceBar(
                  background: new FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      child: Container(
                  height: 300.0,
                  width: 300.0,
                  child: new Center(
                        child: Column(children: [
                      new Container(
                         height: 200.0,
                         width: 200.0,
                        decoration: new BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(16.0)),
                        ),
                        child: Image.file(new File(user.image)),
                      ),
                      new Text("${user.name}")
                    ])),
                ),),
                ),
                bottom: new TabBar(
                  isScrollable: false,
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 5.0,
                  labelColor: Colors.white,
                  labelStyle: new TextStyle(
                      fontSize: _size.height * 0.3 * 0.07,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal),
                  // controller: _controller,
                  // unselectedLabelColor: _myHandler.color,
                  tabs: <Tab>[
                    new Tab(
                      text:"Gallery",
                    ),
                    new Tab(
                      text: "Topic",
                    ),
                 
                  
                  ],
                ),
              ),
            ];
          },
          body: new TabBarView(
            // controller: _controller,
            children: <Widget>[new Text("i have to show gallery here"), new Text("progress of each topic"),
            
            new ProfileView()],
          ),
        ),
                )));
  }
}
