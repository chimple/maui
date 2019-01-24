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
  String _getWord1, _getWord2, _getWord3;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    _choices.shuffle();

    _number1 = _choices[3] + _choices[5];
    _number2 = _choices[1] + _choices[7];
    _number3 = _choices[2] + _choices[4];
    _getWord1 = await convertToWords(_number1);
    _getWord2 = await convertToWords(_number2);
    _getWord3 = await convertToWords(_number3);

    _getdata = await getParentsAccessData(_getWord1, _getWord2, _getWord3);
    _question = _getdata;

    if (_question.contains('plus')) {
      if ('plus'.allMatches(_question).length == 2) {
        _rightAnswer =
            int.parse(_number1) + int.parse(_number2) + int.parse(_number3);
      } else
        _rightAnswer = int.parse(_number1) + int.parse(_number2);
    } else
      _rightAnswer = int.parse(_number1) * int.parse(_number2);

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
          if (_answer.length < 3) {
            _answer = _answer + ans;
          }
        });
      },
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  child: const Text(
                    "For Parents",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.blueGrey,
                  // height: 0.0,
                ),
              ),
              Text(
                "$_question",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.red[700],
                ),
              ),
              Container(
                child: Text(
                  "$_answer",
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
                        fontSize: 20.0,
                      ),
                    ),
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    color: Colors.red[700],
                    onPressed: () {
                      if (_answer == _rightAnswer.toString()) {
                        setState(() {
                          _answer = 'R';
                        });
                      } else {
                        setState(() {
                          _answer = 'WRONG';
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
