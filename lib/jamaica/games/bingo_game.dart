import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  int index;
  String choice;
  Reaction reaction;
  _Type type;
  bool solved;

  _ChoiceDetail({
    this.index,
    this.choice,
    this.type = _Type.choice,
    this.reaction = Reaction.success,
    this.solved = false,
  });
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, type: $type, solved: $solved, reaction: $reaction)';
}

enum _Type { choice, question }

class BingoGame extends StatefulWidget {
  final Map<String, String> choices;
  final OnGameUpdate onGameUpdate;

  const BingoGame({Key key, this.choices, this.onGameUpdate}) : super(key: key);

  @override
  _BingoGameState createState() => _BingoGameState();
}

class _BingoGameState extends State<BingoGame> {
  List<String> choiceDetails = [];
  List<String> questionDetails = [];
  List<String> _shuffledLetters = [];
  List<_ChoiceDetail> cDetails, qDetails;
  int count = 0;
  var ques;
  var i = 0, j = 0;
  static int _maxSize = 2;
  var _referenceMatrix;
  List _letters = [];
  bool _bingo = false;
  int score = 0;
  int attempt = 0;

  @override
  void initState() {
    super.initState();

    widget.choices.forEach((e, v) {
      choiceDetails.add(e);
      questionDetails.add(v);
    });

    ques = questionDetails[0];
    if (choiceDetails.length <= 8) {
      _maxSize = 2;
    } else if (choiceDetails.length < 16) {
      _maxSize = 3;
    } else {
      _maxSize = 4;
    }

    _referenceMatrix = new List.generate(_maxSize, (_) => new List(_maxSize));
    for (var i = 0; i < choiceDetails.length; i += _maxSize * _maxSize) {
      _shuffledLetters.addAll(choiceDetails
          .skip(i)
          .take(_maxSize * _maxSize)
          .toList(growable: false));
    }
    _letters = choiceDetails.sublist(0, _maxSize * _maxSize);
    _letters.shuffle();
    int k = 0;
    cDetails = _letters
        .map((c) => _ChoiceDetail(choice: c, type: _Type.choice, index: k++))
        .toList(growable: false);

    qDetails = questionDetails
        .map((e) => _ChoiceDetail(
            choice: e, type: _Type.question, reaction: Reaction.success))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      qRows: 1,
      qCols: 1,
      qChildren: <Widget>[
        CuteButton(
          key: UniqueKey(),
          reaction: Reaction.success,
          child: Center(
            child: Text("$ques"),
          ),
          onPressed: () {},
        ),
      ],
      rows: _maxSize,
      cols: _maxSize,
      children: cDetails
          .map((c) => CuteButton(
                key: Key(c.index.toString()),
                reaction: c.reaction,
                child: Center(child: Text(c.choice)),
                onPressed: () {
                  _checkTheanswer(c.index, c.choice);
                },
              ))
          .toList(growable: false),
    );
  }

  _checkTheanswer(int index, String choice) {
    var str1 = choiceDetails.indexOf(choice);
    var str2 = questionDetails.indexOf(ques);

    if (str1 == str2) {
      setState(() {
        count++;
        score = score + 2;
      });
      ques = questionDetails[count];
      int counter = 0;
      for (int i = 0; i < _maxSize; i++) {
        for (int j = 0; j < _maxSize; j++) {
          if (counter == index) {
            _referenceMatrix[i][j] = 1;
          }
          counter++;
        }
      }
      var matchRow = bingoHorizontalChecker();
      var matchColumn = bingoVerticalChecker();

      if (-1 != matchRow) {
        if (matchRow == 0 ||
            matchRow == 1 ||
            matchRow == 2 ||
            matchRow == 3 ||
            matchRow == 4 ||
            matchRow == 5) {
          matchRow = _maxSize * matchRow;
          for (i = matchRow; i < _maxSize + matchRow; i++) {
            setState(() {
              print("bingo row succesfulllll");
              _bingo = true;
            });
          }
        }
      }
      if (-1 != matchColumn) {
        if (matchColumn == 0 ||
            matchColumn == 1 ||
            matchColumn == 2 ||
            matchColumn == 3 ||
            matchColumn == 4 ||
            matchColumn == 5) {
          for (i = matchColumn; i < _maxSize * _maxSize; i++) {
            setState(() {
              print("bingo horizonatal succesfulllll");
              _bingo = true;
              i = i + _maxSize - 1;
            });
          }
        }
      }
      if (_bingo == true) {
        widget.onGameUpdate(
            score: score, max: _maxSize * 4, gameOver: true, star: true);
      }
    } else if (str1 != str2) {
      score = score - 1;
      attempt++;
      if (attempt == (_maxSize / 2)) {
        widget.onGameUpdate(
            score: score, max: _maxSize * 4, gameOver: true, star: false);
      }
    }
  }

  int bingoHorizontalChecker() {
    for (int i = 0; i < _referenceMatrix.length; i++) {
      bool bingo = true;
      for (int j = 0; j < _referenceMatrix.length; j++) {
        if (_referenceMatrix[i][j] == null) {
          bingo = false;
          break;
        }
      }
      if (bingo) return i;
    }
    return -1;
  }

  int bingoVerticalChecker() {
    for (int j = 0; j < _referenceMatrix.length; j++) {
      bool bingo = true;
      for (int i = 0; i < _referenceMatrix.length; i++) {
        if (_referenceMatrix[i][j] == null) {
          bingo = false;
          break;
        }
      }
      if (bingo) return j;
    }
    return -1;
  }
}
