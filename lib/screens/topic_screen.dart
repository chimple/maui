import 'package:flutter/material.dart';
import 'package:maui/components/topic_card_view.dart';
import 'package:maui/loca.dart';
import 'package:maui/screens/activity_list_view.dart';
import 'package:maui/screens/related_page.dart';
import 'package:maui/screens/select_opponent_screen.dart';
import 'package:maui/components/topic_page_view.dart';

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
    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text(topicName),
//          centerTitle: true,
//          backgroundColor: Colors.teal[300],
//          elevation: 5.0,
//          actions: <Widget>[
//            new IconButton(
//              onPressed: () {
//                Navigator.of(context).push(
//                    MaterialPageRoute<void>(builder: (BuildContext context) {
//                  return ActivityListView(
//                    topicId: topicId,
//                  );
//                }));
//              },
//              icon: new Icon(Icons.local_activity),
//            ),
//            new IconButton(
//              onPressed: () => Navigator.of(context).push(
//                      MaterialPageRoute<void>(builder: (BuildContext context) {
//                    return SelectOpponentScreen(
//                      gameName: 'quiz_pager',
//                    );
//                  })),
//              icon: new Icon(Icons.games),
//            ),
//            new IconButton(
//              onPressed: () {
//                Navigator.of(context).push(
//                    MaterialPageRoute<void>(builder: (BuildContext context) {
//                  return RelatedPage(
//                    topicId: topicId,
//                  );
//                }));
//              },
//              icon: new Icon(Icons.find_replace),
//            )
//          ],
//        ),
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 256.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(topicName),
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  tag: 'topic/${topicId}',
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
        TopicCardView(topicId: topicId)
      ],
    ));
  }
}
