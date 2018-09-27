import 'package:flutter/material.dart';
import 'package:maui/loca.dart';
import 'package:maui/screens/activity_list_view.dart';
import 'package:maui/screens/related_page.dart';
import 'package:maui/screens/select_opponent_screen.dart';
import 'package:maui/components/topic_page_view.dart';


class TopicScreen extends StatelessWidget {
    final String topicId;
  final String topicName;
  TopicScreen({key, @required this.topicId, @required this.topicName})
      : super(key: key);
 @override
  Widget build(BuildContext context) {
    print('loca topic_screen ${Loca.of(context)}');
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(topicName),
          centerTitle: true,
          backgroundColor: Colors.teal[300],
          elevation: 5.0,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return ActivityListView(
                    topicId: topicId,
                  );
                }));
              },
              icon: new Icon(Icons.local_activity),
            ),
            new IconButton(
              onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return SelectOpponentScreen(
                      gameName: 'quiz_pager',
                    );
                  })),
              icon: new Icon(Icons.games),
            ),
            new IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return RelatedPage(
                    topicId: topicId,
                  );
                }));
              },
              icon: new Icon(Icons.find_replace),
            )
          ],
        ),
        body: new TopicPageView(topicId: topicId));
  }
}