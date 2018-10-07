import 'package:flutter/material.dart';
import 'package:maui/components/topic_card_view.dart';
import 'package:maui/db/entity/quack_card.dart';

class TopicScreen extends StatelessWidget {
  final String topicId;
  final String topicName;
  final String topicImage;
  TopicScreen(
      {key,
      @required this.topicId,
      @required this.topicName,
      @required this.topicImage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('topic_screen hero ${CardType.collection}/${topicId}');
    return new Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 256.0,
//          snap: true,
//          floating: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(topicName),
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  tag: '${CardType.collection}/${topicId}',
                  child: Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage(topicImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
//                Image.asset(
//                  topicImage,
//                  fit: BoxFit.cover,
//                  height: 256.0,
//                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, -0.4),
                      colors: <Color>[Color(0x60000000), Color(0x00000000)],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        TopicCardView(
          topicId: topicId,
          cardType: CardType.activity,
        ),
        TopicCardView(
          topicId: topicId,
          cardType: CardType.knowledge,
        ),
        TopicCardView(
          topicId: topicId,
          cardType: CardType.collection,
        ),
        TopicCardView(
          topicId: topicId,
          cardType: CardType.question,
        )
      ],
    ));
  }
}
