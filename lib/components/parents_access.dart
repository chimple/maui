import 'package:flutter/material.dart';
import 'package:maui/repos/parents_access_repo.dart';
import 'package:tuple/tuple.dart';

class ChildLock extends StatefulWidget {
  @override
  _ChildLockState createState() => _ChildLockState();
}

class _ChildLockState extends State<ChildLock> {
  Tuple2<String, List<dynamic>> _getdata;
  String _rightAnswer = "";
  String _question;
  bool _isLoading = true;
  double _height;
  double _width;
  final List _choices = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    _getdata = await getParentsAccessData();
    _question = _getdata.item1;
    _choices.shuffle();
    setState(() => _isLoading = false);
  }

  Widget _optionButton(String ans) {
    return FloatingActionButton(
      child: Text(
        "$ans",
        style: TextStyle(
          fontSize: 25.0,
        ),
      ),
      onPressed: () {
        setState(() {
          if (_rightAnswer.length < 3) {
            _rightAnswer = _rightAnswer + ans;
          }
        });
        // print("_rightAnswer ================= $_rightAnswer");
      },
    );
  }
  Widget _questionFrame(){
    
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        child: new CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _height = constraints.maxHeight;
        _width = constraints.maxWidth;
        return Card(
          color: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(constraints.maxHeight * 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  child: const Text(
                    "For Parents",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.white,
                  // height: 0.0,
                ),
              ),
              Text(
                "$_question",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              Container(
                child: Text(
                  "$_rightAnswer",
                  style: new TextStyle(
                    color: Colors.black87,
                    fontSize: _height * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                width: _width * 0.4,
                height: _height * 0.1,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: _choices
                    .map((a) => Padding(
                          padding: EdgeInsets.all(8.0),
                          child: _optionButton(a),
                        ))
                    .toList(growable: false),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text(
                    "SUBMIT",
                    style: TextStyle(color: Colors.orange, fontSize: 20.0),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  color: Colors.yellow[300],
                  onPressed: () {
                    setState(() {
                      _rightAnswer = '';
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
