import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/story/custom_editable_text.dart';

class TextHighlighter extends StatefulWidget {
  final String text;
  final Function(String) onCorrectAnswer;
  TextHighlighter({this.text = "Text Highlighter", this.onCorrectAnswer});
  @override
  _TextHighlighterState createState() => _TextHighlighterState();
}

class _TextHighlighterState extends State<TextHighlighter> {
  int _baseOffset = 0;
  bool highlightOnLongPress = false;
  String _startSubString = '', _middleSubString = '', _endSubString = '';
  int highlightIndex = -1;
  void _startOffset(TextSelection t) => _baseOffset = t.base.offset;

  void _updateOffset(int extendOffset) {
    if (_baseOffset < extendOffset)
      setState(() {
        _middleSubString = widget.text.substring(_baseOffset, extendOffset);
        _startSubString = widget.text.substring(0, _baseOffset);
        _endSubString = widget.text.substring(extendOffset, widget.text.length);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          " Question.............",
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: _startSubString,
                      style:
                          TextStyle(fontSize: 23, color: Colors.transparent)),
                  TextSpan(
                      text: _middleSubString,
                      style: TextStyle(
                          fontSize: 23,
                          background: Paint()..color = Colors.red,
                          color: Colors.transparent)),
                  TextSpan(
                      text: _endSubString,
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 23,
                      ))
                ],
              ),
            ),
            CustomEditableText(
                textAlign: TextAlign.center,
                controller: CustomTextEditingController(text: widget.text),
                focusNode: FocusNode(),
                cursorColor: Colors.transparent,
                style: TextStyle(color: Colors.black, fontSize: 23),
                backgroundCursorColor: Colors.transparent,
                maxLines: null,
                dragStartBehavior: DragStartBehavior.start,
                startOffset: (s) => _startOffset(s),
                updateOffset: (o) => _updateOffset(o.extentOffset),
                draEnd: (t) {
                  _baseOffset = t.base.offset;
                  _updateOffset(t.extent.offset);
                  widget.onCorrectAnswer(_middleSubString);
                },
                onLongPress: (s, textSelection) {}),
          ],
        )
      ],
    );
  }
}
