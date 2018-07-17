import 'package:flutter/material.dart';
import 'package:maui/screens/chat_screen.dart';
import 'package:maui/components/categorized_scroller.dart';

final Map<String, List<String>> Stickers = {
  'assets/stickers/giraffe/giraffe.png': [
    'assets/stickers/giraffe/1.png',
    'assets/stickers/giraffe/10.png',
    'assets/stickers/giraffe/11.png',
    'assets/stickers/giraffe/12.png',
    'assets/stickers/giraffe/13.png',
    'assets/stickers/giraffe/14.png',
    'assets/stickers/giraffe/15.png',
    'assets/stickers/giraffe/16.png',
    'assets/stickers/giraffe/2.png',
    'assets/stickers/giraffe/3.png',
    'assets/stickers/giraffe/4.png',
    'assets/stickers/giraffe/5.png',
    'assets/stickers/giraffe/6.png',
    'assets/stickers/giraffe/7.png',
    'assets/stickers/giraffe/8.png',
    'assets/stickers/giraffe/9.png',
  ],
  'assets/stickers/pig/pig.png': [
    'assets/stickers/pig/1.png',
    'assets/stickers/pig/10.png',
    'assets/stickers/pig/11.png',
    'assets/stickers/pig/12.png',
    'assets/stickers/pig/13.png',
    'assets/stickers/pig/14.png',
    'assets/stickers/pig/15.png',
    'assets/stickers/pig/16.png',
    'assets/stickers/pig/2.png',
    'assets/stickers/pig/3.png',
    'assets/stickers/pig/4.png',
    'assets/stickers/pig/5.png',
    'assets/stickers/pig/6.png',
    'assets/stickers/pig/7.png',
    'assets/stickers/pig/8.png',
    'assets/stickers/pig/9.png',
  ],
  'assets/stickers/monkey/monkey.png': [
    'assets/stickers/monkey/1.png',
    'assets/stickers/monkey/10.png',
    'assets/stickers/monkey/11.png',
    'assets/stickers/monkey/12.png',
    'assets/stickers/monkey/13.png',
    'assets/stickers/monkey/14.png',
    'assets/stickers/monkey/15.png',
    'assets/stickers/monkey/16.png',
    'assets/stickers/monkey/2.png',
    'assets/stickers/monkey/3.png',
    'assets/stickers/monkey/4.png',
    'assets/stickers/monkey/5.png',
    'assets/stickers/monkey/6.png',
    'assets/stickers/monkey/7.png',
    'assets/stickers/monkey/8.png',
    'assets/stickers/monkey/9.png',
  ]
};

class SelectSticker extends StatelessWidget {
  final OnUserPress onUserPress;

  const SelectSticker({this.onUserPress});

  @override
  Widget build(BuildContext context) {
    return CategorizedScroller(
      onUserPress: onUserPress,
      items: Stickers,
      itemCrossAxisCount: 2,
      buildItem: buildItem,
      buildIndexItem: buildIndexItem,
    );
  }

  Widget buildItem(String text, bool enabled) {
    return Image.asset(text);
  }

  Widget buildIndexItem(String text, bool enabled) {
    return Image.asset(text);
  }
}
