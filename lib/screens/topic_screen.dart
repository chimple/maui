import 'package:flutter/material.dart';
import 'package:maui/repos/article_repo.dart';
import 'package:tuple/tuple.dart';

class TopicScreen extends StatefulWidget {

  TopicScreen({key}):super(key:key);
  
  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {

  List<Tuple7<String, String, String, String, String, String, int >> _articles;

  void _initTopic() async {
    new ArticleRepo().getArticle('lion').then((_articles) async{
      if(_articles.text.isNotEmpty){
        print(_articles.text);

      }
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
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Topic"),
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
            new Expanded(
              flex: 16,
              child: new Container(
                color: Colors.green,
              ),
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