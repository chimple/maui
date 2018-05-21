import 'package:flutter/material.dart';

class Score extends StatelessWidget {
 var listOfGames = [
    'Reflex', 'OrderIt', 'Memory', 'Draw_Challenge', 'Abacus', 'Cross_Word', 'Drawing', 'Fill_in_the_Blanks', 'Calculate_the_numbers',
    'Casino', 'Match_the_Following', 'Bingo', 'True_or_False', 'Tables', 'Identify', 'Connect_the_Dots', 'Quiz','Fill_Numbers',
    'Tap_Home', 'Tap_wrong','Guess', 'Clue_Game', 'First_Word', 'Friend_Word', 'Word_Fight', 'Spin_Wheel', 'Circle_Words', 'Word_Grid',
  ];

  List<int> colors = [ 0XFF48AECC, 0XFFE66796, 0XFFFF7676, 0XFFEDC23B, 0XFFAD85F9, 0XFF77DB65, 0XFF66488C, 0XFFDD6154, 0XFFFFCE73,
     0XFFD64C60, 0XFFDD4785, 0XFF52C5CE, 0XFFF97658, 0XFFA46DBA, 0XFFA292FF, 0XFFFF8481, 0XFF35C9C1, 0XFFEDC23B, 0XFF42AD56, 
     0XFFF47C5D, 0XFF77DB65, 0XFF57DBFF, 0XFFEB706F, 0XFF48AECC, 0XFFFFC729, 0XFF30C9E2, 0XFFA1EF6F, 0XFF48AECC
  ];

  @override
  Widget build(BuildContext context) {  
                return new ListView.builder(
                  itemCount: listOfGames?.length,
                  itemBuilder: (context, i) => 
                      new Container(
                        margin: const EdgeInsets.all(7.0),
                        decoration: new BoxDecoration(
                           border: new Border.all(color: new Color(colors[i]), width: 3.0),
                            color: new Color(colors[i]),
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
                         title: new Text(listOfGames[i], textAlign: TextAlign.left), 
                      ),
                    ),
              );
  }
}