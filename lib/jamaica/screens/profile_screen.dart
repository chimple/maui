import 'package:flutter/material.dart';
import 'dart:io';
import 'package:maui/db/entity/user.dart';
import 'package:maui/quack/user_collection.dart';
import 'package:maui/quack/user_drawing_grid.dart';

import 'package:maui/repos/user_repo.dart';
import 'package:maui/loca.dart';

import 'package:maui/components/camera.dart';
import 'package:maui/state/app_state_container.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  List<String> categories = [
    "gallery",
    "collection",
  ];
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
        labelColor: Colors.white,
        labelStyle: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal),
        controller: tabController,
        tabs: [
          new Tab(text: Loca.of(context).gallery),
          new Tab(text: Loca.of(context).collection),
          // new Tab(text: Loca.of(context).progress),
        ]);
  }

  Widget getTabBarPages(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: TabBarView(controller: tabController, children: <Widget>[
        UserDrawingGrid(
          userId: AppStateContainer.of(context).state.loggedInUser.id,
        ),
        UserCollection(
          userId: AppStateContainer.of(context).state.loggedInUser.id,
        ),

        // UserProgress()
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var _height = media.size.height;
    var user = AppStateContainer.of(context).state.loggedInUser;
    final TextEditingController _textController = new TextEditingController();
    final userText =
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 35.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Text(
                    "${user.name}",
                    style: new TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "${user.points}",
                    maxLines: 1,
                    textDirection: TextDirection.ltr,
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.topEnd,
        child: Center(
          child: Container(
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.red,
                size: 30.0,
              ),
              onPressed: () {
                setState(() {
                  setflag = true;
                });
              },
            ),
          ),
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
            radius: 25.0,
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
          Container(
            color: Colors.blueAccent,
            // child: SvgPicture.asset(
            //   "assets/background_svg.svg",
            //   fit: BoxFit.fill,

            //   // allowDrawingOutsideViewBox: true,
            // ),
          ),
          Column(
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: _height * 0.33,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: userdetails,
                        )),
                    Expanded(
                      child: SizedBox(
                          height: _height * 0.67,
                          child: getTabBarPages(context)),
                    ),
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

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: TabBar(
//             indicatorWeight: 5.0,
//             labelColor: Colors.white,
//             labelStyle: new TextStyle(
//                 fontSize: 25.0,
//                 fontWeight: FontWeight.bold,
//                 fontStyle: FontStyle.normal),
//             tabs: [
//               new Tab(
//                 text: Loca.of(context).progress,
//               ),
//               new Tab(text: Loca.of(context).collection),
//             ],
//           ),
//         ),
//         body: Stack(children: [
//           Container(
//             color: Colors.blueGrey,
//           ),
//           TabBarView(
//             children: [
//               Progress(),
//               Collected(),
//             ],
//           ),
//         ]),
//       ),
//     );
//   }
// }
