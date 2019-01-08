import 'dart:io';
import 'package:maui/db/entity/user.dart';
import 'package:maui/quack/user_collection.dart';
import 'package:maui/quack/user_drawing_grid.dart';
import 'package:maui/quack/user_progress.dart';
import 'package:maui/repos/user_repo.dart';
import '../loca.dart';
import 'package:flutter/material.dart';
import '../state/app_state_container.dart';
import 'package:maui/components/camera.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  List<String> categories = ["gallery", "collection", "progress"];
  TabController tabController;
  String userName;
  bool setflag = false;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: categories.length, vsync: this);
  }

  getImage(BuildContext context) async {
    setState(() {
      imagePathStore = null;
    });

    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new CameraScreen(
                true,
              )),
    );
    // imagePathStore = "assets/solo.png" ;
  }

  Widget getTabBar() {
    return TabBar(
        isScrollable: false,
        indicatorColor: Colors.grey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 5.0,
        labelColor: Colors.black,
        labelStyle: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal),
        controller: tabController,
        tabs: [
          new Tab(text: Loca.of(context).gallery),
          new Tab(text: Loca.of(context).collection),
          new Tab(text: Loca.of(context).progress),
        ]);
  }

  Widget getTabBarPages(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Orientation orientation = media.orientation;

    return Align(
      alignment: Alignment.topCenter,
      child: TabBarView(controller: tabController, children: <Widget>[
        UserDrawingGrid(
          userId: AppStateContainer.of(context).state.loggedInUser.id,
        ),
        UserCollection(
          userId: AppStateContainer.of(context).state.loggedInUser.id,
        ),
        UserProgress(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var _height = media.size.height;
    var user = AppStateContainer.of(context).state.loggedInUser;
    final TextEditingController _textController = new TextEditingController();
    final userText = Row(children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 35.0),
          child: Column(
            children: <Widget>[
              new Text(
                "${user.name}",
                style: new TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              new Text(
                "${user.points}",
                maxLines: 1,
                textDirection: TextDirection.ltr,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.red,
            size: 35.0,
          ),
          onPressed: () {
            setState(() {
              setflag = true;
            });
          },
        ),
      ),
    ]);

    final stackHeader = Stack(
      overflow: Overflow.clip,
      children: [
        Align(
          alignment: AlignmentDirectional.center,
          child: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(
                backgroundImage: new FileImage(new File(user.image)),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: CircleAvatar(
            radius: 30.0,
            child: Center(
              child: new IconButton(
                // color: Colors.blue,
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () => getImage(context),
              ),
            ),
          ),
        )
      ],
    );
    final userdetails = Column(
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                height: _height * .14,
                width: _height * .14,
                child: CircleAvatar(
                  child: stackHeader,
                )),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: userText,
            ),
          ),
        ),
        getTabBar()
      ],
    );

    final _profileTextfield = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: new TextField(
            // focusNode: _focusName,
            autocorrect: false,
            autofocus: true,
            maxLength: 20,
            textInputAction: TextInputAction.none,
            onSubmitted: _submit(userName),
            onChanged: _onTyping,
            controller: _textController,
            decoration: new InputDecoration(
              counterText: '',
              labelStyle: TextStyle(color: Colors.red),
              isDense: true,
              border: const OutlineInputBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(10.0)),
                  borderSide: const BorderSide(
                      style: BorderStyle.solid,
                      width: 100.0,
                      color: Colors.amber)),
              hintText: Loca.of(context).writeYourName,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            radius: 30,
            child: IconButton(
              color: Colors.black,
              icon: new Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () {
                editbutton(user);
              },
            ),
          ),
        ),
      ],
    );

    return Scaffold(
        body: SafeArea(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            height: _height * 0.33,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: userdetails,
                            )),
                        SizedBox(
                            height: _height * 0.67,
                            child: getTabBarPages(context)),
                      ],
                    )
                  ],
                ),
              ),
              setflag == true ? _profileTextfield : Container()
            ],
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: new IconButton(
                icon: new Icon(Icons.arrow_back),
                iconSize: 42.0,
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    ));
  }

  _onTyping(String name) {
    userName = name;
  }

  _submit(String name) {
    setState(() {
      userName = name;
      // setflag = false;
    });
  }

  void editbutton(User user) async {
    if (user.name != null && user.name != userName && userName != null) {
      setState(() {
        user.name = userName;
        setflag = false;
      });
      var user1 = user;
      user1.name = userName;

      UserRepo().update(user1);
    }
  }
}
