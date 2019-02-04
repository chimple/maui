import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math';
import 'package:maui/loca.dart';

class ChildLock extends StatefulWidget {
  @override
  _ChildLockState createState() => _ChildLockState();
}

class _ChildLockState extends State<ChildLock> {
  String _answer = "";
  int _rightAnswer;
  String _question;
  bool _isLoading = true;
  double _height;
  double _width;
  String _number1, _number2;
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

  void _initializeData() {
    _choices.shuffle();

    _digits.shuffle();
    _number1 = _digits[1] + _choices[1];
    _number2 = _digits[0] + _choices[3];

    setState(() => _isLoading = false);
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
                  Loca.of(context).forParents,
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
                  getParentsAccessData(context, _number1, _number2),
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
                      Loca.of(context).submit,
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

  String getParentsAccessData(BuildContext context, String num1, String num2) {
    String word1, word2;
    String operand1, operand2, operator1, operator2;
    String questionPart;
    word1 = convertToWords(num1);
    word2 = convertToWords(num2);
    operand1 = Loca.of(context).intl(word1);
    operand2 = Loca.of(context).intl(word2);
    operator1 = Loca.of(context).plus;
    operator2 = Loca.of(context).minus;
    questionPart = Loca.of(context).whatWillBe;

    var random = new Random();
    var randomCase = random.nextInt(max(0, 2));

    if (int.parse(num1) < int.parse(num2) && randomCase == 1) {
      randomCase = 0;
    }
    if (randomCase == 0) {
      _rightAnswer = int.parse(num1) + int.parse(num2);
    } else
      _rightAnswer = int.parse(num1) - int.parse(num2);
   
    if (Loca.of(context).plus == 'plus') {
      switch (randomCase) {
        case 0:
          return "$questionPart '$operand1' $operator1 '$operand2' ?";
          break;
        case 1:
          return "$questionPart '$operand1' $operator2 '$operand2' ?";
          break;
      }
    } else {
      switch (randomCase) {
        case 0:
          return "'$operand1' $operator1 '$operand2' $questionPart ?";
          break;
        case 1:
          return "'$operand1' $operator2 '$operand2' $questionPart ?";
          break;
      }
    }
    return null;
  }

// function to convert number into words upto 3 digits
  String convertToWords(String digit) {
    int len = digit.length;
    int x = 0;
    String word = '';

    List<String> singleDigit = [
      "Zero",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine"
    ];
    List<String> twoDigits = [
      "",
      "ten",
      "eleven",
      "twelve",
      "thirteen",
      "fourteen",
      "fifteen",
      "sixteen",
      "seventeen",
      "eighteen",
      "nineteen"
    ];
    List<String> tensMultiple = [
      "",
      "",
      "twenty",
      "thirty",
      "forty",
      "fifty",
      "sixty",
      "seventy",
      "eighty",
      "ninety"
    ];
    List<String> tensPower = ["hundred", "thousand"];

    if (len == 1) {
      return singleDigit[int.parse(digit[0])];
    }

    if (len == 0) {
      return null;
    }
    if (len > 4) {
      return null;
    }
    while (x <= digit.length) {
      if (len >= 3) {
        if (int.parse(digit[x]) != 0) {
          word =
              singleDigit[int.parse(digit[x])] + " " + tensPower[len - 3] + " ";
        }
        --len;
      } else {
        if (int.parse(digit[x]) == 1) {
          int sum = int.parse(digit[x]) + int.parse(digit[x + 1]);
          return twoDigits[sum];
        } else if (int.parse(digit[x]) == 2 && int.parse(digit[x + 1]) == 0) {
          return "twenty";
        } else {
          int i = int.parse(digit[x]);
          if (i > 0) {
            word = tensMultiple[i];
          } else
            print("");
          ++x;
          if (int.parse(digit[x]) != 0) {
            word = word + singleDigit[int.parse(digit[x])];
          }
          return word;
        }
      }
      ++x;
    }
    return null;
  }
}
