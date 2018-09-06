import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuizQuestion extends StatelessWidget {
  final String text;
  final String image;

  QuizQuestion({
    Key key,
    @required this.text,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(" image of the data is...$image");
 MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    return new Container(
    
      color: Colors.white,
      child: Container(
        child: new ListView(
          children: <Widget>[
            
            image == null
                ? Container()
                : Container(
                  height: size.height*0.3,
                    child: image.endsWith(".svg")
                        ? new Container(
                            color: Colors.red,
                            child: new AspectRatio(
                              aspectRatio: 1.0,
                              child: new SvgPicture.asset(
                                image,
                                allowDrawingOutsideViewBox: false,
                              ),
                            ),
                          )
                        : Container(
                            child: new Image.asset(image,),
                          ),
                  ),
                   Padding(
                     padding: const EdgeInsets.all(40.0),
                     child: new Container(
              child: new Text(
                text,
                textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            ),
                   ),
           
          ],
        ),
      ),
    );
  }
}
