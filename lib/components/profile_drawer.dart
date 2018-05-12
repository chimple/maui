import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  ProfileDrawerState createState() {
    return new ProfileDrawerState();
  }
}

class ProfileDrawerState extends State<ProfileDrawer> {
  int _toggle = 0;
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new Drawer(
      child: new Column(
        children: <Widget>[

          new UserAccountsDrawerHeader(
                  accountName: new Text('test'),
                  accountEmail: new Text('test@chimple.org'),
                 currentAccountPicture: new Image.file(new File(user.image)),
            ),

          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                new Container(
                  decoration: new BoxDecoration(
                           border: new Border.all(color: Colors.blue, width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                  child: new RaisedButton(
                    child: const Text('Score'),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Color(0xff2196f3),
                    onPressed: () {
                      // To Perform some action
                      setState(() {
                          _toggle = 0;        
                        });
                    },
                  ),
                ),
                
              new Container(
                  decoration: new BoxDecoration(
                           border: new Border.all(color: Colors.blue, width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                  child: new RaisedButton(
                    child: const Text('Graph'),
                    textColor: Colors.white,
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    splashColor: Color(0xff2196f3),
                    onPressed: () {
                      // To Perform some action
                      setState(() {
                            _toggle = 1;        
                        });
                    },
                  ),
                ),


              ],
            ),
        
         
          _toggle == 0 ? new Container(
            height: 445.0,
                child: new ListView(
                  shrinkWrap: true,
                    children: <Widget>[
         
                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF48AECC), width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Reflex                                80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ),  

                     new Container(
                       margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFE66796), width: 3.0),
                            color: Color(0xFFE66796),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("OrderIt                                80%"), 
                      ),
                    ),

                   new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ),  

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFFF7676), width: 3.0),
                            color: Color(0xFFFF7676),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Memory                               80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ),  
 
                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFEDC23B), width: 3.0),
                            color: Color(0xFFEDC23B),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Draw_Challenge                  80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 


                     new Container(
                       margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFAD85F9), width: 3.0),
                            color: Color(0xFFAD85F9),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Abacus                             80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 


                       new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF87D62B), width: 3.0),
                            color: Color(0xFF87D62B),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Cross_Word                    80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 


                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF66488C), width: 3.0),
                            color: Color(0xFF66488C),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Drawing                        80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFDD6154), width: 3.0),
                            color: Color(0xFFDD6154),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Fill_in_the_Blanks              80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFFF8481), width: 3.0),
                            color: Color(0xFFFF8481),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Calculate_the_numbers           80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFD64C60), width: 3.0),
                            color: Color(0xFFD64C60),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Casino                         80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFDD4785), width: 3.0),
                            color: Color(0xFFDD4785),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Match_the_Following            80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF52C5CE), width: 3.0),
                            color: Color(0xFF52C5CE),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Bingo                           80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFF97658), width: 3.0),
                            color: Color(0xFFF97658),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("True_or_False               80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFA46DBA), width: 3.0),
                            color: Color(0xFFA46DBA),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Tables                         80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFA292FF), width: 3.0),
                            color: Color(0xFFA292FF),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Identify                        80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFFF8481), width: 3.0),
                            color: Color(0xFFFF8481),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Connect_the_Dots                80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF35C9C1), width: 3.0),
                            color: Color(0xFF35C9C1),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Quiz                              80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFEDC23B), width: 3.0),
                            color: Color(0xFFEDC23B),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Fill_Numbers                       80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF42AD56), width: 3.0),
                            color: Color(0xFF42AD56),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Tap_Home                           80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFF47C5D), width: 3.0),
                            color: Color(0xFFF47C5D),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Tap_Wrong                             80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF77DB65), width: 3.0),
                            color: Color(0xFF77DB65),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Guess                                     80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF57DBFF), width: 3.0),
                            color: Color(0xFF57DBFF), 
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Clue_Game                                 80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF57DBFF), width: 3.0),
                            color: Color(0xFF57DBFF), 
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("First_Word                                  80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF48AECC), width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Friend_Word                                  80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF48AECC), width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Word_Fight                                     80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF30C9E2), width: 3.0),
                            color: Color(0xFF30C9E2),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Spin_Wheel                                       80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFA1EF6F), width: 3.0),
                            color: Color(0xFFA1EF6F),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Circle_Words                                       80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF7A8948), width: 3.0),
                            color: Color(0xFF7A8948),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Word_Grid                                           80%"), 
                      ),
                    ),
                ]
              ),
            ) :  new Container(
            height: 445.0,
                child: new ListView(
                  shrinkWrap: true,
                    children: <Widget>[
         
                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF48AECC), width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ),  

                     new Container(
                       margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFE66796), width: 3.0),
                            color: Color(0xFFE66796),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                80%"), 
                      ),
                    ),

                   new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ),  

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFFF7676), width: 3.0),
                            color: Color(0xFFFF7676),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                               80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ),  
 
                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFEDC23B), width: 3.0),
                            color: Color(0xFFEDC23B),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                  80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 


                     new Container(
                       margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFAD85F9), width: 3.0),
                            color: Color(0xFFAD85F9),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                             80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 


                       new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF87D62B), width: 3.0),
                            color: Color(0xFF87D62B),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                    80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 


                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF66488C), width: 3.0),
                            color: Color(0xFF66488C),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                        80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFDD6154), width: 3.0),
                            color: Color(0xFFDD6154),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple              80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFFF8481), width: 3.0),
                            color: Color(0xFFFF8481),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple           80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFD64C60), width: 3.0),
                            color: Color(0xFFD64C60),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                         80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFDD4785), width: 3.0),
                            color: Color(0xFFDD4785),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple            80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF52C5CE), width: 3.0),
                            color: Color(0xFF52C5CE),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                           80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFF97658), width: 3.0),
                            color: Color(0xFFF97658),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple               80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFA46DBA), width: 3.0),
                            color: Color(0xFFA46DBA),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                         80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFA292FF), width: 3.0),
                            color: Color(0xFFA292FF),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                        80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFFF8481), width: 3.0),
                            color: Color(0xFFFF8481),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF35C9C1), width: 3.0),
                            color: Color(0xFF35C9C1),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                              80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFEDC23B), width: 3.0),
                            color: Color(0xFFEDC23B),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                       80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF42AD56), width: 3.0),
                            color: Color(0xFF42AD56),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                           80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFF47C5D), width: 3.0),
                            color: Color(0xFFF47C5D),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                             80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF77DB65), width: 3.0),
                            color: Color(0xFF77DB65),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                     80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF57DBFF), width: 3.0),
                            color: Color(0xFF57DBFF), 
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                 80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF57DBFF), width: 3.0),
                            color: Color(0xFF57DBFF), 
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                  80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF48AECC), width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                  80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF48AECC), width: 3.0),
                            color: Color(0xFF48AECC),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                     80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF30C9E2), width: 3.0),
                            color: Color(0xFF30C9E2),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                       80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFFA1EF6F), width: 3.0),
                            color: Color(0xFFA1EF6F),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                       80%"), 
                      ),
                    ),

                    new Padding(
                       padding: const EdgeInsets.all(3.0),
                    ), 

                       new Container(
                         margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: Color(0xFF7A8948), width: 3.0),
                            color: Color(0xFF7A8948),
                             boxShadow: [
                              new BoxShadow(
                              color: const Color(0x44000000),
                                spreadRadius: 2.0,
                                offset: const Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: new BorderRadius.circular(12.0), 
                          ),
                         child: new ListTile(
                         title: new Text("Chimple                                           80%"), 
                      ),
                    ),
                ]
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileDrawerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = AppStateContainer.of(context).state.loggedInUser;
    return new FlatButton(
        child: new CircleAvatar(
          backgroundImage: new FileImage(new File(user.image)),
          backgroundColor: Colors.white,
        ),
        onPressed: () => Scaffold.of(context).openDrawer());
  }
}
