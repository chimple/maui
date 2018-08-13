import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionComponent extends StatelessWidget {
  final String text;
  final String image;

  QuestionComponent({
    Key key,
    @required this.text,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    print(" image of the data is...$image");

    return Scaffold(
        appBar: AppBar(
          title: new Text("progress bar"),
        ),
        body: new Container(
          padding: EdgeInsets.all(20.0),
          height: size.height * 0.45,
          color: Colors.white,
          child: Column(children: [
            new SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: size.height * 0.45 * 0.87,
                child: new ListView(
                  children: <Widget>[
                    image == null
                        ? Container(
                            padding: EdgeInsets.all(size.height * 0.45 * 0.1),
                          )
                        : Container(
                            height: size.height / 3,
                            child: image.endsWith(".svg")
                                ? new Container(
                                    color: Colors.red,
                                    child: new AspectRatio(
                                      aspectRatio: 2.0,
                                      child: new SvgPicture.asset(
                                        image,
                                        allowDrawingOutsideViewBox: false,
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: new AssetImage(image),
                                          fit: BoxFit.cover,
                                        ),
                                        color: Colors.red),
                                  ),
                          ),
                    new Container(
                      child: new Text(
                        text,
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
