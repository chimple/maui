import 'package:flutter/material.dart';
import 'package:maui/components/topic_page_view.dart';

class ArticleScreen extends StatelessWidget {
  final String topicId;
  final String topicName;

  ArticleScreen({key, @required this.topicId, @required this.topicName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('topicId: $topicId');
    return new Scaffold(body: TopicPageView(topicId: topicId));
  }
}
