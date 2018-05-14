import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
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
                         title: new Text("Reflex", textAlign: TextAlign.left), 
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
                         title: new Text("OrderIt", textAlign: TextAlign.left), 
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
                         title: new Text("Memory", textAlign: TextAlign.left,), 
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
                         title: new Text("Draw_Challenge", textAlign: TextAlign.left,), 
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
                         title: new Text("Abacus", textAlign: TextAlign.left,), 
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
                         title: new Text("Cross_Word", textAlign: TextAlign.left,), 
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
                         title: new Text("Drawing", textAlign: TextAlign.left,), 
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
                         title: new Text("Fill_in_the_Blanks", textAlign: TextAlign.left), 
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
                         title: new Text("Calculate_the_numbers", textAlign: TextAlign.left,), 
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
                         title: new Text("Casino", textAlign: TextAlign.left,), 
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
                         title: new Text("Match_the_Following", textAlign: TextAlign.left,), 
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
                         title: new Text("Bingo", textAlign: TextAlign.left,), 
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
                        title: new Text("True_or_False", textAlign: TextAlign.left,),
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
                         title: new Text("Tables", textAlign: TextAlign.left,),
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
                        title: new Text("Identify", textAlign: TextAlign.left,),
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
                         title: new Text("Connect_the_Dots", textAlign: TextAlign.left,),
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
                         title: new Text("Quiz", textAlign: TextAlign.left,),
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
                         title: new Text("Fill_Numbers", textAlign: TextAlign.left,),
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
                         title: new Text("Tap_Home", textAlign: TextAlign.left,),
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
                         title: new Text("Tap_wrong", textAlign: TextAlign.left,),
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
                        title: new Text("Guess", textAlign: TextAlign.left,), 
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
                         title: new Text("Clue_Game", textAlign: TextAlign.left,), 
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
                         title: new Text("First_Word", textAlign: TextAlign.left,), 
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
                         title: new Text("Friend_Word", textAlign: TextAlign.left,),
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
                         title: new Text("Word_Fight", textAlign: TextAlign.left,),
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
                        title: new Text("Spin_Wheel", textAlign: TextAlign.left,), 
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
                         title: new Text("Circle_Words", textAlign: TextAlign.left,),
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
                         title: new Text("Word_Grid", textAlign: TextAlign.left,),
                      ),
                    ),
                ]
              ),
            );
  }
}