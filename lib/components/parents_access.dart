import 'package:flutter/material.dart';
import 'package:maui/repos/parents_access_repo.dart';

class ChildLock extends StatefulWidget {
  @override
  _ChildLockState createState() => _ChildLockState();
}

class _ChildLockState extends State<ChildLock> {
  String _getdata;
  String _answer = "";
  int _rightAnswer;
  String _question;
  bool _isLoading = true;
  double _height;
  double _width;
  String _number1, _number2, _number3;
  final List<String> _choices = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];
  final List<String> _digits = ['1', '2'];
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    _choices.shuffle();

    _digits.shuffle();
    _number1 = _digits[1] + _choices[1];
    _number2 = _digits[0] + _choices[3];

    _getdata = await getParentsAccessData(_number1, _number2);
    _question = _getdata;

    if (_question.contains('plus')) {
      _rightAnswer = int.parse(_number1) + int.parse(_number2);
    } else
      _rightAnswer = int.parse(_number1) - int.parse(_number2);

    setState(() => _isLoading = false);
  }

  Widget _optionButton(String ans, double height, double width) {
    return SizedBox(
      height: height * 0.1,
      width: width * 0.1,
      child: FloatingActionButton(
        child: Text(
          "$ans",
          style: TextStyle(
            fontSize: height * 0.06,
          ),
        ),
        onPressed: () {
          setState(() {
            if (_answer.length < 3) {
              _answer = _answer + ans;
            }
          });
        },
      ),
    );
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
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(constraints.maxHeight * 0.08),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "For Parents",
                  style: TextStyle(
                    fontSize: _height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.blueGrey,
                  height: 0.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "$_question",
                  style: TextStyle(
                    fontSize: _height * 0.05,
                    color: Colors.yellow[800],
                  ),
                ),
              ),
              Container(
                child: Text(
                  "$_answer",
                  style: new TextStyle(
                    color: Colors.black87,
                    fontSize: _height * 0.07,
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
                          child: _optionButton(a, _height, _width),
                        ))
                    .toList(growable: false),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  width: _width * 0.3,
                  height: _height * 0.1,
                  child: RaisedButton(
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: _height * 0.04,
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    color: Colors.yellow[800],
                    onPressed: () {
                      if (_answer == _rightAnswer.toString()) {
                        setState(() {
                          _answer = 'Right';
                        });
                      } else {
                        setState(() {
                          _answer = '';
                          _initializeData();
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
