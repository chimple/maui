import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/components/activity_progress_tracker.dart';
import 'package:maui/components/article_progress_tracker.dart';
import 'package:maui/components/quiz_progress_tracker.dart';
import 'package:maui/screens/article_screen.dart';
import 'package:maui/screens/drawing_list_screen.dart';
import 'package:maui/screens/topic_screen.dart';

enum CardType { activity, topic, article, quiz }

class CardButton extends StatefulWidget {
  final String text;
  final String image;
  final String id;
  final CardType cardType;
  final String topicId;

  CardButton(
      {Key key,
      @required this.text,
      this.id,
      this.image,
      this.cardType,
      this.topicId})
      : super(key: key);

  @override
  State createState() => new CardButtonState();
}

class CardButtonState extends State<CardButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => goToCard(context),
        child: new Column(
          children: <Widget>[
            widget.image == null
                ? Container(color: Colors.red)
                : widget.image.endsWith(".svg")
                    ? new Container(
                        child: new AspectRatio(
                          aspectRatio: 1.0,
                          child: new SvgPicture.asset(
                            widget.image,
                            allowDrawingOutsideViewBox: false,
                          ),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: 1.0,
                        child: Hero(
                          tag: '${widget.cardType}/${widget.id}',
                          child: Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage(widget.image),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              border: new Border.all(
                                color: Colors.red,
                                width: 4.0,
                              ),
                            ),
                          ),
                        ),
                      ),
            new Container(
              child: new Center(
                child: new Text(widget.text,
                    style: new TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
      ),
    );
  }

  void goToCard(BuildContext context) {
    switch (widget.cardType) {
      case CardType.activity:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => DrawingListScreen(
                    activityId: widget.id,
                  )),
        );
        break;
      case CardType.article:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => ArticleScreen(
                    topicId: widget.topicId,
                  )),
        );
        break;
      case CardType.topic:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => TopicScreen(
                    topicId: widget.id,
                    topicName: widget.text,
                    topicImage: widget.image,
                  )),
        );
        break;
      case CardType.quiz:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => TopicScreen(
                    topicId: widget.id,
                    topicName: widget.text,
                    topicImage: widget.image,
                  )),
        );
    }
  }
}
