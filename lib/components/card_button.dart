import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quiz/quiz_game.dart';
import 'package:maui/screens/article_screen.dart';
import 'package:maui/screens/drawing_list_screen.dart';
import 'package:maui/screens/topic_screen.dart';

final cardColors = [
  Color(0xffffbc01),
  Color(0xff3cc1ef),
  Color(0xfff74674),
  Color(0xff99ce34)
];

class CardButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    print('card_button hero ${cardType}/${id}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => goToCard(context),
        child: new Column(
          children: <Widget>[
            image == null
                ? Container(color: Colors.red)
                : image.endsWith(".svg")
                    ? new Container(
                        child: new AspectRatio(
                          aspectRatio: 1.0,
                          child: new SvgPicture.asset(
                            image,
                            allowDrawingOutsideViewBox: false,
                          ),
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: 1.0,
                        child: Hero(
                          tag: '${cardType}/${id}',
                          child: Container(
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage(image),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              border: new Border.all(
                                color: cardColors[cardType.index],
                                width: 4.0,
                              ),
                            ),
                          ),
                        ),
                      ),
            new Container(
              child: new Center(
                child: new Text(text,
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
    switch (cardType) {
      case CardType.activity:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => DrawingListScreen(
                    activityId: id,
                  )),
        );
        break;
      case CardType.knowledge:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => ArticleScreen(
                    topicId: topicId,
                  )),
        );
        break;
      case CardType.collection:
        Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) => TopicScreen(
                    topicId: id,
                    topicName: text,
                    topicImage: image,
                  )),
        );
        break;
      case CardType.question:
        Navigator.of(context).push(
          new MaterialPageRoute(builder: (BuildContext context) => QuizGame()),
        );
    }
  }
}
