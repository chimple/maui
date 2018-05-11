import 'dart:io';
import 'package:flutter/material.dart';
import 'package:maui/state/app_state_container.dart';

class ProfileDrawer extends StatelessWidget {
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
                new RaisedButton(
                  child: const Text('Score'),
                  textColor: Colors.white,
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Color(0xff2196f3),
                  onPressed: () {
                    // To Perform some action
                  },
                ),
                
              new RaisedButton(
                  child: const Text('Graph'),
                  textColor: Colors.white,
                  color: Theme.of(context).accentColor,
                  elevation: 4.0,
                  splashColor: Color(0xff2196f3),
                  onPressed: () {
                    // To Perform some action
                  },
                ),
              ],
            ),

        

          new Container(
            height: 450.0,
                child: new ListView(
                 // shrinkWrap: true,
                    children: <Widget>[
                      new ListTile(
                      title: new Text("Reflex"), 
                      ),

                      new ListTile(
                      title: new Text("OrderIt"),                      
                      ),

                      new ListTile(
                      title: new Text("Memory"),                     
                      ),

                      new ListTile(
                      title: new Text("Draw_Challenge"),                      
                      ),

                      new ListTile(
                      title: new Text("Abacus"),                     
                      ),

                      new ListTile(
                      title: new Text("Crossword"),                    
                      ),

                      new ListTile(
                      title: new Text("Drawing"),                     
                      ),

                      new ListTile(
                      title: new Text("Fill_in_the_Blanks"),                     
                      ),

                      new ListTile(
                      title: new Text("Calculate_the_numbers"),                      
                      ),

                      new ListTile(
                      title: new Text("Casino"),                    
                      ),

                      new ListTile(
                      title: new Text("Match_The_Following"),                    
                      ),

                      new ListTile(
                      title: new Text("Bingo"),
                                            ),

                      new ListTile(
                      title: new Text("True_or_False"),
                                            ),

                      new ListTile(
                      title: new Text("Tables"),                    
                      ),

                      new ListTile(
                      title: new Text("Identify"),                      
                      ),

                      new ListTile(
                      title: new Text("Connect_the_Dots"),                    
                      ),

                      new ListTile(
                      title: new Text("Quiz"),                 
                      ),

                      new ListTile(
                      title: new Text("Fill_Numbers"),                  
                      ),

                      new ListTile(
                      title: new Text("Tap_Home"),                  
                      ),

                      new ListTile(
                      title: new Text("Tap_Wrong"),                     
                      ),

                      new ListTile(
                      title: new Text("Guess"),
                    
                      ),

                      new ListTile(
                      title: new Text("Clue_Game"),                     
                      ),

                      new ListTile(
                      title: new Text("first_word"),                   
                      ),

                      new ListTile(
                      title: new Text("Friend_Word"),                      
                      ),

                      new ListTile(
                      title: new Text("Word_Fight"),                     
                      ),

                      new ListTile(
                      title: new Text("Spin_Wheel"),                     
                      ),

                      new ListTile(
                      title: new Text("Circle_Words"),
                                           ),

                      new ListTile(
                      title: new Text("Wordgrid"),                    
                      ),
                ]
              ),
            )
        ],
      ),
    );
    // return new Drawer(
    //     child: new ListView(
    //        primary: false,
    //         children: <Widget>[

    //           new UserAccountsDrawerHeader(
    //              accountName: new Text('test'),
    //              accountEmail: new Text('test@chimple.org'),
    //              currentAccountPicture: new Image.file(new File(user.image)),
    //            ),

    //            new RaisedButton(
                 
    //            ),

    //            new ListTile(
    //              title: new Text("Reflex"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("OrderIt"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Memory"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Draw_Challenge"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Abacus"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Crossword"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Drawing"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Fill_in_the_Blanks"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Calculate_the_numbers"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Casino"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Match_The_Following"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Bingo"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("True_or_False"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Tables"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Identify"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Connect_the_Dots"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Quiz"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Fill_Numbers"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Tap_Home"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Tap_Wrong"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Guess"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Clue_Game"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("first_word"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Friend_Word"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //             new ListTile(
    //              title: new Text("Word_Fight"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Spin_Wheel"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Circle_Words"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),

    //              new ListTile(
    //              title: new Text("Wordgrid"),
    //              trailing: new Icon(Icons.arrow_forward),
    //              ),
    //        ],         
    //   )
    // );
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
