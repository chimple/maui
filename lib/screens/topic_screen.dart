import 'package:flutter/material.dart';
import 'package:maui/repos/article_repo.dart';
import 'package:maui/db/entity/article.dart';

class TopicScreen extends StatefulWidget {
  @required String topicName;
  @required String topicId;
  TopicScreen({key, this.topicName, this.topicId}) : super(key: key);

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  List<Article> _articles;
  bool _isLoading = true;

  void _initTopic() async {
    new ArticleRepo()
        .getArticlesByTopicId(widget.topicId)
        .then((articles) async {
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTopic();
  }

  @override
  Widget build(BuildContext context) {
    print("<<<<<<<<<<<<<<<$_articles>>>>>>>>>>>>>>>>>>>");
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.topicName),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
        elevation: 5.0,
        actions: <Widget>[
          new IconButton(
            onPressed: () => print("object"),
            icon: new Icon(Icons.local_activity),
          ),
          new IconButton(
            onPressed: () => print("object"),
            icon: new Icon(Icons.games),
          ),
          new IconButton(
            onPressed: () => print("object"),
            icon: new Icon(Icons.find_replace),
          )
        ],
      ),
      body: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new IconButton(
              onPressed: () => print("object"),
              icon: new Icon(Icons.arrow_left),
              iconSize: 50.0,
            ),
          ),
          _isLoading == false
              ? new Expanded(
                  flex: 16,
                  child: new Container(
                    color: Colors.green,
                  ),
                )
              : new Expanded(
                  flex: 16,
                  child: new CircularProgressIndicator(),
                ),
          new Expanded(
            flex: 1,
            child: new IconButton(
              onPressed: () => print("object"),
              icon: new Icon(Icons.arrow_right),
              iconSize: 50.0,
            ),
          )
        ],
      ),
    );
  }
}
