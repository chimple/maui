import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/animation.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'stagger_animation.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:maui/components/signin_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:nima/nima_actor.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State createState() => new WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
      var user;
  // AnimationController _loginButtonController;
  // var animationStatus = 0;

  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');    
      User user = await UserRepo().getUser(userId);
      await AppStateContainer.of(context).setLoggedInUser(user);
      new Future.delayed(const Duration(milliseconds: 7000), (){
        Navigator.of(context).pushReplacementNamed('/tab');
      });   
  }

  @override
  Widget build(BuildContext context) {
    //timeDilation = 0.4;
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    // TODO: implement build
    return new Scaffold(
        body: new Container(
            decoration: new BoxDecoration(
              color: Colors.purple,
            ),
            child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new AspectRatio(
                          aspectRatio: size.height > size.width ? 1.5 : 3.8,
                          child: new NimaActor(
                              "assets/quack",
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              animation: 'welcome with hello',
                              mixSeconds: 0.2,
                            ),),
                  //     new Text(
                  //       "Maui",
                  //       style: new TextStyle(
                  //         fontSize: size.height > size.width ? 72.0 : 60.0,
                  //         color: Colors.amber,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // animationStatus == 0
                  //     ? new Padding(
                  //         padding: size.height > size.width
                  //             ? new EdgeInsets.all(50.0)
                  //             : new EdgeInsets.all(10.0),
                  //         child: new InkWell(
                  //             onTap: () {
                  //               setState(() {
                  //                 animationStatus = 1;
                  //               });
                  //               new Future.delayed(const Duration(milliseconds: 4000), (){
                  //                 _playAnimation();
                  //               });                                
                  //             },
                  //             child: new SignIn()),
                  //       )
                  //     : new StaggerAnimation(
                  //         buttonController: _loginButtonController.view),
                ])])));
  }
}
